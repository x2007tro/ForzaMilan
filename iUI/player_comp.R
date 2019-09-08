##
# player compare panel
tp_player_comp <- tabPanel(
  
  "Player Visual Comparison",
  
  fluidRow(
    column(
      12, 
      shypka.ddiv(tags$h3(class = "block_title", "Comparison"), color = "rgba(105,105,105,1)"),  # dimgray
      
      uiOutput('play_comp_content')
    )
  )
)