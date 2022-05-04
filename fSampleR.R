print("Function to Conditioned Latin Hypercube (cLHS)")
#########################################################################################################
##Libraries
#########################################################################################################
loadandinstall <- function(mypkg) {
  for(i in seq(along=mypkg)){
    if (!is.element(mypkg[i],installed.packages()[,1])){install.packages(mypkg[i])}
    library(mypkg[i], character.only=TRUE)
  }
}
packages <- sort(c("raster",
                   "clhs",
                   "sf"))
loadandinstall(packages)
#########################################################################################################
##Function
#########################################################################################################
fSampleR <- function(POT.FILE,
                    IN.DIR,
                    IN.EPSG,
                    PON.FILE,
                    OUT.DIR,
                    SN){

#Import shape file 
o <- st_read(paste(IN.DIR,POT.FILE,".shp",sep=""))
p <- st_read(paste(IN.DIR,PON.FILE,".shp",sep=""))
p$ID <- 1:nrow(p)
# Assign projection
st_crs(o) = IN.EPSG
st_crs(p) = IN.EPSG

# Generate cLHS design
set.seed(123)
sample <- clhs(o, size = SN, progress = TRUE, simple = FALSE, use.coords = TRUE)

# Export samples
st_write(sample$sampled_data, paste(OUT.DIR,POT.FILE,"_SAMPLE.shp",sep=""),delete_layer = TRUE)
saveRDS(sample, paste(OUT.DIR,POT.FILE,"_SAMPLE.RData",sep=""))

# Overlay
ps <- st_filter(p, sample$sampled_data, .predicate = st_intersects)
st_write(ps, paste(OUT.DIR,PON.FILE,"_SAMPLE.shp",sep=""),delete_layer = TRUE)
}

p
