using Chain,
      DataFrames,
      Random,
      Statistics

function gap()
    df = DataFrame(y1 = [7, 5, 5, 7, 4, 10, 1, 5, 3, 9], 
                   y0 = [1, 6, 1, 8, 2, 1, 10, 6, 7, 8],
                   random = randn(10))

    sd0 = @chain df begin
        sort!([:random]) 
        insertcols!(:d => vcat(fill(1,5), fill(0,5)))
        insertcols!(:y => df.d .* df.y1 + (1 .- df.d) .* df.y0)
        select!(:y)
        convert(Array, _)
    end
    
    sd0 = mean(sd0[1:5]-sd0[6:10])

    sd0
end

sim = [gap() for i in 1:10000]

mean(sim)
