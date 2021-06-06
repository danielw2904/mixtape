using Chain,
      Combinatorics,
      DataFrames,
      FileIO,
      HTTP    

function read_data(df) 
    path = "https://raw.github.com/scunning1975/mixtape/master/" * df
    @chain path begin
        HTTP.download
        load
        DataFrame
    end
end

auto = read_data("auto.dta")
auto.length = auto.length .- mean(auto.length)

lm1 = lm(@formula(price ~ length), auto)
lm2 = lm(@formula(price ~ length + weight + headroom + mpg), auto)

coef_lm1 = coef(lm1)
coef_lm2 = coef(lm2)
resid_lm2 = residuals(lm2)

y_single = DataFrame(price = coef_lm1[1] .+ coef_lm1[2].*auto.length,
                     length = auto.length)

y_multi = DataFrame(price = coef_lm1[1] .+ coef_lm2[2].*auto.length,
                     length = auto.length)

plot(auto, 
    layer(x=:length, y=:price, Geom.point),
    layer(y_multi, x=:length, y=:price, Geom.smooth, color=[colorant"blue"]),
    layer(y_single, x=:length, y=:price, Geom.smooth, color=[colorant"red"]),
    Scale.y_continuous(format=:plain))
