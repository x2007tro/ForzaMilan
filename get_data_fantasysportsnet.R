source("private.R")

# extract data function
ExtractData <- function(week, season, league){
  json_file <- paste0("http://www.fantasysportnet.com/data/feed",
                      "?week=", week, 
                      "&league=", league, 
                      "&season=", season, 
                      "&apiKey=", fsn_api_key,
                      "&format=", "json")
  json_data <- jsonlite::fromJSON(json_file)
  return(json_data)
}

# parameters
leagues <- c("epl", "blg", "isa", "spd", "l1")[3]

seasons <- list(
  s1 = list(
    season = '1516',
    weeks = seq(as.Date("2015-07-31"), by = "week", length.out = 45)
  ),
  s2 = list(
    season = '1617',
    weeks = seq(as.Date("2016-07-29"), by = "week", length.out = 45)
  ),
  s3 = list(
    season = '1718',
    weeks = seq(as.Date("2017-07-28"), by = "week", length.out = 45)
  ),
  s4 = list(
    season = '1819',
    weeks = seq(as.Date("2018-07-27"), by = "week", length.out = 45)
  ),
  s5 = list(
    season = '1920',
    weeks = seq(as.Date("2019-07-26"), by = "week", length.out = 5)
  )
)

# extract raw resultsY
raw_data <- lapply(leagues, function(lea){
  tmp_data <- lapply(seasons, function(sea){
    weeks_str <- format(sea$weeks, "%m%d")
    tmp_data <- lapply(weeks_str, function(wee){
      print(paste0("Extract data from league ", lea, " | season ", sea$season, " | week ", wee))
      tmp_data <- ExtractData(wee, sea$season, lea)
      
      if("league" %in% names(tmp_data)){
        if(length(tmp_data$league) > 3) {
          print("Data retrieved!") 
        } else {
          tmp_data <- NULL
        }
      } else {
        tmp_data <- NULL
      }
      
      Sys.sleep(30)
      return(tmp_data)
    })
    names(tmp_data) <- format(sea$weeks, "%y%m%d")
    return(tmp_data)
  })
  names(tmp_data) <- unlist(lapply(seasons, "[", 1))
  return(tmp_data)
})
names(raw_data) <- leagues
isa <- raw_data
save(isa, file = "isa.RData")