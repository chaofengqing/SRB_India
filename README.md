# SRB_India
This repository presents the first subnational study of Sex Ratio at Birth (SRB) trends and projections in India from 1990 to 2016. We adopt a **Bayesian hierarchical time-series mixture model** to estimate and forecast SRB across 29 states in India. The model leverages an extensive database compiled from all available censuses and nationally representative surveys.

**Please refer to the [published paper](https://www.aimsciences.org/article/doi/10.3934/fods.2019008) regarding to this repository for details on the research background/context, model implementation, data sources, and policy implications**:

- Main paper:  Fengqing Chao, Ajit Kumar Yadav (2019). Levels and trends in the sex ratio at birth and missing female births for 29 states and union territories in India 1990-2016: A Bayesian modeling study. Foundations of Data Science, 1(2) 177–196.
- Technical appendix of the main paper: Chao, Fengqing; Z. Guilmoto, Christophe; K.C., Samir; Ombao, Hernando (2020). S1 Appendix Probabilistic projection of the sex ratio at birth and missing female births by State and Union Territory in India. figshare. Dataset. https://doi.org/10.6084/m9.figshare.12672821.v1

## Repository Structure

The repository contains two parts: **code** and **data**.

- Run the master R code files to get all the results. Specifically,
  - /code/main.R: run this to get the Markov chain Monte Carlo (MCMC) posterior samples of the Bayesian hierarchical model parameters; and
  - /code/main_output.R: after finish running the master code above, run this master code to get all the related output files and plots.
- Input data for the model:
  - /data/Auxdata/:data files related to survey information, country information, covariates.
  - /data/interim/M57_normal_postinfo.csv: data files regarding  to the posterior information of JAGS model. 

## Research Context

This project presents a subnational estimation and projection of Nepal’s Sex Ratio at Birth (SRB) from 1980 to 2050, based on a Bayesian hierarchical time series mixture model. While previous studies have examined SRB at the national level, our approach addresses the geographic heterogeneity of sex imbalances in Nepal—a country where regional variation is both significant and policy-relevant.We aim to estimate and project SRB for the seven provinces of Nepal from 1980 to 2050 using a Bayesian modeling approach. We compiled an extensive database on provincial SRB of Nepal, consisting of the 2001, 2006, 2011, and 2016 Nepal Demographic and Health Surveys and the 2011 Census. We adopted a Bayesian hierarchical time series model to estimate and project the provincial SRB, with a focus on modeling the potential SRB imbalance.

## Methodology

The study estimates India's SRBs by 29 states from 1980 to 2016 and projects them until 2050 using a Bayesian hierarchical time series mixture model. This model incorporates uncertainties from observations and natural year-by-year fluctuations. The full model write ups are in the [published paper](https://www.aimsciences.org/article/doi/10.3934/fods.2019008).

We used the JAGS (Just Another Gibbs Sampler) to do Bayesian inference. The relevant R code to call JAGS and to get the MCMC samples are (they are called automatically in /code/main.R):

- /code/jags_setupMCMC.R: prior settings, MCMC settings
- /code/jags_writeJAGSmodel.R: the Bayesian hierarchical model to run in JAGS
- /code/jags_getMCMC.R: get the posterior samples using MCMC algorithm via JAGS

The model convergence is checked by the code:

- /code/jags_ConvergenceCheck.R: this code is called in /code/main_output.R
