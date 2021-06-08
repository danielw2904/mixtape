using Chain,
      Compose,
      DataFrames,
      Gadfly,
      GLM,
      Random

Random.seed!(1);

tb = @chain DataFrame() begin
    insertcols!(_, :x => randn(10000), 
                   :u => randn(10000))
    insertcols!(_, :y => (5.5 .* _.x) + (12 .* _.u))
end

reg_tb = @chain tb begin
    lm(@formula(y~x), _)
end

coef(reg_tb)

tb = @chain tb begin
    insertcols!(_, :yhat1 => predict(lm(@formula(y ~ x), _)))
    insertcols!(_, :yhat2 => 0.0732608 .+ (5.685033 .* _.x))
    insertcols!(_, :uhat1 => residuals(lm(@formula(y ~ x), _)))
    insertcols!(_, :uhat2 => _.y .- _.yhat2)
end

describe(tb[:, Not(1:3)])

@chain tb begin
    @aside lm(@formula(y~x), _)
    plot(_,
    layer(x=:x, y=:y, Geom.point, color = [colorant"black"], size = [0.05], alpha = [0.5]),
    layer(x=:x, y=:y, Geom.smooth(method=:lm), color = [colorant"black"]),
    Guide.title("OLS Regression Line"),
    Guide.annotation(compose(context(), text(-1.5,30, "Intercept = -0.0732608"), fill("red"))),
    Guide.annotation(compose(context(), text(1.5,-30, "Slope = 5.685033"), fill("blue")))
    )
end

