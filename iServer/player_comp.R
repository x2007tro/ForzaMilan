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
    qry <- paste0("SELECT * FROM 800_030_PlayerProfiles_Graph
                  WHERE (([800_030_PlayerProfiles_Graph].name) in ", ply_nm_str,
                  ")")
    stats_graph <- GetQueryResFromDB(db_object, qry)
    
    output$play_comp_content <- renderUI({
      tagList(
        fluidRow(
          column(
            3,
            shypka.ddiv(tags$h4(class = "block_title", "Filter"), color = "rgba(105,105,105,1)"),  # dimgray
            selectInput(paste0('s', i, 'ply_comp', '_metric'), 'Metric', selected = colnames(stats_graph)[5], 
                        choices = colnames(stats_graph)[5:length(colnames(stats_graph))], selectize = FALSE)
          ),
          column(
            6,
            shypka.ddiv(tags$h4(class = "block_title", "Historical Stats"), color = "rgba(105,105,105,1)"),  # dimgray
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