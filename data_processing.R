library(magrittr)
source('./Helpers/helper.R')
snd <- readRDS("./Private/Data/Raw/snd.RDs")

# player stats extraction
tmp_data <- lapply(1:length(snd), function(y){
  data <- snd[[y]]
  tmp_data <- lapply(data, function(season){
    
    tmp_data <- lapply(season, function(matches){
      
      print(paste0("Processing season ", matches$league$season, " week ", matches$league$week))
      
      games <- matches$league$game
      game_dates <- games$date
      tmp_data <- lapply(1:length(game_dates), function(i, game_info){
        
        game_date <- game_info$date[i]
        player <- game_info$players[[i]]
        print(paste0("Processing game ", player$team[1]))
        
        if(length(player$player[[1]]) != 0 & !is.null(player)){
          stats_tm1 <- player$player[[1]] %>%
            dplyr::mutate(team = player$team[1])
          
          stats_tm2 <- player$player[[2]] %>%
            dplyr::mutate(team = player$team[2])
          
          stats <- rbind.data.frame(stats_tm1, stats_tm2) %>% 
            dplyr::mutate(matchDate = as.Date(game_date, format = '%B %d, %Y'))
          
        } else {
          stats <- NULL
        }
        
        return(stats)
          
      }, games)
      
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
    dplyr::mutate(league = names(snd)[y])
  
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
        matchDate = as.Date(game$date, format = '%B %d, %Y'),
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
  dplyr::mutate(team = CorrectMyWriting(team)) %>% 
  dplyr::mutate(
    startMin = as.numeric(startMin), 
    endMin = as.numeric(endMin),
    assists = as.numeric(assists),
    fouls = as.numeric(fouls),
    penaltySaved = as.numeric(penaltySaved),
    ownGoal = as.numeric(ownGoal),
    foulsDrawn = as.numeric(foulsDrawn),
    shotsOnTarget = as.numeric(shotsOnTarget),
    penaltyScored = as.numeric(penaltyScored),
    yellow = as.numeric(yellow),
    red = as.numeric(red),
    penaltyConceded = as.numeric(penaltyConceded),
    penaltyMissed = as.numeric(penaltyMissed),
    goals = as.numeric(goals),
    shots = as.numeric(shots),
    saves = as.numeric(saves)) %>% 
  dplyr::mutate(
    startMin = ifelse(is.na(startMin), 0, startMin),
    endMin = ifelse(is.na(endMin), 0, endMin),
    assists = ifelse(is.na(assists), 0, assists),
    fouls = ifelse(is.na(fouls), 0, fouls),
    penaltySaved = ifelse(is.na(penaltySaved), 0, penaltySaved),
    ownGoal = ifelse(is.na(ownGoal), 0, ownGoal),
    foulsDrawn = ifelse(is.na(foulsDrawn), 0, foulsDrawn),
    shotsOnTarget = ifelse(is.na(shotsOnTarget), 0, shotsOnTarget),
    penaltyScored = ifelse(is.na(penaltyScored), 0, penaltyScored),
    yellow = ifelse(is.na(yellow), 0, yellow),
    red = ifelse(is.na(red), 0, red),
    penaltyConceded = ifelse(is.na(penaltyConceded), 0, penaltyConceded),
    penaltyMissed = ifelse(is.na(penaltyMissed), 0, penaltyMissed),
    goals = ifelse(is.na(goals), 0, goals),
    shots = ifelse(is.na(shots), 0, shots),
    saves = ifelse(is.na(saves), 0, saves)
  )

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
process_date <- format(Sys.Date(), "%Y%m%d")
if(!dir.exists('./Private/Data')){
  dir.create('./Private/Data')
}
if(!dir.exists(paste0('./Private/Data/DB Feed ',process_date))){
  dir.create(paste0('./Private/Data/DB Feed ',process_date))
}

write.csv(player_stats, file = paste0('./Private/Data/DB Feed ',process_date, "/snd_player_stats.csv"), row.names = FALSE)
write.csv(player_name, file = paste0('./Private/Data/DB Feed ',process_date, '/snd_player_name.csv'), row.names = FALSE)
write.csv(match_stats, file = paste0('./Private/Data/DB Feed ',process_date, '/snd_match_stats.csv'), row.names = FALSE)
write.csv(team_name, file = paste0('./Private/Data/DB Feed ',process_date, '/snd_team_name.csv"'), row.names = FALSE)

# fifa19 data conversion (only do it once)
# fifa_data <- read.csv('./Source Data/fifa_data.csv', stringsAsFactors = FALSE, encoding = 'UTF-8')
# fifa_data <- fifa_data %>% 
#   dplyr::mutate(Name = CorrectMyWriting(Name)) %>% 
#   dplyr::mutate(Club = CorrectMyWriting(Club))
# 
# write.csv(fifa_data, file = 'fifa19_data.csv', row.names = FALSE)