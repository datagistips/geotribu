# Accessibility ----
isAccessible <- function(link) {
  grepl("^\\!\\[(.*)\\]\\(.* \".*\"\\)$", link)
}

addAccessibility <- function(imgLink) {
  
  # On récupère la fin de l'URL
  # Par ex. pour "![](https://cdn.geotribu.fr/img/logos-icones/logiciels_librairies/gdal.png)"
  # On prend gdal.png
  stem <- gsub("\\!\\[.*\\]\\(.*/(.*)\\).*", "\\1", imgLink)
  
  # Le nom est gdal (on splitte par le point .)
  imageName <- strsplit(stem, "\\.")[[1]][1]
  # On remplace certains caractères par des espaces
  imageName <- gsub("-", " ", imageName)
  imageName <- gsub("_", " ", imageName)
  
  # On extrait la description de l'image si elle existe
  # A savoir le alt.
  # imgLink <- "![](https://cdn.geotribu.fr/img/logos-icones/logiciels_librairies/gdal.png)"
  description <- gsub("\\!\\[(.*)\\].*", "\\1", imgLink)
  # Si la description est vide, on y met le nom de l'image (sans l'extension)
  description <- ifelse(description == "", imageName, description)
  
  # On récupère le lien http://...
  link <- gsub("^.*\\((.*)\\).*", "\\1", imgLink)
  
  # La première partie est celle entre crochets : ![toto]
  # Si la description est vide, on y met le nom de l'image (sans l'extension)
  part1 <- sprintf("![%s]", description)
  
  # La seconde partie est celle entre parenthèses.
  # On y ajoute le nom de l'image
  part2 <- sprintf("(%s \"%s\")", link, description)
  
  # On colle les deux parties
  newLink <- paste0(part1, part2)
  
  return(newLink)
}

reformatLinks <- function(lines) {
  newLines <- lines
  for(i in 1:length(lines)) {
    myLine <- lines[i]
    httpLinks <- str_extract_all(myLine, "\\[\\S*\\s?\\S*\\]\\(\\S+\\)") %>% unlist
    imageLinks <- str_extract_all(myLine, "\\!\\[\\S*\\s?\\S*\\]\\(\\S+\\)") %>% unlist
    for(imgLink in imageLinks) {
      if(!isAccessible(imgLink)) {
        newImgLink <- addAccessibility(imgLink)
        message(imgLink, "\ndevient\n", newImgLink)
        newLines[i] <- str_replace(newLines[i], fixed(imgLink), newImgLink) # !! fixed
        message("---")
      }
    }
  }
  return(newLines)
}

# Leading space ----
removeLeadingSpace <- function(myLine) {
  trimws(myLine, which = "left")
}

reformatLine <- function(myLine) {
  
  newLine <- NULL
  
  # Avec hashtags ou pas
  if(isNotWellFormatted1(myLine)) {
    newLine <- reformatTitle1(myLine)
  }
  
  # Avec une image au début
  if(isNotWellFormatted2(myLine)) {
    newLine <- reformatTitle2(myLine)
  }
  
  return(newLine)
}

reformatLeadingSpace <- function(lines) {
  newLines <- lines
  for(i in 1:length(lines)) {
    myLine <- lines[i]
    # Suppression des espaces au début
    if(isNotWellFormatted3(myLine)) {
      newLines[i] <- removeLeadingSpace(myLine)
    }
  }
  return(newLines)
}

readRdp <- function(rdp) {
  con <- file(rdp, "r", encoding = "UTF-8")
  lines <- readLines(con)
  close(con)
  return(lines)
}

writeRdp <- function(lines, repairedRdp) {
  con <- file(repairedRdp, encoding = "UTF-8")
  writeLines(lines, con)
  close(con)
}

relevelTitles <- function(lines) {
  for(j in 1:length(lines)) {
    myLine <- lines[j]
    if(grepl("\\#\\#\\#\\#.*", myLine)) {
      print("NIVEAU")
      w <- (j+1:(j+10))
      myLines <- lines[w]
      w <- which(myLines == "" | grepl("\\{\\: \\.img-rdp-news-thumb \\}", myLines))
      myLines <- myLines[-w]
      w <- grep("\\#+", myLines)
      myLines <- myLines[w]
      if(grepl("\\#\\#\\#\\s.*", myLines[1])) {
        newLine <- str_replace(myLine,"^####\\s(.*)", "## \\1")
        lines[j] <- newLine
        message(paste0(myLine, "\n=>\n", newLine))
        message("\n")
        # writeLog(logFile, myLine, newLine)
      }
    }
  }
  return(lines)
}

reformatTitles <- function(lines) {
  newLines <- vector(mode = "list")
  for(i in 1:length(lines)) {
    myLine <- lines[i]
    
    newLine <- reformatLine(myLine)
    
    # Réaffectation
    if(is.null(newLine)) {
      newLines[i] <- myLine
    } else {
      newLines[[i]] <- newLine
    }
  }
  
  res <- unlist(newLines)
  return(res)
}

reformatRdp <- function(rdp, outputFolder, inputEncoding = "UTF-8") {
  
  # Variables
  year <- gsub("^.*rdp_([0-9]*).*$", "\\1", rdp) %>% as.integer()
  
  # Lecture de la RDP
  lines <- readRdp(rdp)
  
  # File name
  fileName <- gsub("^.*/(.*\\.md)$", "\\1", rdp)
  
  # Log file
  logFile <- file.path(outputFolder, year, gsub(".md", "-log.md", fileName))
  if(file.exists(logFile)) file.remove(logFile)
  
  # CORRECTION DES TITRES EN GRAS -> H3
  lines <- reformatTitles(lines)
  
  # NIVEAUX DE TITRES H4 -> H3
  lines <- relevelTitles(lines)
  
  # CORRECTION DES ESPACES DEVANT
  lines <- reformatLeadingSpace(lines)
  
  # RELOCATE THUMBNAILS
  lines <- relocateThumbs(lines)
  
  # REFORMAT LINKS
  lines <- reformatLinks(lines)
  
  # Export de la nouvelle version
  repairedRdp <- file.path(outputFolder, year, fileName)
  writeRdp(lines, repairedRdp)
  message("\n")
  
  # Récupérer les images d'un article (expérimental)
  # test <- lines[85]
  # getImgs(test)
  
}


myLine <- "![logo-gvsig_150_14.gif](http://geotribu.net/sites/default/files/Tuto/img/divers/logo-gvsig_150_14.gif)**Filtres temporels dans GvSIG"

# myLine <- "### L'Open Data en image** tototototo"
# myLine <- "## L'Open Data en image** tototototo"
# myLine <- "L'Open Data en image** tototototo"
# myLine <- " **OpenLayers Mobile**"
isNotWellFormatted1 <- function(myLine) {
  grepl("^(###?\\s)?.*\\*\\*", myLine)
}

# Espaxces devant, à l'exception du YAML du début (4 espaces)
isNotWellFormatted3 <- function(myLine) {
  grepl("^\\s{1,2}(\\#|\\!|\\[|[a-z]|[A-Z]|[0-9])", myLine, perl = TRUE)
}

# countHashtags("## L'Open Data en image** tototototo")
# countHashtags("### L'Open Data en image** tototototo")
# countHashtags("#### L'Open Data en image** tototototo")
countHashtags <- function(myLine) {
  n <- 0
  for(i in 1:4) {
    hashtags <- paste(rep("#", i), collapse="")
    if(grepl(sprintf("^%s\\s.*", hashtags), myLine)) n <- i
  }
  return(n)
}

writeLog <- function(logFile, myLine, newLine) {
  write(myLine, file = logFile, append = TRUE)
  write("\n\ndevient\n\n", file = logFile, append = TRUE)
  write(newLine, file = logFile, append = TRUE)
  write("\n----", file = logFile, append = TRUE)
}

# "![logo-gvsig_150_14.gif](http://geotribu.net/sites/default/files/Tuto/img/divers/logo-gvsig_150_14.gif)**gvSIG** La 7ème édition des journées "
isNotWellFormatted2 <- function(myLine) {
  regex <- "\\s?(\\!\\[.*\\]\\(.*\\))\\*\\*(.*)\\*?\\*?(.*)"
  grepl(regex, myLine)
}

reformatTitle2 <- function(myLine) {
  #  ![logo-gvsig_150_14.gif](http://geotribu.net/sites/default/files/Tuto/img/divers/logo-gvsig_150_14.gif)**gvSIG**
  regex1 <- "\\s?(\\!\\[.*\\]\\(.*\\))\\*\\*(.*)\\*\\*(.*)"
  
  #  ![](http://www.geotribu.net/sites/default/files/Tuto/img/Blog/liftarn_Witch_with_crystal_ball.jpg)**Madame Irma en direct
  regex2 <- "\\s?(\\!\\[.*\\]\\(.*\\))\\*\\*(.*)"  
  
  if(grepl(regex1, myLine)) {
    title <- str_replace(myLine, regex1, "### \\2")
    img <- str_replace(myLine, regex1, "\\1{: .img-rdp-news-thumb }")
    body <- str_replace(myLine, regex1, "\\3")
    return(list(title, img, body))
  } else if (grepl(regex2, myLine)) {
    title <- str_replace(myLine, regex2, "### \\2")
    img <- str_replace(myLine, regex2, "\\1{: .img-rdp-news-thumb }")
    return(list(title, img))
  }
}

relocateThumbs <- function(lines) {
  newLines <- lines
  for(i in 1:length(lines)) {
    myLine <- lines[i]
    if(grepl("^\\!\\[.*\\]\\(.*\\)\\{\\: \\.img-rdp-news-thumb \\}$", myLine)) {
      print(i)
      # On extrait un échantillon des textes
      # jusqu'à la 5e ligne
      w <- c(i:(i+5))
      myLines <- lines[w]
      # on vérifie si l'élément qui vient juste après est un titre
      w <- w[which(myLines != "")][2] 
      # Si c'est un titre...
      if(grepl("^\\#+.*", lines[w])) {
        title <- lines[w]
        img <- lines[i]
        #...on ajoute l'image dans le corps de l'article
        newLines[w] <- paste0(title, "\n\n", img, "\n") # !! utiliser plutôt une liste
        # On commente la ligne originelle qui comprend l'image
        newLines[i] <- sprintf("<!--%s-->", img)
      }
    }
  }
  
  # Clean : on enlève les éléments qui sont NA
  # w <- which(sapply(newLines, is.na))
  
  # res <- unlist(newLines)
  
  return(newLines)
}

getNotWellFormatted <- function(lines) {
  w <- which(sapply(1:length(lines), function(x) isNotWellFormatted(lines[[x]])))
  return(list(w = w, lines = lines[w]))
}

reformatTitle1 <- function(myLine) {
  hashtags <- rep("#", countHashtags(myLine)) %>% paste(collapse="")
  if(hashtags == "") {
    regex <- "^\\s?(?:\\*\\*)?(.*)\\*\\*\\s?(.*)$"
    title <- str_replace(myLine, regex, "### \\1")
    body <- str_replace(myLine, regex, "\\2")
  } else {
    regex <- sprintf("^(?:%s?\\s)?(.*)\\*\\*\\s?(.*)$", hashtags)
    title <- str_replace(myLine, regex, sprintf("%s \\1", hashtags))
    body <- str_replace(myLine, regex, "\\2")
  }
  return(list(title, body))
}

# Liste les fichiers du dossier, pour l'année concernée
listRdpsForYear <- function(year) {
  rdps <- list.files(sprintf("%s/%d", inputFolder, year), full.names = T)
  rdps <- rdps[which(grepl("^(?!.*(new|old)).*$", rdps, perl = TRUE))]
  rdps
}

imgPar <- function(img) {
  regex <- "^.*!\\[(.*)\\]\\((.*)\\).*$"
  imgLogo <- gsub(regex, "\\1", img)
  
  s <- gsub("^.*!\\[(.*)\\]\\((.*)\\).*$", "\\2", img)
  imgUrl <- gsub("^(.*)\\s?\\\"(.*)\\\"$", "\\1", s)
  imgCat <- gsub("^(.*)\\s?\\\"(.*)\\\"$", "\\2", s)
  
  img <- list(imgLogo = imgLogo, imgUrl = imgUrl, imgCat = imgCat)
  return(img)
}

buildRegex <- function(i) {
  sprintf(".*%s.*", paste(rep(regex, i), collapse=".*"))
}

countLinks <- function(test) {
  r <- "(!\\[.*\\]\\(.*\\))"
  n <- 0
  for(i in 1:5) {
    r2 <- buildRegex(i)
    if(grepl(r2, test)) n <- i
  }
  return(n)
}

# myLine <- "![logo1 globe1](https://cdn.geotribu.fr/img/internal/icons-rdp-news/world.png \"Icône de globe\") ![logo2 globe2](https://cdn.geotribu.fr/img/internal/icons-rdp-news/world.png \"Icône de globe\"){: .img-rdp-news-thumb }"
# getImgs(myLine)
getImgs <- function(test) {
  n <- countLinks(test)
  out <- vector(mode="list")
  for(i in 1:n) {
    imgLink <- gsub(buildRegex(n), sprintf("\\%d", i), test)
    out[[i]] <- imgPar(imgLink)
  }
  return(out)
}

cleanYear <- function(year) {
  l <- list.files(sprintf("%s/%d", inputFolder, year), "-new.md", full.names = T)
  for(elt in l) {
    file.rename(elt, gsub("-new.md", ".md", elt))
    file.remove(elt)
  }
}