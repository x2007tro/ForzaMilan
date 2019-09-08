##
# player select panel
##
tp_player_profile <- tabPanel(
  "Player Profile",
  
  fluidRow(
    column(
      width = 12,
      shypka.ddiv(tags$h3(class = "block_title", "Player Profiles"), color = "rgba(105,105,105,1)"),  # dimgray
      
      uiOutput('play_prof_content')
    )
  )
  
)