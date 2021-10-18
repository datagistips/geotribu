# Suppression des espaces ----
# 04-06-2012
rdp <- "../../rdp//2012/rdp_2012-04-06.md"
con <- file(rdp, "r", encoding = "UTF-8")
lines <- readLines(con)
close(con)

grepl("\\s{1,2}[]*", lines[4])
myLine <- lines[121]
reformatLine(lines[1])
grepl("\\s+.*", myLine)
grepl("\\s+.*", "toto")
removeLeadingSpace(myLine)

grep("mapserver", lines)
myLine <- lines[42]
myLine

# Niveaux de titres ----

#### Sortie de la semaine


# https://github.com/geotribu/website/blob/fenfyx2/content/rdp/2011/rdp_2011-12-23.md?plain=1#L25
# #### Projets artistiques
# 
# ![](http://www.geotribu.net/sites/default/files/Tuto/img/Blog/pegman.png){: .img-rdp-news-thumb }
# 
# ### The Nine Eyes of Google Street View

# ![mapserver_logo.jpg](https://cdn.geotribu.fr/img/logos-icones/logiciels_librairies/mapserver.png){: .img-rdp-news-thumb 