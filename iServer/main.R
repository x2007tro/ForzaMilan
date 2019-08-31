#
# Shiny server
#
mainServer <- function(input, output, session) {

  ##
  # Schedule initialization
  ##
  source("./iServer/fileupload.R", local = TRUE)
  
  ##
  # fitness calendar view
  ##
  source("./iServer/fitness.R", local = TRUE)
  
}
