##
# player compare panel
tp_player_comp <- tabPanel(
  
  "Player Visual Comparison",
  
  fluidRow(
    column(
      12, 
      shypka.ddiv(tags$h3(class = "block_title", "Comparison"), color = default_header_color),  # dimgray
      
      uiOutput('play_comp_content')
    )
  )
)