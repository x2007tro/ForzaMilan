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
  dbn = 'SPSDB',
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

##
# append data into MariaDB
maria_db_obj <- list(
  dbtype = c('MariaDB', 'MSSQLServer_SqlAuth', 'MSSQLServer_WinAuth', 'MSAccessDB')[1],
  srv = c('192.168.2.200', '192.168.2.200,3307')[1],     # 1st for MariaDB | 2nd for MSSqlServer
  prt = 3307,                                            # not required for MSSqlServer
  dbn = 'SPSDB',
  id = 'dspeast2',                                   # not required for MSSqlServer_WinAuth
  pwd = 'yuheng',                            # not required for MSSqlServer_WinAuth
  path = "C:/Github/ForzaMilan/Private/Data/player_db.accdb"                              # only required for MSAccess
)
WriteDataToDB(maria_db_obj, player_attrs, "* Source 01 : FIFA19 Player Attrbs *")
WriteDataToDB(maria_db_obj, player_stats, "* Source 02 : FSN Player Stats *")
WriteDataToDB(maria_db_obj, match_stats, "* Source 03 : FSN Match Stats *")
WriteDataToDB(maria_db_obj, weight_map, "* Input 03 : Weight Map *")
WriteDataToDB(maria_db_obj, height_map, "* Input 02 : Height Map *")


