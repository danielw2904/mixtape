# simulate the discontinuity
dat = @chain dat begin
    insertcols!(_, :y2 => (25 .+ (40 .* _.D) .+ (1.5 .* _.x) .+ rand(Normal(0, 20), nrow(_))))
end

#figure
plot(dat, 
     layer(x=:x, y=:y2, Geom.point, alpha=[0.5], color=:D),
     layer(x=:x, y=:y2, Stat.smooth(method=:lm), Geom.line),
     layer(x=:x, y=:y2, Geom.vline(color = ["grey"], style=:dash), xintercept=[50]),
     Guide.colorkey(labels=["0","1"]),
     Guide.xlabel("Test score (X)"),
     Guide.ylabel("Potential Outcome (Y)")
)