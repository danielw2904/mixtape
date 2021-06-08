using Chain,
      DataFrames,
      FileIO,
      Gadfly,
      GLM,
      HTTP,
      Statistics    

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
lm_aux = lm(@formula(length ~ weight + headroom + mpg), auto)

auto.length_resid = residuals(lm_aux)

lm2_alt = lm(@formula(price ~ length_resid), auto)

coef_lm1 = coef(lm1)
coef_lm2_alt = coef(lm2_alt)
resid_lm2 = residuals(lm2_alt)

y_single = DataFrame(
    price = coef_lm2_alt[1] .+ coef_lm1[2].*auto.length_resid,
    length_resid = auto.length_resid
)

y_multi = DataFrame(
    price = coef_lm2_alt[1] .+ coef_lm2_alt[2].*auto.length_resid,
    length_resid = auto.length_resid
)

plot(auto, layer(x=:length_resid, y=:price, Geom.point),
    layer(y_multi, x=:length_resid, y=:price, Geom.smooth, Theme(default_color=colorant"blue")),
    layer(y_single, x=:length_resid, y=:price, Geom.smooth, Theme(default_color=colorant"red")),
    Scale.y_continuous(format=:plain))


