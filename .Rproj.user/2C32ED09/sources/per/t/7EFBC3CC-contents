library(tidyverse)
library(stringr)
source("helpers.R", encoding = "UTF-8")

rdpFolder <<- "../website/content/rdp"

reformatYear <- function(year) {
  # Liste les fichiers du dossier, pour l'année concernée
  l <- list.files(sprintf("%s/%d", rdpFolder, year), full.names = T)
  l <- l[which(grepl("^(?!.*(new|old)).*$", l, perl = TRUE))] # only not new and not old files
  
  # Transformation fichier par fichier
  for(i in 1:length(l)) {
    print(i)
    # i <- 51
    fileName <- gsub(".*/(.*)$", "\\1", l[i])
    
    message("Analyse du fichier ", fileName)
    
    # Lecture du fichier
    f <- l[i]
    con <- file(f, "r", encoding = "UTF-8")
    lines <- readLines(con)
    length(lines)
    close(con)
    
    # Line by Line
    # res <- getNotWellFormatted(lines)
    
    for(i in 1:length(lines)) {
      myLine <- lines[i]
      
      
      if(isNotWellFormatted(myLine)) {
        message("pre1 : ", substr(lines[i], 1, 50))
        lines[i] <- reformatTitle(myLine)
        message("post1 : ", substr(lines[i], 1, 50))
      }
      
      # "![logo-gvsig_150_14.gif](http://geotribu.net/sites/default/files/Tuto/img/divers/logo-gvsig_150_14.gif)**gvSIG** La 7ème édition des journées "
      regex <- "(\\!\\[.*\\]\\(.*\\))\\*\\*(.*)\\*?\\*?(.*)"
      if(grepl(regex, myLine)) {
        message("pre2 : ", substr(lines[i], 1, 50))
        lines[i] <- str_replace(myLine, regex, "\\1{: .img-rdp-news-thumb }\n\n### \\2\n\\3")
        message("post2 : ", substr(lines[i], 1, 50))
      }
    }
    
    # Export ---
    outputName <- gsub(".md", "-new.md", f)
    con <- file(outputName)
    writeLines(lines, con)
    close(con)
    
    # Image
    # test <- lines[85]
    # getImgs(test)
  }
}

reformatYear(2011)