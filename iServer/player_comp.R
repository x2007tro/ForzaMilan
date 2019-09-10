##
# render player comp
lapply(1:length(seasons), function(i){
  
  observeEvent(input[[paste0('ret_prof', i)]], {
    # text input rendering
    player_stats <- player_sum_stats() %>% 
      dplyr::filter(season == seasons[i])
    plyr_nms <- player_stats$name[input[[paste0('play_stats_tbl_opt', i, '_rows_selected')]]]
    plyr_nms2 <- gsub("'", "''", plyr_nms)
    ply_nm_str <- paste0("(", paste0("\'", plyr_nms2, "\'", collapse = ","), ")")
    
    # build query
    qry <- readr::read_file('./Queries/get_player_graph_profile_by_names.sql')
    qry <- gsub('@ply_nm_str', ply_nm_str, qry)
    stats_graph <- GetQueryResFromDB(db_object, qry)
    
    output$play_comp_content <- renderUI({
      tagList(
        fluidRow(
          column(
            3,
            shypka.ddiv(tags$h4(class = "block_title", "Filter"), color = default_header_color),  # dimgray
            selectInput(paste0('s', i, 'ply_comp', '_metric'), 'Metric', selected = colnames(stats_graph)[5], 
                        choices = colnames(stats_graph)[5:length(colnames(stats_graph))], selectize = FALSE)
          ),
          column(
            6,
            shypka.ddiv(tags$h4(class = "block_title", "Historical Stats"), color = default_header_color),  # dimgray
            plotOutput(paste0('s', i, 'ply_comp_plot'))
          )
        )
      )
    })
    
    output[[paste0('s', i, 'ply_comp_plot')]] <- renderPlot({
      UtilPlotPlayerPerf(stats_graph, input[[paste0('s', i, 'ply_comp','_metric')]], 'all', 'all')
    })
    
  })
})