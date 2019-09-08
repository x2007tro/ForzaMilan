##
# parameters
##
db_object <- list(
  path = "C:/Github/ForzaMilan/Private/Data/player_db.accdb"
)
league_name_tbl <- '300_010_AllLeagues'
season_tbl <- '300_030_AllSeasons'
position_tbl <- '300_020_AllPositions'
player_name_tbl <- '300_030_AllPlayerNames'
player_rec_ret_threshold <- 200
default_header_color <- 'rgba(192,192,192,0)'
sec_header_color <- '#CF6679' 

##
# shinyapp input
##
league_name <- ReadDataFromDB(db_object, league_name_tbl)[[1]]
seasons <- ReadDataFromDB(db_object, season_tbl)[[1]]
position <- ReadDataFromDB(db_object, position_tbl)[[1]]
player_name <- ReadDataFromDB(db_object, player_name_tbl)[[1]]
