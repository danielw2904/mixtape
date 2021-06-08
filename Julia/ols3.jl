using DataFrames, 
      FixedEffectModels, 
      Gadfly,
      Random

function tibble()
    @chain DataFrame() begin
        insertcols!(_,  :x => 9 .* randn(10000), 
                        :u => 36 .* randn(10000))
        insertcols!(_, :y => (3 .+ (2 .* _.x) .+ _.u))
        reg(_, @formula(y ~ x))
        coef(_)
    end
end

@chain map(_ -> tibble(), 1:1000) begin
    reduce(hcat, _)'
    DataFrame(_, :auto)
    rename!(_, :x1 => :intercept, :x2 => :x)
    @aside describe(_.x)
    plot(_, x=:x, Geom.histogram(bincount=30))
end
