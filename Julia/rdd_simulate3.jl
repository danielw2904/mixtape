using Chain,
      DataFrames,
      Distributions,
      Gadfly, 
      Random

# simulate nonlinearity
dat = @chain DataFrame() begin
    insertcols!(_, :x => rand(Normal(100,50), 1000))
    transform(_, :x => (x -> ifelse.(_.x .< 0, 0, x)) => :x)
    insertcols!(_, :D => ifelse.(_.x .> 140, 1, 0))
    insertcols!(_, :x2 => _.x .^ 2)
    insertcols!(_, :x3 => _.x .^ 3)
    insertcols!(_, :y3 => 10000 .+ (0 .* _.D) .- (100 .* _.x) .+ _.x2 .+ rand(Normal(0,1000), 1000))
    subset!(_, :x => ByRow(<(280)))
end

plot(dat, 
     layer(x=:x, y=:y3, Geom.point, alpha=[0.2], color=:D),
     layer(x=:x, y=:y3, Stat.smooth(method=:lm), Geom.line, color=:D),
     layer(x=:x, y=:y3, Geom.vline(color = ["grey"], style=:dash), xintercept=[140]),
     Guide.colorkey(labels=["0","1"]),
     Guide.xlabel("Test score (X)"),
     Guide.ylabel("Potential Outcome (Y)")
)

plot(dat, 
     layer(x=:x, y=:y3, Geom.point, alpha=[0.2], color=:D),
     layer(x=:x, y=:y3, Stat.smooth(method=:loess), Geom.line, color=:D),
     layer(x=:x, y=:y3, Geom.vline(color = ["grey"], style=:dash), xintercept=[140]),
     Guide.colorkey(labels=["0","1"]),
     Guide.xlabel("Test score (X)"),
     Guide.ylabel("Potential Outcome (Y)")
)