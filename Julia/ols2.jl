using DataFrames, 
      GLM, 
      Random

Random.seed!(1)

tb = @chain DataFrame() begin
  insertcols!(_,  :x => 9 .* randn(10), 
                  :u => 36 .* randn(10))
  insertcols!(_, :y => (3 .+ (2 .* _.x) .+ _.u))
  insertcols!(_, :yhat => predict(lm(@formula(y ~ x), _)))
  insertcols!(_, :uhat => residuals(lm(@formula(y ~ x), _)))
end

describe(tb)
sum(eachcol(tb))
