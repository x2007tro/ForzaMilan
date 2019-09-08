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
      width = 12,
      shypka.ddiv(tags$h3(class = "block_title", "Basic Information"), color = default_header_color),  # dimgray
      
      fluidRow(
        column(6, tags$b(selectInput("bi_pos", "Position", choices = c("ST", "CF", "CAM", "LS", "LF", "LW", "LM"), multiple = TRUE, selectize = TRUE, selected = position, width = "100%"))),
        column(6, tags$b(selectInput("bi_leg", "League", choices = league_name, multiple = TRUE, selectize = TRUE, selected = league_name, width = "100%")))
        
      ),
      
      fluidRow(
        column(3, tags$b(numericInput("bi_min_age", "Min Age", value = 0, width = "100%"))),
        column(3,tags$b(numericInput("bi_max_age", "Max Age", value = 20, width = "100%"))),

      #),
      #
      #fluidRow(
        column(3, tags$b(numericInput("bi_min_height", "Min Height (cm)", value = 150, width = "100%"))),
        column(3, tags$b(numericInput("bi_max_height", "Max Height (cm)", value = 250, width = "100%")))
      )

    )
  ),
  
  ##
  # fifa info filter
  ##
  fluidRow(
    column(
      width = 12,
      shypka.ddiv(tags$h3(class = "block_title", "FIFA19 Stats"), color = default_header_color),  # dimgray
      
      fluidRow(
        column(3, tags$b(numericInput("fa19_min_spd", "Min Speed", value = 70, width = "100%"))),
        column(3, tags$b(numericInput("fa19_min_str", "Min Strength", value = 50, width = "100%"))),
        
      # ),
      # 
      # fluidRow(
        column(3, tags$b(numericInput("fa19_min_drb", "Min Dribbling", value = 50, width = "100%"))),
        column(3, tags$b(numericInput("fa19_min_agl", "Max Agility", value = 70, width = "100%")))
      )
    )
  ),
  
  ##
  # output player info
  ##
  fluidRow(
    column(
      width = 12,
      shypka.ddiv(tags$h3(class = "block_title", "Selected Players"), color = default_header_color),  # dimgray
      
      fluidRow(
        column(12, selectInput("plyr_nms", "Player Name", choices = player_name, multiple = TRUE, selectize = TRUE, selected = player_name[1], width = '100%'))
      ),
      
      fluidRow(
        column(12, actionButton("get_sum_stats", class = "btn-warning", "Retrieve Player Summary Stats"))
      )
      
    )
  ),
  
  ##
  # message
  ##
  fluidRow(
    column(
      width = 12,
      shypka.ddiv(tags$h3(class = "block_title", "Message"), color = default_header_color),  # dimgray
      
      fluidRow(
        column(12, textOutput("flt_msg"))
      )
    )
  )
  
)