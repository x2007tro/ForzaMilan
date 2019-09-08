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
              # Get data from DB
              withProgress(message = 'Getting player profile ...', {
                # build query
                qry <- paste0("SELECT *
                              FROM 700_030_PlayerProfiles_Basic
                              WHERE (([700_030_PlayerProfiles_Basic].Name) = '", player_sum_stats()$name[j],
                              "')")
                prof_basic <- GetQueryResFromDB(db_object, qry)
                
                # build query
                qry <- paste0("SELECT *
                              FROM 700_050_PlayerProfiles_Rating
                              WHERE (([700_050_PlayerProfiles_Rating].Name) = '", player_sum_stats()$name[j],
                              "')")
                prof_rate <- GetQueryResFromDB(db_object, qry)
                
                # build query
                qry <- paste0("SELECT *
                              FROM 800_030_PlayerProfiles_Graph
                              WHERE (([800_030_PlayerProfiles_Graph].name) = '", player_sum_stats()$name[j],
                              "')")
                stats_graph <- GetQueryResFromDB(db_object, qry)
              })
              
              tabPanel(
                player_sum_stats()$name[j],   # tabpanel 
                
                fluidRow(
                  # basic info
                  column(
                    3,
                    
                    shypka.ddiv(tags$h4(class = "block_title", "Basic"), color = "rgba(105,105,105,1)"),  # dimgray
                    
                    lapply(1:ncol(prof_basic), function(z){
                      if(colnames(prof_basic)[z] == 'Photo'){
                        tags$img(src = prof_basic[1,z], height = '50px', width = '50px')
                      } else {
                        tags$h4(paste0(colnames(prof_basic)[z], ': ', prof_basic[1,z]))
                      }
                      
                    })
                    
                  ),
                  
                  # ratings1
                  column(
                    3,
                    
                    shypka.ddiv(tags$h4(class = "block_title", "Ratings"), color = "rgba(105,105,105,1)"),  # dimgray
                    
                    lapply(2:15, function(z){
                        tags$h4(paste0(colnames(prof_rate)[z], ': ', prof_rate[1,z]))
                    })
                    
                  ),
                  
                  # ratings2
                  column(
                    3,
                    
                    shypka.ddiv(tags$h4(class = "block_title", "Ratings"), color = "rgba(105,105,105,1)"),  # dimgray
                    
                    lapply(16:29, function(z){
                      tags$h4(paste0(colnames(prof_rate)[z], ': ', prof_rate[1,z]))
                    })
                    
                  ),
                  
                  # ratings3
                  column(
                    3,
                    
                    shypka.ddiv(tags$h4(class = "block_title", "Ratings"), color = "rgba(105,105,105,1)"),  # dimgray
                    
                    lapply(30:ncol(prof_rate), function(z){
                      tags$h4(paste0(colnames(prof_rate)[z], ': ', prof_rate[1,z]))
                    })
                    
                  )
                ),
                
                ##
                # graph/plots
                fluidRow(
                  column(
                    width = 12,
                    
                    fluidRow(
                      column(
                        3,
                        shypka.ddiv(tags$h4(class = "block_title", "Filter"), color = "rgba(105,105,105,1)"),  # dimgray
                        selectInput(paste0('s', i, 'ply', j, '_metric'), 'Metric', selected = colnames(stats_graph)[5], 
                                    choices = colnames(stats_graph)[5:length(colnames(stats_graph))], selectize = FALSE),
                        selectInput(paste0('s', i, 'ply', j, '_season'), 'Season', selected = 'all', choices = c('all', unique(stats_graph$season)), selectize = FALSE),
                        selectInput(paste0('s', i, 'ply', j, '_league'), 'League', selected = 'all', choices = c('all', unique(stats_graph$league)), selectize = FALSE)
                      ),
                      column(
                        6,
                        shypka.ddiv(tags$h4(class = "block_title", "Historical Stats"), color = "rgba(105,105,105,1)"),  # dimgray
                        plotOutput(paste0('s', i, 'ply_plot',j))
                      )
                    )
                  )
                )
                
              )
              
            })))
          )
        )
        
      )
    )
    
    # render plot
    lapply(1:length(input[[paste0('play_stats_tbl_opt', i, '_rows_selected')]]), function(j){
      
      # build query
      qry <- paste0("SELECT *
                    FROM 800_030_PlayerProfiles_Graph
                    WHERE (([800_030_PlayerProfiles_Graph].name) = '", player_sum_stats()$name[j],
                    "')")
      stats_graph <- GetQueryResFromDB(db_object, qry)
      
      output[[paste0('s', i, 'ply_plot',j)]] <- renderPlot({
        UtilPlotPlayerPerf(stats_graph, input[[paste0('s', i, 'ply', j, '_metric')]], input[[paste0('s', i, 'ply', j, '_season')]], input[[paste0('s', i, 'ply', j, '_league')]])
      })
      
    })
    
  })
  
  
})
