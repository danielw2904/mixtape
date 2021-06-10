using Chain,
      DataFrames,
      FileIO,
      FixedEffectModels,
      HTTP,
      RegressionTables,
      Vcov

function read_data(df) 
    path = "https://raw.github.com/scunning1975/mixtape/master/" * df
    @chain path begin
        HTTP.download
        load
        DataFrame
    end
end

lmb_data = read_data("lmb-data.dta")

lmb_subset = subset(lmb_data, :lagdemvoteshare => ByRow(>(0.48)), 
                               :lagdemvoteshare => ByRow(<(0.52)), 
                               skipmissing = true)

lm_1 = reg(lmb_subset, @formula(score ~ lagdemocrat), Vcov.cluster(:id))
lm_2 = reg(lmb_subset, @formula(score ~ democrat), Vcov.cluster(:id))
lm_3 = reg(lmb_subset, @formula(democrat ~ lagdemocrat), Vcov.cluster(:id))

regtable(lm_1, lm_2, lm_3, regression_statistics = [:nobs, :r2, :adjr2, :dof, :f, :p])