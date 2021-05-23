module Mixtape

using FileIO, 
    HTTP

export read_data

"""
   read_data(`file`) 

read data `file` from mixtape repo
"""
function read_data(file)
    return "https://raw.github.com/scunning1975/mixtape/master/$file" |>
        HTTP.download |>
        load 
end

end # module