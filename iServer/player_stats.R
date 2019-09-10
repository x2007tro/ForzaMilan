##
# render summary stats output
player_sum_stats <- reactive({
  withProgress(message = 'Getting player summary status ...', {
    # text input rendering
    plyr_nms2 <- gsub("'", "''", input$plyr_nms)
    ply_nm_str <- paste0("(", paste0("\'", plyr_nms2, "\'", collapse = ","), ")")
    
    # build query
    qry <- readr::read_file('./Queries/get_summary_stats.sql')
    qry <- gsub('@ply_nm_str', ply_nm_str, qry)
    res <- GetQueryResFromDB(db_object, qry)
  })
  return(res)
})


observeEvent(input$get_sum_stats, {
  
  lapply(1:length(seasons), function(i){
    player_stats <- player_sum_stats() %>% 
      dplyr::filter(season == seasons[i]) %>% 
      dplyr::select(-season)
    
    output[[paste0('play_stats_tbl_opt', i)]] <- DT::renderDataTable({
      DT::datatable(
        player_stats, 
        options = list(
          pageLength = 20,
          orderClasses = TRUE,
          searching = TRUE,
          paging = TRUE
        ) 
      ) %>% 
      DT::formatCurrency("playTime", currency = "", digits = 2) %>% 
      DT::formatCurrency("shots", currency = "", digits = 2) %>% 
      DT::formatCurrency("shotsOnTarget", currency = "", digits = 2) %>% 
      DT::formatCurrency("goals", currency = "", digits = 2) %>% 
      DT::formatCurrency("assists", currency = "", digits = 2) %>% 
      DT::formatCurrency("foulsDrawn", currency = "", digits = 2) %>% 
      DT::formatCurrency("fouls", currency = "", digits = 2) %>% 
      DT::formatCurrency("ownGoal", currency = "", digits = 2) %>% 
      DT::formatCurrency("saves", currency = "", digits = 2) %>% 
      DT::formatStyle(colnames(player_stats), color = 'black')
      # DT::formatCurrency("penaltyScored", currency = "", digits = 2) %>% 
      # DT::formatCurrency("penaltyMissed", currency = "", digits = 2) %>% 
      # DT::formatCurrency("penaltyConceded", currency = "", digits = 2) %>% 
      # DT::formatCurrency("penaltySaved", currency = "", digits = 2) %>% 
      # DT::formatCurrency("yellow", currency = "", digits = 2) %>% 
      # DT::formatCurrency("red", currency = "", digits = 2)
    })
    
  })
})
