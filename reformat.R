# Issue : https://github.com/geotribu/website/issues/443
# PR : https://github.com/geotribu/website/pull/444

# Corriger les niveaux de titre
# Retirer les anciennes ancres #news
# Balises d'accessibilité manquantes
# Anciennes URLs d'images


library(tidyverse)
library(stringr)
source("helpers.R", encoding = "UTF-8")

year <- 2011
inputFolder <<-  "../../rdp/"
outputFolder <<- "../../website/content/rdp"

reformatYear <- function(year, inputFolder, outputFolder) {
  
  rdps <- listRdpsForYear(year)
  
  # Transformation fichier par fichier
  for(i in 1:length(rdps)) {
    rdp <- rdps[i]
    message(">> ", i, " : ", rdp)
    reformatRdp(rdp, outputFolder)
  }
}

# Reformate toutes les rdps d'une année
reformatYear(year, inputFolder, outputFolder) # reformater une année

# Reformate une rdp
# reformatRdp("../../website/content/rdp/2011/rdp_2011-12-23.md") # reformater une rdp
# reformatRdp("../../rdp//2012/rdp_2012-06-04.md", 2012, inputFolder, outputFolder) # reformater une rdp