library(magrittr)

snd <- load("./Private/Data/Raw/snd.RDs")

# player stats extraction
tmp_data <- lapply(snd, function(data){
  
  tmp_data <- lapply(data, function(season){
    
    tmp_data <- lapply(season, function(matches){
      
      players <- matches$league$game$players
      print(paste0("Processing season ", matches$league$season, " week ", matches$league$week))
      tmp_data <- lapply(players, function(player){
        
        print(paste0("Processing game ", player$team[1]))
        
        if(length(player$player[[1]]) != 0 & !is.null(player)){
          stats_tm1 <- player$player[[1]] %>%
            dplyr::mutate(team = player$team[1])
          
          stats_tm2 <- player$player[[2]] %>%
            dplyr::mutate(team = player$team[2])
          
          stats <- rbind.data.frame(stats_tm1, stats_tm2)
          
        } else {
          stats <- NULL
        }
        
        return(stats)
      })
      tmp_data2 <- dplyr::bind_rows(tmp_data) %>%
        dplyr::mutate(
          matchweek = matches$league$week,
          season = matches$league$season)
      return(tmp_data2)
    })
    tmp_data2 <- dplyr::bind_rows(tmp_data)
    return(tmp_data2)
  })
  tmp_data <- dplyr::bind_rows(tmp_data) %>%
    dplyr::mutate(league = names(snd))
  
  return(tmp_data)
})
player_stats <- dplyr::bind_rows(tmp_data)

# team stats
tmp_data <- lapply(snd, function(data){
  
  tmp_data <- lapply(data, function(season){
    
    tmp_data <- lapply(season, function(matches){
      
      game <- matches$league$game
      print(paste0("Processing season ", matches$league$season, " week ", matches$league$week))
      
      stats <- data.frame(
        date = game$date,
        homeTeam = game$homeTeam,
        awayTeam = game$awayTeam,
        homeScore = game$homeScore,
        awayScore = game$awayScore,
        kickoff = game$kickoff,
        status = game$status,
        stringsAsFactors = FALSE
      )
      
      stats <- dplyr::bind_rows(stats) %>% 
        dplyr::mutate(
          matchweek = matches$league$week,
          season = matches$league$season)
      return(stats)
    })
    tmp_data2 <- dplyr::bind_rows(tmp_data)
    return(tmp_data2)
  })
  tmp_data <- dplyr::bind_rows(tmp_data) %>% 
    dplyr::mutate(league = names(snd))
  
  return(tmp_data)
})
match_stats <- dplyr::bind_rows(tmp_data)

# adjust character for player stats
player_stats <- player_stats %>% 
  dplyr::mutate(name = CorrectMyWriting(name)) %>% 
  dplyr::mutate(name = ifelse(name == 'Ognjen Stijepovi&#263;', 'Ognjen Stijepovic', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'Piotr Zieli&#324;ski', 'Piotr Zielinski', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'Edin D?eko', 'Edin Dzeko', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'Pascal Groß', 'Pascal Gross', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'David de Gea', 'David De Gea', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'M\'baye Niang', 'M\'Baye Niang', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'Nuno da Costa', 'Nuno Da Costa', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'Weston Mckennie', 'Weston McKennie', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'Dwight Mcneil', 'Dwight McNeil', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'Danilo D`Ambrosio', 'Danilo D\'Ambrosio', name)) %>% 
  dplyr::mutate(name = ifelse(name == 'Ki Sung-Yeung', 'Ki Sung-Yueng', name)) %>% 
  dplyr::mutate(name = gsub('  ', ' ', name)) %>% 
  dplyr::mutate(team = CorrectMyWriting(team))

# player name extraction
player_name <- player_stats[, 'name', drop=FALSE]
player_name <- unique(player_name)

# adjust character for match stats
match_stats <- match_stats %>% 
  dplyr::mutate(homeTeam = CorrectMyWriting(homeTeam)) %>% 
  dplyr::mutate(awayTeam = CorrectMyWriting(awayTeam))

# player name extraction
team_name <- player_stats[, 'team', drop=FALSE]
team_name <- unique(team_name)

# output to csv file
if(!dir.exists('./Private/Data')){
  dir.create('./Private/Data')
  if(!dir.exists('./Private/Data/DB Feed')){
    dir.create('./Private/Data/DB Feed')
  }
}

write.csv(player_stats, file = "./Private/Data/DB Feed/snd_player_stats.csv", row.names = FALSE)
write.csv(player_name, file = './Private/Data/DB Feed/snd_player_name.csv', row.names = FALSE)
write.csv(match_stats, file = "./Private/Data/DB Feed/snd_match_stats.csv", row.names = FALSE)
write.csv(team_name, file = "./Private/Data/DB Feed/snd_team_name.csv", row.names = FALSE)

# fifa19 data conversion (only do it once)
# fifa_data <- read.csv('./Source Data/fifa_data.csv', stringsAsFactors = FALSE, encoding = 'UTF-8')
# fifa_data <- fifa_data %>% 
#   dplyr::mutate(Name = CorrectMyWriting(Name)) %>% 
#   dplyr::mutate(Club = CorrectMyWriting(Club))
# 
# write.csv(fifa_data, file = 'fifa19_data.csv', row.names = FALSE)