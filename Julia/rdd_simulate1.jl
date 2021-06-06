using Chain,
      DataFrames,
      Distributions,
      Gadfly, 
      Random
      
# simulate the data 
dat = @chain DataFrame() begin
    insertcols!(_, :x => rand(Normal(50, 25), 1000))
    transform(_, :x => (x -> ifelse.(x .< 0, 0, x)) => :x)
    subset(_, :x => ByRow(<(100)))
end

# cutoff at x = 50
dat = @chain dat begin
    insertcols!(_, :D => convert(BitArray, ifelse.(_.x .> 50, 1, 0)))
    insertcols!(_, :y1 => (25 .+ (0 .* _.D) .+ (1.5 .* _.x) .+ rand(Normal(0, 20), nrow(_))))
end

plot(dat, 
     layer(x=:x, y=:y1, Geom.point, alpha=[0.5], color=:D),
     layer(x=:x, y=:y1, Stat.smooth(method=:lm), Geom.line),
     layer(x=:x, y=:y1, Geom.vline(color = ["grey"], style=:dash), xintercept=[50]),
     Guide.colorkey(labels=["0","1"]),
     Guide.xlabel("Test score (X)"),
     Guide.ylabel("Potential Outcome (Y1)")
)
     
