library(magrittr)
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
  
