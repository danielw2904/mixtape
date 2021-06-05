using Chain, 
      DataFrames, 
      FileIO, 
      GLM,
      HTTP
     
function read_data(df) 
    path = "https://raw.github.com/scunning1975/mixtape/master/" * df
    @chain path begin
        HTTP.download
        load
        DataFrame
    end
end

training_bias_reduction = read_data("training_bias_reduction.dta")
@chain training_bias_reduction begin
  insertcols!(_, :Y1 => ifelse.(_.Unit .<= 4, _.Y, missing))
  insertcols!(_, :Y0 => [4,0,5,1,4,0,5,1])  
  
end 

train_reg = lm(@formula(Y ~ X), training_bias_reduction)

training_bias_reduction.u_hat0 = predict(train_reg)
