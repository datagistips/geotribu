# Tests de relocalisation de thumbnails

rdp <- "../../rdp/2011/rdp_2011-12-23.md"
# rdp <- "../../rdp/2011/rdp_2011-12-30.md"
# rdp <- "../../rdp/2011/rdp_2011-03-18.md"
# rdp <- "../../rdp/2011/rdp_2011-03-18.md"

source("helpers.R", encoding = "UTF-8")

lines <- readRdp(rdp)

# grepl("gvSIG", lines) %>% which
# lines[39]
# reformatLine(lines[39])
# newLines <- reformatTitles(lines)
# sapply(newLines, length)

# METTRE THUMB DANS LE POST
lines <- reformatTitles(lines)
lines <- relevelTitles(lines)
lines <- reformatLeadingSpace(lines)
lines <- relocateThumbs(lines)
lines <- reformatLinks(lines)

grep("Earth as art", lines) -> w
lines[w]

# 
# grepl("gvSIG", lines) %>% which -> w
# lines[w]

# reformatRdp(rdp, outputFolder)
writeRdp(lines, "temp.md")
