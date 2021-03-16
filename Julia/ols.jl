using DataFrames,
    GLM,
    Random
Random.seed!(1);

df = DataFrame(
    x = randn(10000),
    u = randn(10000)
);
df[!, :y] = 5.5 .* df.x .+ 12 .* df.u;
reg_df = lm(@formula(y~x), df)
