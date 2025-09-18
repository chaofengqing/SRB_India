

## relation between local-max SRB and TFR ##
max.inflation.c <- max.year.c <- rep(NA, C)

for (c in 1:C) {
  t.pick <- which.max(res.full$R.cqt[c, 2, ])
  max.inflation.c[c] <- res.full$R.cqt[c, 2, t.pick] - res.full$N.cqt[c, 2, 1]
  max.year.c[c] <- years.t[t.pick] - 0.5
}#end of c loop

## read in TFR data
tfr.data <- read.csv(paste0(input.dir, "India_state_TFR_SRS.csv"),
                     stringsAsFactors = FALSE)
tfr.data$State <- InternalStandardizeIndiaStateName(substr(tfr.data$State, 1, nchar(tfr.data$State) - 1))

sum(is.element(InternalStandardizeIndiaStateName(tfr.data$State), name.c))

## get TFR in the year with max SRB
max.tfr.c <- rep(NA, C)
for (c in 1:C) {
  pick <- which(tfr.data$State == name.c[c])
  if (max.year.c[c] >= 2000) {
    tfr <- tfr.data[pick, paste0("X", max.year.c[c])]
    max.tfr.c[c] <- as.numeric(substr(tfr, nchar(tfr) - 3, nchar(tfr)))
  } else if (max.year.c[c] == 1999) {
    tfr <- tfr.data[pick, "X2000"]
    max.tfr.c[c] <- as.numeric(substr(tfr, nchar(tfr) - 3, nchar(tfr)))
  }#end of ifelse(max.year.c[c] >= 2000)
}#end of c loop

## load Indian states with imbalanced SRB
load(file = paste0(output.dir, "country.list.past.inflation.rda")) #country.list.past.inflation
coun.pst <- country.list.past.inflation
names(max.inflation.c) <- names(max.tfr.c) <- names(max.year.c) <- name.c

res.india.inflation <- list(max.inflation.c = max.inflation.c,
                            max.tfr.c = max.tfr.c,
                            max.year.c = max.year.c,
                            coun.pst = country.list.past.inflation)
save(res.india.inflation, file = paste0(output.dir, "res.india.inflation.rda"))

## plot ##
pdf(paste0(fig.dir, "explore_IndiaState_maxInflation_TFR.pdf"), width = 8)
plot(max.inflation.c[coun.pst] ~ max.tfr.c[coun.pst], type = "p", pch = 19, main = "Indian states",
     ylab = "max SRB inflation", xlab = "TFR", ylim = c(0, 0.2), xlim = c(1.4, 4.6))
text(y = max.inflation.c[coun.pst], x = max.tfr.c[coun.pst], labels = coun.pst,
     pos = 1)
dev.off()

## the end ##

