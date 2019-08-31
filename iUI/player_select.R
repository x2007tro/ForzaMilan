##
# player select panel
##
tp_player_select <- tabPanel(
  "Select Player",
  
  ##
  # basic info filter
  ##
  fluidRow(
    column(
      width = 10,
      shypka.ddiv(tags$h3(class = "block_title", "Basic Information"), color = "rgba(105,105,105,1)"),  # dimgray
      tags$b(selectInput("bi_pos", "Position", choices = , multiple = TRUE, selectize = TRUE))
    )
  ),
  
  fluidRow(
    
  ),
  
  fluidRow(
    
  )
  
)