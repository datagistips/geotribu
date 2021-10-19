source("helpers.R")

library(stringr)
library(tidyverse)

lines

rdp <- "../../rdp/2011/rdp_2011-12-23.md"

lines <- readRdp(rdp)

newLines <- reformatLinks(lines)

myLine <- lines[101]

# # myLine <- 'toto [logo](titi) toto [logo test22](https://tata) toto [](https://tutu23)'
# httpLinks <- str_extract_all(lines, "\\[\\S*\\s?\\S*\\]\\(\\S+\\)") %>% unlist
# imageLinks <- str_extract_all(lines, "\\!\\[\\S*\\s?\\S*\\]\\(\\S+\\)") %>% unlist

# links <- c(httpLinks, imageLinks)

# Accessibilité ----
imgLink1 <- "![](https://cdn.geotribu.fr/img/logos-icones/logiciels_librairies/gdal.png)"
imgLink2 <- '![](https://cdn.geotribu.fr/img/logos-icones/logiciels_librairies/gdal.png "Logo GDAL")'
isAccessible(imgLink1)
isAccessible(imgLink2)

if(!isAccessible(imgLink1)) {
  addAccessibility(imgLink1)
}

addAccessibility(imageLinks[12])
addAccessibility(imageLinks[1])

test <- sapply(imageLinks, addAccessibility) %>% as.character
test


# Réponse ----


# Annexes ----