using Chain, 
      DataFrames, 
      FileIO, 
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

nsw_dw = read_data("nsw_mixtape.dta")

# careful: subset instead of subset! to not replace the data

@chain nsw_dw begin
    subset(_, :treat => ByRow(==(1)))
    describe(_.re78)
end

mean1 = @chain nsw_dw begin
    subset(_, :treat => ByRow(==(1)))
    mean(_.re78)
end

insertcols!(nsw_dw, :y1 => mean1)

@chain nsw_dw begin
    subset(_, :treat => ByRow(==(0)))
    describe(_.re78)
end

mean0 = @chain nsw_dw begin
    subset(_, :treat => ByRow(==(0)))
    mean(_.re78)
end

insertcols!(nsw_dw, :y0 => mean0)

ate = unique(nsw_dw.y1 - nsw_dw.y0)

nsw_dw = @chain nsw_dw begin
    subset(_, :treat => ByRow(==(1)))
    select(_, Not([:y1, :y0]))
end


