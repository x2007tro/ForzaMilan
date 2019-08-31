##
# Shiny helper function
##
require(shiny)
shypka.ddiv <- function(
  ui_element, 
  color = "rgba(220, 220, 220, 0)",
  frame_cln = "block_outter_frame", 
  content_cln = "block_inner_frame"){
  
  res <- tags$div(
    class = frame_cln,
    style = paste0("background-color:", color),
    tags$div(class = content_cln,
      ui_element
  ))
  
  return(res)
}

##
# Create shiny inputs
##
shypka.inputs <- function(FUN, len, id_prefix, ...){
  inputs <- character(len)
  for (i in seq_len(len)) {
    inputs[i] <- as.character(FUN(paste0(id_prefix, i), label = NULL, ...))
  }
  return(inputs)
}

##
# obtain the values of inputs
##
shypka.values <- function(len, id_prefix) {
  unlist(lapply(seq_len(len), function(i) {
    value = input[[paste0(id_prefix, i)]]
    if (is.null(value)) NA else value
  }))
}
