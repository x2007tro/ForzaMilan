##
# render summary stats output
observeEvent(input$get_sum_stats, {
  
  
  withProgress(message = 'Getting player summary status ...', {
    # text input rendering
    plyr_nms2 <- gsub("'", "''", input$plyr_nms)
    ply_nm_str <- paste0("(", paste0("\'", plyr_nms2, "\'", collapse = ","), ")")
    
    # build query
    qry <- paste0("SELECT [600_050_MasterSummaryStatsAndAttrbs].season, 
                  [600_050_MasterSummaryStatsAndAttrbs].league, 
                  [600_050_MasterSummaryStatsAndAttrbs].team, 
                  [600_050_MasterSummaryStatsAndAttrbs].name, 
                  [600_050_MasterSummaryStatsAndAttrbs].Age, 
                  [600_050_MasterSummaryStatsAndAttrbs].Nationality, 
                  [600_050_MasterSummaryStatsAndAttrbs].Height, 
                  [600_050_MasterSummaryStatsAndAttrbs].Position, 
                  [600_050_MasterSummaryStatsAndAttrbs].Dribbling, 
                  [600_050_MasterSummaryStatsAndAttrbs].SprintSpeed, 
                  [600_050_MasterSummaryStatsAndAttrbs].Agility, 
                  [600_050_MasterSummaryStatsAndAttrbs].Strength, 
                  [600_050_MasterSummaryStatsAndAttrbs].playTime, 
                  [600_050_MasterSummaryStatsAndAttrbs].shots, 
                  [600_050_MasterSummaryStatsAndAttrbs].shotsOnTarget, 
                  [600_050_MasterSummaryStatsAndAttrbs].goals, 
                  [600_050_MasterSummaryStatsAndAttrbs].assists, 
                  [600_050_MasterSummaryStatsAndAttrbs].foulsDrawn, 
                  [600_050_MasterSummaryStatsAndAttrbs].fouls, 
                  [600_050_MasterSummaryStatsAndAttrbs].ownGoal, 
                  [600_050_MasterSummaryStatsAndAttrbs].saves
                  FROM 600_050_MasterSummaryStatsAndAttrbs
                  WHERE (([600_050_MasterSummaryStatsAndAttrbs].name) in ", ply_nm_str,
                  ")")
    res <- GetQueryResFromDB(db_object, qry)
  })
  
  lapply(1:length(seasons), function(i){
    player_stats <- res %>% 
      dplyr::filter(season == seasons[i])
    
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
      DT::formatCurrency("saves", currency = "", digits = 2)
      # DT::formatCurrency("penaltyScored", currency = "", digits = 2) %>% 
      # DT::formatCurrency("penaltyMissed", currency = "", digits = 2) %>% 
      # DT::formatCurrency("penaltyConceded", currency = "", digits = 2) %>% 
      # DT::formatCurrency("penaltySaved", currency = "", digits = 2) %>% 
      # DT::formatCurrency("yellow", currency = "", digits = 2) %>% 
      # DT::formatCurrency("red", currency = "", digits = 2)
    })
    
  })
})
