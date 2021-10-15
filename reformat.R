library(tidyverse)
library(stringr)
source("helpers.R", encoding = "UTF-8")

rdpFolder <<- "../../website/content/rdp"

reformatYear <- function(year) {
  
  rdps <- listRdpsForYear(2011)
  
  # Transformation fichier par fichier
  for(i in 1:length(rdps)) {
    rdp <- rdps[i]
    message(">> ", i, " : ", rdp)
    reformatRdp(rdp)
  }
}

# Reformate toutes les rdps d'une année
reformatYear(2011) # reformater une année

# Reformate une rdp
reformatRdp("../../website/content/rdp/2011/rdp_2011-12-23.md") # reformater une rdp

# Renomme les new en normal
# cleanYear(2011)