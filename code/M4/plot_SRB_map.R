

#######################################################
## map of India ##
library(RColorBrewer)
library(sp)
require("rgeos",character.only=TRUE)

# load level 1 india data downloaded from http://gadm.org/country
ind1 <- readRDS("data/india_shape/gadm36_IND_1_sp.rds")
ind1$NAME_1 <- InternalStandardizeIndiaStateName(ind1$NAME_1)

year.plot <- c(1990, 2000, 2016)

cutoff <- quantile(res.full$R.cqt[, 2, paste(year.plot)], c(0:10)/10, na.rm = TRUE)
cutoff.labs <- as.character(cut(cutoff, cutoff, include.lowest = TRUE))[-1]

pdf(file = paste0(fig.dir, "India_state_SRBesti.pdf"))
par(mar = c(0.5, 0, 2, 2), oma = c(0,0,0,0))
for (yr in year.plot) {
  srb.s <- rep(NA, length(ind1$NAME_1))
  names(srb.s) <- ind1$NAME_1
  srb.s[name.c] <- res.full$R.cqt[name.c, 2, paste(yr)]

  # Telangana is separated from Andhra Pradesh in 2014
  if (yr < 2014) {
    srb.s["Telangana"] <- srb.s["Andhra Pradesh"]
  }
  
  ind1$SRB <- srb.s
  
  # Find the center of each region and label lat and lon of centers
  centroids <- gCentroid(ind1, byid=TRUE)
  select.names <- is.element(ind1$NAME_1, c(name.c, "Telangana"))
  centroidLons <- coordinates(centroids)[select.names, 1]
  centroidLats <- coordinates(centroids)[select.names, 2]
  names(centroidLons) <- names(centroidLats) <- ind1$NAME_1[select.names]
  
  code.plot <- NULL
  for (j in 1:sum(select.names)) {
    if (ind1$NAME_1[select.names][j] == "Telangana") {
      add.code <- "TG"
    } else {
      add.code <- code.c[name.c == ind1$NAME_1[select.names][j]]
    }#end of ifelse
    code.plot <- c(code.plot, add.code)
  }#end of j loop
  
  code.plot <- ifelse(code.plot == "JM", "JK", code.plot)
  
  # colouring the districts with range of colours
  col_no <- as.factor(as.numeric(cut(ind1$SRB, cutoff, include.lowest = TRUE)))
  names(col_no) <- ind1$NAME_1
  ind1$col_no <- col_no
  myPalette <- c("lightblue1", "lightgoldenrod", brewer.pal(9, "Reds")[-1])
  
  plot(ind1, col = myPalette[ind1$col_no], lwd = 0.01)
  title(paste("Sex Ratio at Birth in", yr), cex.main = 1.5)
  text(centroidLons, centroidLats, labels = code.plot, cex = 1)
  legend(legend = cutoff.labs, bg = "white", box.col = "white",
         fill = myPalette, "bottomright", cex = 1.5)
}#end of i loop
dev.off()

## the end ##

