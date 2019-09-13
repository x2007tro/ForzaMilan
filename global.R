##
# parameters
##
db_object <- list(
  dbtype = c('MariaDB', 'MSSQLServer_SqlAuth', 'MSSQLServer_WinAuth', 'MSAccessDB')[1],
  srv = c('192.168.2.200', '192.168.2.200,3307')[1],     # 1st for MariaDB | 2nd for MSSqlServer
  prt = 3307,                                            # not required for MSSqlServer
  dbn = 'SoccerPlayerStats',
  id = 'dspeast2',                                   # not required for MSSqlServer_WinAuth
  pwd = 'yuheng',                            # not required for MSSqlServer_WinAuth
  path = "C:/Github/ForzaMilan/Private/Data/player_db.accdb"                              # only required for MSAccess
)
league_name_tbl <- '100_010_AllLeagues'
season_tbl <- '100_020_AllSeasons'
position_tbl <- '100_030_AllPositions'
player_name_tbl <- '100_040_AllPlayerNames'
player_rec_ret_threshold <- 100
default_header_color <- 'rgba(192,192,192,0)'
sec_header_color <- '#CF6679' 

##
# shinyapp input
##
league_name <- ReadDataFromDB(db_object, league_name_tbl)[[1]]
seasons <- ReadDataFromDB(db_object, season_tbl)[[1]]
position <- ReadDataFromDB(db_object, position_tbl)[[1]]
player_name <- ReadDataFromDB(db_object, player_name_tbl)[[1]]
