reformatRdp <- function(rdp) {
  
  # Lecture de la RDP
  con <- file(rdp, "r", encoding = "UTF-8")
  lines <- readLines(con)
  close(con)
  
  # File name
  fileName <- gsub("^.*/(.*\\.md)$", "\\1", rdp)
  
  # Log file
  logFile <- file.path(rdpFolder, gsub(".md", "-log.md", fileName))
  if(file.exists(logFile)) file.remove(logFile)
  
  for(j in 1:length(lines)) {
    myLine <- lines[j]
    
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
    
    newLine <- reformatLine(myLine)
    
    # Réaffectation
    if(is.null(newLine)) {
      lines[j] <- myLine
    } else {
      lines[j] <- newLine
      message(paste0(substr(myLine, 1, 100), "=>", substr(newLine, 1, 100)))
      writeLog(logFile, myLine, newLine)
    }
  }
  
  # Export de la nouvelle version
  repairedRdp <- gsub(".md", "-new.md", rdp)
  con <- file(repairedRdp)
  writeLines(lines, con)
  close(con)
  
  # Récupérer les images d'un article (expérimental)
  # test <- lines[85]
  # getImgs(test)
  message("\n")
}


myLine <- "![logo-gvsig_150_14.gif](http://geotribu.net/sites/default/files/Tuto/img/divers/logo-gvsig_150_14.gif)**Filtres temporels dans GvSIG"

# myLine <- "### L'Open Data en image** tototototo"
# myLine <- "## L'Open Data en image** tototototo"
# myLine <- "L'Open Data en image** tototototo"
# myLine <- " **OpenLayers Mobile**"
isNotWellFormatted1 <- function(myLine) {
  grepl("^(###?\\s)?.*\\*\\*", myLine)
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
  write("----", file = logFile, append = TRUE)
}

# "![logo-gvsig_150_14.gif](http://geotribu.net/sites/default/files/Tuto/img/divers/logo-gvsig_150_14.gif)**gvSIG** La 7ème édition des journées "
isNotWellFormatted2 <- function(myLine) {
  regex <- "\\s?(\\!\\[.*\\]\\(.*\\))\\*\\*(.*)\\*?\\*?(.*)"
  grepl(regex, myLine)
}

reformatTitle2 <- function(myLine) {
  regex <- "\\s?(\\!\\[.*\\]\\(.*\\))\\*\\*(.*)\\*?\\*?(.*)"
  str_replace(myLine, regex, "\\1{: .img-rdp-news-thumb \n### \\2\n\\3")
}

getNotWellFormatted <- function(lines) {
  w <- which(sapply(1:length(lines), function(x) isNotWellFormatted(lines[[x]])))
  return(list(w = w, lines = lines[w]))
}

reformatTitle1 <- function(myLine) {
  hashtags <- rep("#", countHashtags(myLine)) %>% paste(collapse="")
  if(hashtags == "") {
    regex <- "^\\s?(?:\\*\\*)?(.*)\\*\\*\\s?(.*)$"
    str_replace(myLine, regex, "### \\1\n\\2")
  } else {
    regex <- sprintf("^(?:%s?\\s)?(.*)\\*\\*\\s?(.*)$", hashtags)
    str_replace(myLine, regex, sprintf("%s \\1\n\\2", hashtags))
  }
}

# Liste les fichiers du dossier, pour l'année concernée
listRdpsForYear <- function(year) {
  rdps <- list.files(sprintf("%s/%d", rdpFolder, year), full.names = T)
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
  l <- list.files(sprintf("%s/%d", rdpFolder, year), "-new.md", full.names = T)
  for(elt in l) {
    file.rename(elt, gsub("-new.md", ".md", elt))
    file.remove(elt)
  }
}