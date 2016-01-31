fixheight <- function(x){
  y <- strsplit(x, "'")
  ret <- sapply(y, function(z){
    ifelse( length(z)>1, as.numeric(z[1])*12 + as.numeric(z[2]) ,
            as.numeric(z[1]))
  })
  return(ret)
}
