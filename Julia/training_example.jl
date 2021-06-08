using Chain,
      DataFrames,
      Gadfly,
      StatsKit

function read_data(df) 
    path = "https://raw.github.com/scunning1975/mixtape/master/" * df
    @chain path begin
        HTTP.download
        load
        DataFrame
    end
end

training_example = @chain read_data("training_example.dta") begin
    DataFrame 
    first(20)
end

plot(training_example, x=:age_treat, Geom.histogram(bincount = 10))    

plot(training_example, x=:age_control, Geom.histogram(bincount = 10))

# missing values are treated by Gadfly
# however, the plots are different from a ggplot with the same parameters...?