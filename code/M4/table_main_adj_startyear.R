

## table to summarize the starting year for the 33 countries ##
load(file = paste0(output.dir, "country.list.past.inflation.rda"))#country.list.past.inflation
load(file = paste0(output.dir, "trajectory_", runname, "_R.rda")) #res.Rtrajectory

yr.start <- 1990
yr.end <- 2016

changeR.cq <- t(apply(res.Rtrajectory$R.clt[, , paste(yr.end)] -
                        res.Rtrajectory$R.clt[, , paste(yr.start)],
                      1, quantile, percentiles, na.rm = TRUE))


table.colnames <- c(
  "State",
  paste("SRB", c(1990, 2016)),
  "change SRB 1990-2016",
  "Max SRB year",
  "SRB (max)"
)
table.rownames <- paste(rep(name.c, each = 2), rep(c(1, 2), times = C))

table.df <- matrix(NA, nr = length(table.rownames), nc = length(table.colnames))
rownames(table.df) <- table.rownames
colnames(table.df) <- table.colnames

for (c in 1:C) {
  country <- name.c[c]

  table.df[paste(country, 1), "State"] <- country
  table.df[paste(country, 2), "State"] <- country
  
  t.s <- which(years.t-0.5 == floor(min(year.i[name.i == country])))
  t.e <- which(years.t-0.5 == 2016)
  t.m <- c(t.s:Tend)[which.max(res.full[["R.cqt"]][country, 2, t.s:Tend])]#max yr

  for (yr in c(1990, 2016)) {
    table.df[paste(country, 1), paste("SRB", yr)] <-
      paste0(StandardizeDecimal(res.full[["R.cqt"]][country, 2, paste(yr)], 3))
    table.df[paste(country, 2), paste("SRB", yr)] <-
      paste0("[", StandardizeDecimal(res.full[["R.cqt"]][country, 1, paste(yr)], 3), "; ",
             StandardizeDecimal(res.full[["R.cqt"]][country, 3, paste(yr)], 3), "]")
  }#end of yr loop

  table.df[paste(name.c, 1), "change SRB 1990-2016"] <-
    paste0(StandardizeDecimal(changeR.cq[, 2], 3))
  table.df[paste(name.c, 2), "change SRB 1990-2016"] <-
    paste0("[", StandardizeDecimal(changeR.cq[, 1], 3), "; ",
           StandardizeDecimal(changeR.cq[, 3], 3), "]")
  
  if (is.element(country, country.list.past.inflation)) {
    table.df[paste(country, 1), "Max SRB year"] <- floor(years.t[t.m])
    
    table.df[paste(country, 1), "SRB (max)"] <-
      paste0(StandardizeDecimal(res.full[["R.cqt"]][country, 2, t.m], 3))
    table.df[paste(country, 2), "SRB (max)"] <-
      paste0("\n[", StandardizeDecimal(res.full[["R.cqt"]][country, 1, t.m], 3), "; ",
             StandardizeDecimal(res.full[["R.cqt"]][country, 3, t.m], 3), "]")
  }#end of if
  
}#end of c loop

write.csv(table.df, row.names = TRUE, paste0(output.dir, "table_startyear.csv"))

table.df <- read.csv(paste0(output.dir, "table_startyear.csv"),
                     row.names = 1,
                     header = TRUE, stringsAsFactors = FALSE, strip.white = TRUE)

table.df.save <- table.df

## create multirow column for country names
table.df <- table.df.save
table.df[, 1] <- as.character(table.df[, 1])
rle.lengths <- rle(table.df[, 1])$lengths
last.duplicate <- which(1:length(table.df[, 1]) %% 2 == 0)#the last repeated country name

## add significant signs to state names
name.c[changeR.cq[, 1] > 0 | changeR.cq[, 3] < 0]
# none
select <- last.duplicate[changeR.cq[, 1] > 0 | changeR.cq[, 3] < 0]
table.df[select, 1] <- paste0(table.df[select, 1], "\\ddag")

name.c[res.full$R.cqt[, 1, "1990"] > N.mu | res.full$R.cqt[, 3, "1990"] < N.mu]
# [1] "Delhi"             "Gujarat"           "Haryana"           "Himachal Pradesh"  "Jammu and Kashmir"
# [6] "Punjab"            "Rajasthan"         "Uttar Pradesh"    
select <- last.duplicate[res.full$R.cqt[, 1, "1990"] > N.mu | res.full$R.cqt[, 3, "1990"] < N.mu]
table.df[select, 1] <- paste0(table.df[select, 1], "\\P")

name.c[res.full$R.cqt[, 1, "2016"] > N.mu]
name.c[res.full$R.cqt[, 1, "2016"] > N.mu | res.full$R.cqt[, 3, "2016"] < N.mu]
# [1] "Andhra Pradesh"    "Assam"             "Bihar"             "Delhi"            
# [5] "Gujarat"           "Haryana"           "Jammu and Kashmir" "Jharkhand"        
# [9] "Madhya Pradesh"    "Punjab"            "Rajasthan"         "Uttar Pradesh"    
# [13] "Uttarakhand"      
select <- last.duplicate[res.full$R.cqt[, 1, "2016"] > N.mu | res.full$R.cqt[, 3, "2016"] < N.mu]
table.df[select, 1] <- paste0(table.df[select, 1], "\\S")


table.df[-last.duplicate, 1] <- ""
table.df[last.duplicate, 1] <-
  paste0("\\multirow{", (-1)*rle.lengths, "}{3.2cm}{", table.df[last.duplicate, 1], "}")
table.df[, 1] <-
  paste0(c(rep(rep(c("", "\\rowcolor{lightblue1}"), each = 2), times = (C - 1) / 2),
           rep("", 2)), table.df[, 1])

library(xtable)
## table 2 ##
table <- xtable(
  table.df
  # align = "ccccccc" # the 1st entry is for rownames
)
cat("\014")
print(table, floating = FALSE, #tabular.environment = 'longtable',
      include.colnames = TRUE, include.rownames = FALSE, size = "footnotesize",
      sanitize.text.function=function(x){x})


name.c[res.full$R.cqt[, 2, "2016"] > res.full$R.cqt[, 2, "1990"]]
sort(res.full$R.cqt[, 2, "2016"] - res.full$R.cqt[, 2, "1990"])

sum(res.full$R.cqt[, 2, "2016"] < 1.05) #7
sum(res.full$R.cqt[, 2, "1990"] < 1.05) #2

sum(res.full$R.cqt[, 2, "2016"] > 1.14) #4
sum(res.full$R.cqt[, 2, "1990"] > 1.14) #4

name.c[res.full$R.cqt[, 2, "2016"] > 1.14]
name.c[res.full$R.cqt[, 2, "1990"] > 1.14]
## the end ##

