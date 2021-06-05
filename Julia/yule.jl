using Chain, 
      DataFrames, 
      FileIO, 
      GLM,
      HTTP     

function read_data(df) 
    path = "https://raw.github.com/scunning1975/mixtape/master/" * df
    @chain path begin
        HTTP.download
        load
        DataFrame
    end
end

yule_lm = lm(@formula(paup ~ outrelief + old + pop), yule);

# the summary() function workaround

yule_lm                                      # print model            
dof_residual(yule_lm)                        # degrees of freedom
round(r2(yule_lm), digits = 4)               # r^2
round(adjr2(yule_lm), digits = 4)            # r^2 adjusted
null_model = lm(@formula(paup ~ 1), yule);   # create null model
ftest(yule_lm.model, null_model.model)       # get the F value and significance