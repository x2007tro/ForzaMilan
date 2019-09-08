##
# player stats panel
tp_player_stats <- tabPanel(
  
  "Player Stats",
  
  fluidRow(
    column(
      12, 
      do.call(tabsetPanel, c(lapply(1:length(seasons), function(i) {
        tabPanel(
          paste0("Season ", seasons[i]),
          
          shypka.ddiv(tags$h3(class = "block_title", "Summary Stats"), color = default_header_color),  # dimgray
          
          fluidRow(
            column(12, DT::dataTableOutput(paste0('play_stats_tbl_opt', i)))
          ),
          
          fluidRow(
            column(12, actionButton(paste0('ret_prof', i), class = 'btn-success', 'Retrieve Selected Player Profiles'))
          )
          
        )
      })))
    )
  )
)