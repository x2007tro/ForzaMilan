library(magrittr)
library(ggplot2)
source('./Helpers/helper.R')
source('./Private/Code/secret.R')

# table names
player_name_tbl <- '* Input 01 : Player Name Map *'
player_attrs_tbl <- '* Source 01 : FIFA19 Player Attrbs *'
player_stats_tbl <- '* Source 02 : FSN Player Stats *'
match_stats_tbl <- '* Source 03 : FSN Match Stats *'

# data peek
player_stats <- ReadDataFromDB(db_object, player_stats_tbl)
player_stats_tmp <- player_stats %>% 
  dplyr::mutate(reliable = ifelse(endMin - startMin > 45, 1, 0))
player_stats <- player_stats_tmp
  
# graph data manipulation
players <- unique(player_stats$name)
player_graph_data <- lapply(players, function(plyr){
  tmp_data <- player_stats %>% 
    dplyr::filter(name == plyr)
  return(tmp_data)
})
names(player_graph_data) <- players
test_player <- player_graph_data$`Kyle Walker`
plt <- ggplot(test_player, aes(matchDate, ownGoal)) +
  geom_point()

