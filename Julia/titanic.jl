using Chain, DataFrames, FileIO, HTTP, Statistics

titanic = "https://raw.github.com/scunning1975/mixtape/master/titanic.dta" |>
    HTTP.download |>
    load |>
    DataFrame

insertcols!(titanic, :d => titanic.class .== 1)

ey1 = @chain titanic begin
    filter(:d => isequal(1), _)
    _[:, :survived]
    mean
end

ey0 = @chain titanic begin
    filter(:d => isequal(0), _)
    _[:, :survived]
    mean
end

sd0 = ey1 - ey0
