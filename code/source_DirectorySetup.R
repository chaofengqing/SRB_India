

#######################################
## setup directory for data cleaning ##

# aux.data.dir <- "data/input/Auxdata/"

## subfolder for intermediate data ##
input.dir <- "data/input/"
interim.dir <- "data/interim/"
dir.create("data/interim/", showWarnings = FALSE)

if (CleanData) {
  
  ##########################
  ## input data directory ##
  
  # DHS Birth Recode, or Individual Recode (i.e. women data)
  DHS.raw.dir   <- "data/input/DHS/raw/"
  DHS.input.dir <- "data/input/DHS/input/"
  DHS.interim.dir <- "data/input/DHS/interim/"
  DHS.output.dir   <- "data/input/DHS/output/"

  # SRS dir
  SRS.raw.dir   <- "data/input/SRS/raw/"
  SRS.input.dir <- "data/input/SRS/input/"
  SRS.output.dir   <- "data/input/SRS/output/"
  
  # Census dir
  Census.input.dir <- "data/input/Census_2011/input/"
  Census.output.dir   <- "data/input/Census_2011/output/"
  
  ###########################
  ## output data directory ##
  output.dir <- "data/output/"
  
  ####################
  ## plot directory ##
  fig.dir <- "fig/data pre-process/"
  
  
  dir.create(DHS.interim.dir, showWarnings = FALSE)
  dir.create(DHS.output.dir, showWarnings = FALSE)
  dir.create(SRS.output.dir, showWarnings = FALSE)
  dir.create(Census.output.dir, showWarnings = FALSE)
  dir.create("fig", showWarnings = FALSE)
  dir.create(fig.dir, showWarnings = FALSE)
}#end of if(CleanData)

#############################################
## setup directory for modeling and output ##
if (!CleanData) {
  ## data-related ##
  output.dir      <- paste0("data/output/", runname, "/")
  jagsStep.dir    <- paste0(output.dir, "temp.JAGSobjects/") # to save step-wise JAGS output
  countryTraj.dir <- paste0(output.dir, "countryTrajectory/")
  
  ## figure-related ##
  fig.dir          <- paste0("fig/", runname, "/") # root directory for all plots
  convergeplot.dir <- paste0(fig.dir, "convergence/") # convergence plots
  
  ####################
  ## create folders ##
  if (First.run) {
    
    ## output data folderss ##
    dir.create("data/output", showWarnings = FALSE)
    dir.create(output.dir, showWarnings = FALSE)
    dir.create(jagsStep.dir, showWarnings = FALSE)
    dir.create(countryTraj.dir, showWarnings = FALSE)
    
    ## figure folders ##
    dir.create("fig", showWarnings = FALSE)
    dir.create(fig.dir, showWarnings = FALSE)
    dir.create(convergeplot.dir, showWarnings = FALSE)
    
  }#end of if (First.run)
  
}#end of if(!CleanData)

## the end ##

