source("./Private/Code/api_keys.R")

# test code
#test_json_file <- "http://www.fantasysportnet.com/data/feed?week=0812&league=test&season=1617&apiKey=FSN8776143&format=json"
#test_json_data <- jsonlite::fromJSON(test_json_file)

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
leagues <- c("epl", "blg", "isa", "spd", "l1")

seasons <- list(
  # s1 = list(
  #   season = '1516',
  #   weeks = seq(as.Date("2015-08-07"), by = "week", length.out = 50)
  # ),
  # s2 = list(
  #   season = '1617',
  #   weeks = seq(as.Date("2016-07-29"), by = "week", length.out = 50)
  # ),
  # s3 = list(
  #   season = '1718',
  #   weeks = seq(as.Date("2017-07-28"), by = "week", length.out = 50)
  # ),
  # s4 = list(
  #   season = '1819',
  #   weeks = seq(as.Date("2018-07-27"), by = "week", length.out = 50)
  # ),
  # s5 = list(
  #   season = '1920',
  #   weeks = seq(as.Date("2019-07-26"), by = "week", length.out = 5)
  # ),
  s6 = list(
    season = '1920',
    weeks = seq(as.Date("2019-08-30"), by = "week", length.out = 5)
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
    tmp_data <- tmp_data[which(!sapply(tmp_data, is.null))]
    return(tmp_data)
  })
  names(tmp_data) <- unlist(lapply(seasons, "[", 1))
  return(tmp_data)
})
names(raw_data) <- leagues

# save raw data
if(!dir.exists('./Private/Data')){
  dir.create('./Private/Data')
}
if(!dir.exists(paste0('./Private/Data/DB Feed ',process_date))){
  dir.create(paste0('./Private/Data/DB Feed ',process_date))
}
saveRDS(raw_data, file = "./Private/Data/Raw/snd.RDs")