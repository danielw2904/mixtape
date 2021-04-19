using Chain, HTTP, Queryverse, Statistics

file = "https://raw.github.com/scunning1975/mixtape/master/titanic.dta"

titanic = @chain load(HTTP.download(file)) begin
    DataFrame()
end 
insertcols!(titanic, :d => ifelse.((titanic.class .== 1), 1, 0))

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