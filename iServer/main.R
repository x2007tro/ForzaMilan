#
# Shiny server
#
mainServer <- function(input, output, session) {

  ##
  # player select
  ##
  source("./iServer/player_select.R", local = TRUE)
  
  ##
  # player stats
  ##
  source("./iServer/player_stats.R", local = TRUE)
  
  ##
  # player profile
  ##
  source("./iServer/player_profile.R", local = TRUE)
}
