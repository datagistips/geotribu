rdp <- "../../rdp/2011/rdp_2011-12-23.md"
rdp <- "../../rdp/2011/rdp_2011-12-30.md"
rdp <- "../../rdp/2011/rdp_2011-03-18.md"

source("helpers.R", encoding = "UTF-8")

lines <- readRdp(rdp)

# METTRE THUMB DANS LE POST
relocateThumbs(lines)
reformatRdp(rdp, outputFolder)
writeRdp(lines, "temp.md")

