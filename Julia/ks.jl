using Chain,
      DataFrames,
      Distributions,
      KernelDensity,
      Statistics   

tb = DataFrame(
    d = vcat(fill(0, 20), fill(1, 20)),
    y = [0.22, -0.87, -2.39, -1.79, 0.37, -1.54, 
        1.28, -0.31, -0.74, 1.72, 
        0.38, -0.17, -0.62, -1.10, 0.30, 
        0.15, 2.30, 0.19, -0.50, -0.9,
        -5.13, -2.19, 2.43, -3.83, 0.5, 
        -3.25, 4.32, 1.63, 5.18, -0.43, 
        7.11, 4.87, -3.10, -5.81, 3.76, 
        6.31, 2.58, 0.07, 5.76, 3.50]
)

kdensity_d1 = @chain tb begin
    subset(_, :d => ByRow(==(1)))
    _.y
    kde(_)
end

kdensity_d0 = @chain tb begin
    subset(_, :d => ByRow(==(0)))
    _.y
    kde(_)
end

kdensity_d0 = DataFrame(x = kdensity_d0.x, y= kdensity_d0.density, d = 0)
kdensity_d1 = DataFrame(x = kdensity_d1.x, y= kdensity_d1.density, d = 1)

kdensity = append!(kdensity_d0, kdensity_d1)
kdensity.d = convert(BitArray, kdensity.d)

plot(kdensity,
     layer(x=:x, y=:y, color=:d, Geom.point, size = [0.03]),
     Guide.title("Kolmogorov-Smirnov Test"),
     Guide.colorkey(labels=["Control","Treatment"]),
     Coord.cartesian(xmin=-7, xmax=8),
     Theme(highlight_width = 0pt)
     )