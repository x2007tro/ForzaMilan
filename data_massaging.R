library(magrittr)
library(ggplot2)
source('./Helpers/helper.R')
source('./Private/Code/secret.R')

# table names
player_name_tbl <- '* Input 01 : Player Name Map *'
player_attrs_tbl <- '* Source 01 : FIFA19 Player Attrbs *'
player_stats_tbl <- '* Source 02 : FSN Player Stats *'
match_stats_tbl <- '* Source 03 : FSN Match Stats *'
weight_map <- '* Input 03 : Weight Map *'
height_map <- '* Input 02 : Height Map *'

# load data from access
aces_db_obj <- list(
  dbtype = c('MariaDB', 'MSSQLServer_SqlAuth', 'MSSQLServer_WinAuth', 'MSAccessDB')[4],
  srv = c('192.168.2.200', '192.168.2.200,0000')[1],     # 1st for MariaDB | 2nd for MSSqlServer
  prt = 3307,                                            # not required for MSSqlServer
  dbn = 'SoccerPlayerStats',
  id = 'dspeast2',                                   # not required for MSSqlServer_WinAuth
  pwd = 'yuheng',                            # not required for MSSqlServer_WinAuth
  path = "C:/Github/ForzaMilan/Private/Data/player_db.accdb"                              # only required for MSAccess
)
player_name <- ReadDataFromDB(aces_db_obj, player_name_tbl)
player_attrs <- ReadDataFromDB(aces_db_obj, player_attrs_tbl) %>% dplyr::select(-dplyr::one_of('LoanedFrom'))
player_stats <- ReadDataFromDB(aces_db_obj, player_stats_tbl)
match_stats <- ReadDataFromDB(aces_db_obj, match_stats_tbl)
weight_map <- ReadDataFromDB(aces_db_obj, weight_map)
height_map <- ReadDataFromDB(aces_db_obj, height_map)

player_stats2 <- dplyr::inner_join(player_name, player_stats, by = 'name') %>% 
  dplyr::select(-name)

player_name2 <- player_name %>% 
  dplyr::select(fifa_id, name)

player_attrs2 <- dplyr::inner_join(player_attrs, height_map[,1:2], by = c('Height' = 'TextHeight'))
player_attrs3 <- dplyr::inner_join(player_attrs2, weight_map[,1:2], by = c('Weight' = 'TextWeight'))
player_attrs3 <- player_attrs3 %>% 
  dplyr::mutate(Weight = Weight.y, Height = Height.y) %>% 
  dplyr::select(-dplyr::one_of(c('Height.y','Weight.y')))
  
##
# append data into MariaDB
maria_db_obj <- list(
  dbtype = c('MariaDB', 'MSSQLServer_SqlAuth', 'MSSQLServer_WinAuth', 'MSAccessDB')[1],
  srv = c('192.168.2.200', '192.168.2.200,3307')[1],     # 1st for MariaDB | 2nd for MSSqlServer
  prt = 3307,                                            # not required for MSSqlServer
  dbn = 'SoccerPlayerStats',
  id = 'dspeast2',                                   # not required for MSSqlServer_WinAuth
  pwd = 'yuheng',                            # not required for MSSqlServer_WinAuth
  path = "C:/Github/ForzaMilan/Private/Data/player_db.accdb"                              # only required for MSAccess
)
# WriteDataToDB(maria_db_obj, head(player_attrs), "* Source 01 : FIFA19 Player Attrbs *")
# WriteDataToDB(maria_db_obj, head(player_stats2), "* Source 02 : FSN Player Stats *")
# WriteDataToDB(maria_db_obj, head(match_stats), "* Source 03 : FSN Match Stats *")
# WriteDataToDB(maria_db_obj, head(player_name2), "* Input 01 : Player Name Map *")
# WriteDataToDB(maria_db_obj, head(height_map), "* Input 02 : Height Map *")
# WriteDataToDB(maria_db_obj, head(weight_map), "* Input 03 : Weight Map *")

WriteDataToDB(maria_db_obj, player_attrs3, "* Source 01 : FIFA19 Player Attrbs *")
WriteDataToDB(maria_db_obj, player_stats2, "* Source 02 : FSN Player Stats *")
WriteDataToDB(maria_db_obj, match_stats, "* Source 03 : FSN Match Stats *")
WriteDataToDB(maria_db_obj, player_name, "* Input 01 : Player Name Map *")
WriteDataToDB(maria_db_obj, height_map, "* Input 02 : Height Map *")
WriteDataToDB(maria_db_obj, weight_map, "* Input 03 : Weight Map *")
