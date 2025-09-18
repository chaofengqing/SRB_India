

## print out results in latex table ##

## table for appendix ##
load(file = paste0(output.dir, "country.list.past.inflation.rda"))#country.list.past.inflation
load(file = paste0(output.dir, "cis_full_", runname, ".rda")) #res.full
load(file = paste0(output.dir, "cis_", runname, "_CumsumMissing.rda")) #res.missing.CI

start.year <- c(1990, 2001, 1990)
end.year <- c(2000, 2016, 2016)
t.start <- t.end <- rep(NA, length(start.year))
for (j in 1:length(start.year)) {
  t.start[j] <- which(floor(years.t) == start.year[j])
  t.end[j] <- which(floor(years.t) == end.year[j])
}#end of j loop

table.colnames <- c(
  "State",
  paste0("AMFB thousands (",
         start.year[-3], "-", end.year[-3], ")"),
  paste0("CMFB thousands (",
         start.year[3], "-", end.year[3], ")"),
  paste0("Proportion of national CMFB (",
         start.year, "-", end.year, ")")
)
table.rownames <- paste(rep(c("India", country.list.past.inflation), each = 2),
                        rep(c(1, 2), times = length(country.list.past.inflation)+1))

table.df <- matrix(NA, nr = length(table.rownames), nc = length(table.colnames))
rownames(table.df) <- table.rownames
colnames(table.df) <- table.colnames

for (c in which(is.element(name.c, country.list.past.inflation))) {
  print(c)
  country <- name.c[c]
  
  table.df[paste(country, 1), "State"] <- country
  table.df[paste(country, 2), "State"] <- country
  
  for (k in 1:length(start.year)) {
    B.l <- (res.missing.CI[["cumsum.missingBf.clt"]][c, , t.end[k]] -
      res.missing.CI[["cumsum.missingBf.clt"]][c, , t.start[k]-1]) /
      ifelse(k == 3, 1, t.end[k] - t.start[k] + 1)
    B.q <- SamplesToUI(B.l) / 1000
    # use medians to compute medians!!!
    B.q[2] <- (median(res.missing.CI[["cumsum.missingBf.clt"]][c, , t.end[k]]) / 1000 -
      median(res.missing.CI[["cumsum.missingBf.clt"]][c, , t.start[k]-1]) / 1000) /
      ifelse(k == 3, 1, t.end[k] - t.start[k] + 1)

    B.q <- round(B.q)
    for (q in 1:Per) {
      B.q[q] <- prettyNum(B.q[q], width = 3, big.mark = ",")
    }#end of q loop
    
    parname <- ifelse(k == 3, "CMFB", "AMFB")
    table.df[paste(country, 2),
             paste0(parname, " thousands (",
                    start.year[k], "-", end.year[k], ")")] <- paste0("[", B.q[1], "; ", B.q[3], "]")
    
    table.df[paste(country, 1),
             paste0(parname, " thousands (",
                    start.year[k], "-", end.year[k], ")")] <- paste0(B.q[2])
  }#end of k loop
}#end of c loop

for (k in 1:length(start.year)) {
  select.c <- is.element(name.c, country.list.past.inflation)
  
  national.B.l <-
    apply(res.missing.CI[["cumsum.missingBf.clt"]][select.c, , t.end[k]] -
    res.missing.CI[["cumsum.missingBf.clt"]][select.c, , t.start[k]-1], 2, sum, na.rm = TRUE)
  
  B.l <- national.B.l / ifelse(k == 3, 1, t.end[k] - t.start[k] + 1)
  B.q <- SamplesToUI(B.l) / 1000
  B.q <- round(B.q)
  for (q in 1:Per) {
    B.q[q] <- prettyNum(B.q[q], width = 3, big.mark = ",")
  }#end of q loop
  
  parname <- ifelse(k == 3, "CMFB", "AMFB")
  
  table.df[paste("India", 1), "State"] <- table.df[paste("India", 2), "State"] <- "India"
  
  table.df[paste("India", 2),
           paste0(parname, " thousands (",
                  start.year[k], "-", end.year[k], ")")] <- paste0("[", B.q[1], "; ", B.q[3], "]")
  
  table.df[paste("India", 1),
           paste0(parname, " thousands (",
                  start.year[k], "-", end.year[k], ")")] <- paste0(B.q[2])
  
  table.df[paste("India", 1),
           paste0("Proportion of national CMFB (",
                  start.year[k], "-", end.year[k], ")")] <- paste0("100")
  
  check <- rep(NA, length(country.list.past.inflation))
  
  for (c in  which(select.c)) {
    country <- name.c[c]
    B.l <- res.missing.CI[["cumsum.missingBf.clt"]][c, , t.end[k]] -
      res.missing.CI[["cumsum.missingBf.clt"]][c, , t.start[k]-1]
    
    percent.q <- SamplesToUI(B.l / national.B.l) * 100
    check[c] <- percent.q[2] <- median(B.l) / median(national.B.l) * 100
    percent.q[percent.q < 0] <- 0
    percent.q[percent.q > 100] <- 100
    percent.q <- round(percent.q, 1)
    
    table.df[paste(country, 2),
             paste0("Proportion of national CMFB (",
                    start.year[k], "-", end.year[k], ")")] <-
      #paste0("[\\MyNum{", percent.q[1], "}; \\MyNum{", percent.q[3], "}]")
      paste0("[", percent.q[1], "; ", percent.q[3], "]")
    table.df[paste(country, 1),
             paste0("Proportion of national CMFB (",
                    start.year[k], "-", end.year[k], ")")] <-
      paste0(percent.q[2])#paste0("\\MyNum{", percent.q[2], "}")
    
  }#end of c loop
  print(sum(check, na.rm = TRUE))
}#end of k loop

table.df.save <- table.df

## create multirow column for country names
table.df <- table.df.save
table.df[, 1] <- as.character(table.df[, 1])
rle.lengths <- rle(table.df[, 1])$lengths
last.duplicate <- which(1:length(table.df[, 1]) %% 2 == 0)#the last repeated country name
table.df[-last.duplicate, 1] <- ""
table.df[last.duplicate, 1] <-
  paste0("\\multirow{", (-1)*rle.lengths, "}{3.2cm}{", table.df[last.duplicate, 1], "}")
table.df[, 1] <-
  paste0(c(rep(rep(c("", "\\rowcolor{lightblue1}"), each = 2),
             times = length(country.list.past.inflation) / 2), rep("", 2)), table.df[, 1])

library(xtable)
table <- xtable(table.df, 
                label = "tab_sup_state_result",
                align = "|l|p{2.5cm}|ccc|ccc|" # the 1st entry is for rownames
)
cat("\014")
print(table, tabular.environment = 'longtable', floating = FALSE,
      include.colnames = FALSE, include.rownames = FALSE,
      hline.after = 0, caption.placement = "top",
      sanitize.text.function=function(x){x} #display formula!!
)

## the end ##


