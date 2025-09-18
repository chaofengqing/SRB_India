

###############################################################################
# A systematic assessment of national, regional and global sex ratios of
# infant, child and under-five mortality and identification of countries with
# outlying levels
#
# Code constructed by: Leontine ALKEMA and Fengqing CHAO
# Code last revised by: Fengqing CHAO on 25 Feb 2014
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
# input data: data/output/runname/mcmc.array_runname.rda
#
# output data: data/output/runname/*_postinfo.csv - R hat; post sample median, CI
# output plot: fig/runname/convergence/*
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



# ######################
# needs temp jags objects, not updated
# ## check DIC values ##
# if(First.run){
#   DIC.matrix<-matrix(NA,nr=mcmc.chains,nc=N.STEPS) #save DIC value
#   dimnames(DIC.matrix)[[1]]<-c(paste("chain",seq(1,mcmc.chains),sep=" "))
#   dimnames(DIC.matrix)[[2]]<-c(paste("step",seq(1,N.STEPS),sep=" "))
#   
#   for(chain in 1:mcmc.chains){
#     for(i in 1:N.STEPS){
#       load(paste0(output.dir,"temp.JAGSobjects/jags_mod",runname,chain,"update_",i,".Rdata"))
#       DIC.matrix[chain,i]<-mod.upd$BUGSoutput$DIC
#       remove(mod.upd)
#     }#end of N.STEPS loop
#   }#end of mcmc.chains loop
#   write.csv(DIC.matrix,paste0(output.dir,"DIC_",runname,"_",IntervalLength,"knots.csv"))
# }

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
