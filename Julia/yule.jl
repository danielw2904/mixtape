using Chain, 
      DataFrames, 
      FileIO, 
      FixedEffectModels,
      HTTP,
      RegressionTables
     
yule = "https://raw.github.com/scunning1975/mixtape/master/yule.dta" |>
    HTTP.download |>
    load |>
    DataFrame


yule_lm = reg(yule, @formula(paup ~ outrelief + old + pop))                   # incorrect degrees of freedom (known issue)

regtable(yule_lm, regression_statistics = [:nobs, :r2, :adjr2, :f, :p, :dof]) # correct values


##### Alternative code using GLM #####

using Chain, 
      DataFrames, 
      FileIO, 
      GLM,
      HTTP     

yule = "https://raw.github.com/scunning1975/mixtape/master/yule.dta" |>
    HTTP.download |>
    load |>
    DataFrame

yule_lm = reg(yule, @formula(paup ~ outrelief + old + pop))

# the summary() function workaround

yule_lm                                      # print model            
dof_residual(yule_lm)                        # degrees of freedom
round(r2(yule_lm), digits = 4)               # r^2
round(adjr2(yule_lm), digits = 4)            # r^2 adjusted
null_model = lm(@formula(paup ~ 1), yule)    # create null model
ftest(yule_lm.model, null_model.model)       # get the F value and significance