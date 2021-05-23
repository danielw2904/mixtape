include("Mixtape.jl")

using .Mixtape: read_data
using DataFrames, Chain, Plots, StatsKit

training_example = @chain read_data("training_example.dta") begin
    DataFrame 
    first(20)
end

@chain skipmissing(training_example.age_treat) begin
    fit(Histogram, collect(_), nbins = 10)
    plot(_, labels = false)
end

@chain skipmissing(training_example.age_control) begin
    fit(Histogram, collect(_), nbins = 10)
    plot(_, labels = false)
end


