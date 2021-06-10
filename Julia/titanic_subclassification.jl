using Chain,
      DataFrames,
      FileIO,
      FixedEffectModels,
      HTTP,
      Statistics,
      Tables

function read_data(df) 
    path = "https://raw.github.com/scunning1975/mixtape/master/" * df
    @chain path begin
        HTTP.download
        load
        DataFrame
    end
end

titanic = @chain read_data("titanic.dta") begin
    insertcols!(_, :d => titanic.class .== 1)
    transform(_, [:sex, :age] => ByRow((sex, age) ->
                    sex == 0 && age == 1 ? 1 :
                    sex == 0 && age == 0 ? 2 :
                    sex == 1 && age == 1 ? 3 :
                    sex == 1 && age == 0 ? 4 :
                    0) => 
                    :s)
end

ey11 = @chain titanic begin
    subset(_, :s => ByRow(==(1)), :d => ByRow(==(1)))
    mean(_.survived)
end

ey10 = @chain titanic begin
    subset(_, :s => ByRow(==(1)), :d => ByRow(==(0)))
    mean(_.survived)
end

ey21 = @chain titanic begin
    subset(_, :s => ByRow(==(2)), :d => ByRow(==(1)))
    mean(_.survived)
end

ey20 = @chain titanic begin
    subset(_, :s => ByRow(==(2)), :d => ByRow(==(0)))
    mean(_.survived)
end

ey31 = @chain titanic begin
    subset(_, :s => ByRow(==(3)), :d => ByRow(==(1)))
    mean(_.survived)
end

ey30 = @chain titanic begin
    subset(_, :s => ByRow(==(3)), :d => ByRow(==(0)))
    mean(_.survived)
end

ey41 = @chain titanic begin
    subset(_, :s => ByRow(==(4)), :d => ByRow(==(1)))
    mean(_.survived)
end

ey40 = @chain titanic begin
    subset(_, :s => ByRow(==(4)), :d => ByRow(==(0)))
    mean(_.survived)
end

diff1 = ey11 - ey10
diff2 = ey21 - ey20
diff3 = ey31 - ey30
diff4 = ey41 - ey40

obs = @chain titanic begin
    subset(_, :d => ByRow(==(0)))
    nrow(_)
end

wt1 = @chain titanic begin
    subset(_, :s => ByRow(==(1)), :d => ByRow(==(0)))
    nrow(_)/obs
end

wt2 = @chain titanic begin
    subset(_, :s => ByRow(==(2)), :d => ByRow(==(0)))
    nrow(_)/obs
end

wt3 = @chain titanic begin
    subset(_, :s => ByRow(==(3)), :d => ByRow(==(0)))
    nrow(_)/obs
end

wt4 = @chain titanic begin
    subset(_, :s => ByRow(==(4)), :d => ByRow(==(0)))
    nrow(_)/obs
end

wate = diff1*wt1 + diff2*wt2 + diff3*wt3 + diff4*wt4

print("The weigthted average treatment effect estimate is " * string(wate))
