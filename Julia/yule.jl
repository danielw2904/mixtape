using Chain, 
      DataFrames, 
      FileIO, 
      FixedEffectModels,
      HTTP,
      RegressionTables

function read_data(df) 
    path = "https://raw.github.com/scunning1975/mixtape/master/" * df
    @chain path begin
        HTTP.download
        load
        DataFrame
    end
end

yule_lm = @chain read_data("yule.dta") begin
    reg(_, @formula(paup ~ outrelief + old + pop));
end
 
regtable(yule_lm, regression_statistics = [:nobs, :r2, :adjr2, :dof, :f, :p])
