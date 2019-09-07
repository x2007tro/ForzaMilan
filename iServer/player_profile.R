##
# render player profiles
##
lapply(1:length(seasons), function(i){
  
  observeEvent(input[[paste0('prof', i)]], {
    
    output$play_prof_content <- renderUI(
      tagList(
        
        ##
        # start render player profile tables
        fluidRow(
          column(
            12,
            
            do.call(tabsetPanel, c(lapply(1:length(input[[paste0('play_stats_tbl_opt', i, '_rows_selected')]]), function(j) {
              tabPanel(
                player_sum_stats()$name[j],   # tabpanel name
                
                
                fluidRow(
                  column(
                    12,
                    tags$p(paste0('Name: ', player_sum_stats()$name[j])),
                    tags$p(paste0('Age: ', player_sum_stats()$Age[j]))
                  )
                )
                
              )
              
            })))
          )
        )
        
      )
    )
    
  })
  
})
