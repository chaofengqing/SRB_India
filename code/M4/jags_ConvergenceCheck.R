###############################################################################
# Levels and trends in the sex ratio at birth and missing female births 
# for 29 states and union territories in India 1990–2016: A Bayesian modeling study
#
# Code constructed by: Fengqing CHAO
# Code last revised by: Qiqi Qiang on 23 September 2025
# 
# jags_ConvergenceCheck.R
# 
# This script checks the convergence of JAGS model output, i.e. mcmc.array. It
# produces trace plots for (selected) parameters, and compute median, CI, R hat
#
# used for which run: Main.run; Validation.run; Excl.run
#
# this script is called by any other scripts: main*_output.R
#
# this script calls other scripts: null
# functions called:                null
# 
# input data: data/output/M4/mcmc.array_M4.rda
#
# output data: data/output/M4_postinfo.csv - R hat; post sample median, CI
# output plot: fig/M4/convergence/*
#
###############################################################################


################
## trace plot ##

## hyper para ##
pdf(paste0(convergeplot.dir, "trace_", runname, ".pdf"))
for (par in c(hyper.para, para.sigmas)) {
  PlotTrace(parname = par, mcmc.array = mcmc.array)
}#end of par loop
dev.off()
###############################################
## compute R hat and post sample information ##
post.full <- getPostInfo(mcmc.array = mcmc.array)
write.csv(post.full, paste0(output.dir, runname, "_postinfo.csv")) #checking only

## trace plot for para with big Rhat values ##
par.select <- rownames(post.full)[1:50]
pdf(paste0(convergeplot.dir, "trace_problematic_", runname, ".pdf"))
for (par in par.select) {
  PlotTrace(parname = par, mcmc.array = mcmc.array,
            main = paste0(par, " Rhat=", round(post.full[par, "Rhat (descending)"], 2)))
}#end of par loop
dev.off()


## The End! ##

