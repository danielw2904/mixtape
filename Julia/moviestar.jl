using Chain,
      DataFrames,
      Distributions,
      Gadfly,
      GLM,
      Statistics,
      Random

Random.seed!(3444)

star_is_born = @chain DataFrame() begin
    insertcols!(_, :beauty => randn(2500), 
                   :talent => randn(2500))
    insertcols!(_, :score => _.beauty .+ _.talent)
    insertcols!(_, :c85 => quantile(_.score, .85))
    insertcols!(_, :star => ifelse.(_.score .>= _.c85, 1, 0))
end

# the @aside macro from Chain.jl is used because the lm object
# cannot be fed into Gadfly's plot function as a DF unlike in R

@chain star_is_born begin
    @aside lm(@formula(beauty ~ talent), _)
    plot(_, x=:talent, y=:beauty, Geom.point, 
    size=[0.05],
    Coord.cartesian(xmin=-4, xmax=4, ymin=-4, ymax=4))
end

@chain star_is_born begin
    subset!(_, :star => ByRow(==(1)))
    @aside lm(@formula(beauty ~ talent), _)
    plot(_, x=:talent, y=:beauty, Geom.point, 
    size=[0.05],
    Coord.cartesian(xmin=-4, xmax=4, ymin=-4, ymax=4))
end

@chain star_is_born begin
    subset!(_, :star => ByRow(==(0)))
    @aside lm(@formula(beauty ~ talent), _)
    plot(_, x=:talent, y=:beauty, Geom.point, 
    size=[0.05],
    Coord.cartesian(xmin=-4, xmax=4, ymin=-4, ymax=4))
end
