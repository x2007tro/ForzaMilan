##
# PLAYER Select function
##

observeEvent({ 
  input$bi_pos
  input$bi_leg
  input$bi_min_age
  input$bi_max_age
  input$bi_min_height
  input$bi_max_height
  input$fa19_min_spd
  input$fa19_min_str
  input$fa19_min_agl
  input$fa19_min_drb
}, {
  # text input rendering
  pos_cdn_str <- paste0("(", paste0("\'", input$bi_pos, "\'", collapse = ","), ")")
  leg_cdn_str <- paste0("(", paste0("\'", input$bi_leg, "\'", collapse = ","), ")")
  
  # build string
  qry <- paste0("SELECT [500_050_MasterDetailedStatsAndAttrbs].name
                FROM 500_050_MasterDetailedStatsAndAttrbs
                WHERE ((([500_050_MasterDetailedStatsAndAttrbs].Age)>=", input$bi_min_age,
                ") AND (([500_050_MasterDetailedStatsAndAttrbs].Age)<=", input$bi_max_age, 
                ") AND (([500_050_MasterDetailedStatsAndAttrbs].Height)>=", input$bi_min_height,
                ") AND (([500_050_MasterDetailedStatsAndAttrbs].Height)<=", input$bi_max_height,
                ") AND (([500_050_MasterDetailedStatsAndAttrbs].SprintSpeed)>=", input$fa19_min_spd,
                ") AND (([500_050_MasterDetailedStatsAndAttrbs].Strength)>=", input$fa19_min_str,
                ") AND (([500_050_MasterDetailedStatsAndAttrbs].Dribbling)>=", input$fa19_min_drb,
                ") AND (([500_050_MasterDetailedStatsAndAttrbs].Agility)>=", input$fa19_min_agl, 
                ") AND (([500_050_MasterDetailedStatsAndAttrbs].Position) in ", pos_cdn_str,
                ") AND (([500_050_MasterDetailedStatsAndAttrbs].league) in ", leg_cdn_str,
                "))")
  res <- GetQueryResFromDB(db_object, qry)
  
  ret_names <- unique(res$name)
  ret_rec_ret <- length(ret_names)
  if(ret_rec_ret == 0) {
    ret_names <- player_name[1]
    flt_msg <- paste0("No player record found.")
  } 
  
  if(ret_rec_ret >= player_rec_ret_threshold) {
    ret_names <- ret_names[1:player_rec_ret_threshold]
    flt_msg <- paste0(ret_rec_ret, " player records founds. Only the first ", player_rec_ret_threshold, " results returned.")
  } else {
    flt_msg <- paste0(ret_rec_ret, " player records founds.")
  }
  
  updateSelectInput(session, "plyr_nms", selected = ret_names)
  output$flt_msg <- renderText(
    flt_msg
  )
})