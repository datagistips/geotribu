l <- list.files(sprintf("%s/%d", rdpFolder, year), "-new.md", full.names = T)
for(elt in l) {
  file.rename(elt, gsub("-new.md", ".md", elt))
  file.remove(elt)
}
