#
# Shiny server
#
mainServer <- function(input, output, session) {

  ##
  # Schedule initialization
  ##
  source("./iServer/player_select.R", local = TRUE)
  
  ##
  # fitness calendar view
  ##
  source("./iServer/player_stats.R", local = TRUE)
  
}
