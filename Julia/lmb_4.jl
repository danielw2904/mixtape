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

insertcols!(lmb_data, :demvoteshare_c => lmb_data.demvoteshare .- 0.5)

lm_1 = reg(lmb_data, @formula(score ~ lagdemocrat * demvoteshare_c), Vcov.cluster(:id))
lm_2 = reg(lmb_data, @formula(score ~ democrat * demvoteshare_c), Vcov.cluster(:id))
lm_3 = reg(lmb_data, @formula(democrat ~ lagdemocrat * demvoteshare_c), Vcov.cluster(:id))

regtable(lm_1, lm_2, lm_3, regression_statistics = [:nobs, :r2, :adjr2, :dof, :f, :p])