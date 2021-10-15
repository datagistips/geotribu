myLine <- "![logo-gvsig_150_14.gif](http://geotribu.net/sites/default/files/Tuto/img/divers/logo-gvsig_150_14.gif)**Filtres temporels dans GvSIG"

isNotWellFormatted <- function(myLine) {
  grepl("^(###?\\s)?.*\\*\\*", myLine)
}

# myLine <- "### L'Open Data en image** tototototo"
# myLine <- "## L'Open Data en image** tototototo"
isNotWellFormatted2 <- function(myLine) {
  grepl("^###?\\s?\\*\\*", myLine)
}

# myLine <- "L'Open Data en image** tototototo"
isNotWellFormatted3 <- function(myLine) {
  grepl("^\\s?(.*)\\*\\*(.*)", myLine)
}

# myLine <- " **OpenLayers Mobile**"
isNotWellFormatted4 <- function(myLine) {
  grepl("^\\s?\\*\\*.*\\*\\*", myLine)
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

getNotWellFormatted <- function(lines) {
  w <- which(sapply(1:length(lines), function(x) isNotWellFormatted(lines[[x]])))
  return(list(w = w, lines = lines[w]))
}

reformatTitle <- function(myLine) {
  hashtags <- rep("#", countHashtags(myLine)) %>% paste(collapse="")
  if(hashtags == "") {
    regex <- "^\\s?(?:\\*\\*)?(.*)\\*\\*\\s?(.*)$"
    str_replace(myLine, regex, "### \\1\n\\2")
  } else {
    regex <- sprintf("^(?:%s?\\s)?(.*)\\*\\*\\s?(.*)$", hashtags)
    str_replace(myLine, regex, sprintf("%s \\1\n\\2", hashtags))
  }
}

# reformatTitle(myLine)

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

# s <- "![logo1 globe1](https://cdn.geotribu.fr/img/internal/icons-rdp-news/world.png \"Icône de globe\") ![logo2 globe2](https://cdn.geotribu.fr/img/internal/icons-rdp-news/world.png \"Icône de globe\"){: .img-rdp-news-thumb }"
# getImgs(s)
getImgs <- function(test) {
  n <- countLinks(test)
  out <- vector(mode="list")
  for(i in 1:n) {
    imgLink <- gsub(buildRegex(n), sprintf("\\%d", i), test)
    out[[i]] <- imgPar(imgLink)
  }
  return(out)
}