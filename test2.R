con <- file("../../website/content/rdp/2011/rdp_2011-06-03.md", "r", encoding = "UTF-8")
con <- file("../../rdp/2011/rdp_2011-01-07.md", "r", encoding = "UTF-8")
lines <- readLines(con)
lines
close(con)
