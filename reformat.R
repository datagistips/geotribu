library(tidyverse)
library(stringr)
source("helpers.R", encoding = "UTF-8")

rdpFolder <<- "../../website/content/rdp"

reformatYear <- function(year) {
  
  # Liste les fichiers du dossier, pour l'année concernée
  rdps <- list.files(sprintf("%s/%d", rdpFolder, year), full.names = T)
  rdps <- rdps[which(grepl("^(?!.*(new|old)).*$", rdps, perl = TRUE))] # only not new and not old files
  
  # Transformation fichier par fichier
  for(i in 1:length(rdps)) {
    message(">> ", i)
    rdp <- rdps[i]
    
    reformatRdp <- function(rdp) {
      
      # Lecture de la RDP
      con <- file(rdp, "r", encoding = "UTF-8")
      lines <- readLines(con)
      close(con)
      
      # File name
      fileName <- gsub("^.*/(.*\\.md)$", "\\1", rdp)
      message("Analyse du fichier ", fileName)
      
      # Log file
      logFile <- file.path(rdpFolder, gsub(".md", "-log.md", fileName))
      if(file.exists(logFile)) file.remove(logFile)
      
      for(j in 1:length(lines)) {
        myLine <- lines[j]
        newLine <- NULL
        
        # Hashtags
        if(isNotWellFormatted(myLine)) {
          newLine <- reformatTitle(myLine)
        }
        
        if(isNotWellFormatted2(myLine)) {
          newLine <- reformatTitle2(myLine)
        }
        
        # Réaffectation
        if(is.null(newLine)) {
          lines[j] <- myLine
        } else {
          lines[j] <- newLine
          message(paste0(substr(myLine, 1, 100), "=>", substr(newLine, 1, 100)))
          writeLog(logFile, myLine, newLine)
        }
      }
      
      # Export de la nouvelle version ---
      repairedRdp <- gsub(".md", "-new.md", rdp)
      con <- file(repairedRdp)
      writeLines(lines, con)
      close(con)
      
      # Image
      # test <- lines[85]
      # getImgs(test)
    }
    reformatRdp(rdp)
  }
}

reformatYear(2011)