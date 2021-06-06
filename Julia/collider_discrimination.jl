using Chain,
      DataFrames,
      Distributions,
      FixedEffectModels,
      RegressionTables

tb = @chain DataFrame() begin
    insertcols!(_, :female => ifelse.(rand(Uniform(),10000) .>= 0.5 , 1, 0),
                   :ability => randn(10000))
    insertcols!(_, :discrimination => _.female)
    insertcols!(_, :occupation => 1 .+ (2 .* _.ability) + (0 .* _.female) .- (2 .* _.discrimination) .+ randn(10000))
    insertcols!(_, :wage => 1 .- (1 .* _.discrimination) .+ (1 .* _.occupation) .+ (2 .* _.ability) .+ randn(10000))
end

lm_1 = reg(tb, @formula(wage ~ female))
lm_2 = reg(tb, @formula(wage ~ female + occupation))
lm_3 = reg(tb, @formula(wage ~ female + occupation + ability))

regtable(lm_1, lm_2, lm_3, 
         regression_statistics = [:nobs, :r2, :adjr2, :dof, :f, :p])

# need to rename the model names from (1) (2) (3) to
# "Biased Unconditional", "Biased" and "Biased Conditional", respectively.
# How???
