##
# Source server and ui components
##
require(shiny)
require(magrittr)
require(ggplot2)
source("Helpers/shypka.R")
source("Helpers/ggpthemepka")
source("iUI/main.R")
source("iServer/main.R")

##
# Launch shiny app
##
shinyApp(
  ui = mainUI,
  server = mainServer
)