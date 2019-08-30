##
# function to convert all non-latin-ACSII charater to latin-ACSII
CorrectMyWriting <- function(target){
  y <- stringi::stri_trans_general(target, "Latin-ASCII")
  return(y)
}

