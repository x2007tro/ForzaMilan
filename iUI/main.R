##
# Source all ui files
##
ui_files <- c("player_select")
lapply(ui_files, function(f){
  source(paste0("./iUI/", f, ".R"), local = FALSE)
})

##
# Shiny ui
##
mainUI <- fluidPage(theme = shinythemes::shinytheme("simplex"),
  
  # css style
  tags$head(
    includeCSS("stt_style.css")
  ),
  
  navbarPage(
    "Scouting Milan",
    
    ##
    # Calendar panel
    ##
    tabPanel(
      "Tool",
      
      ##
      # Tools
      navlistPanel(
       "Index",
       widths = c(2, 10),
       tp_player_select
       
      )
    ),
    
    ##
    # Development panel
    ##
    tabPanel(
      "Development",
      tags$b(tags$h5("No ongoing development in process!"))
    )
    
  )
  # End of navbarpage
)