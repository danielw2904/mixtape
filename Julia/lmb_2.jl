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

#using all data (note data used is lmb_data, not lmb_subset)

lm_1 = reg(lmb_data, @formula(score ~ lagdemocrat), Vcov.cluster(:id))
lm_2 = reg(lmb_data, @formula(score ~ democrat), Vcov.cluster(:id))
lm_3 = reg(lmb_data, @formula(democrat ~ lagdemocrat), Vcov.cluster(:id))

regtable(lm_1, lm_2, lm_3, regression_statistics = [:nobs, :r2, :adjr2, :dof, :f, :p])