source("private.R")

# extract data function
ExtractData <- function(week, season, league){
  json_file <- paste0("http://www.fantasysportnet.com/data/feed",
                      "?week=", week, 
                      "&league=", league, 
                      "&season=", season, 
                      "&apiKey=", fsn_api_key,
                      "&format=", "json")
  json_data <- jsonlite::fromJSON(paste(readLines(json_file), collapse=""))
  return(json_data)
}
x <- ExtractData(week = "0812", league = 'isa', season = '1516')

# parameters
leagues <- c("epl", "blg", "isa", "spd", "l1")
seasons <- c("1516", "1617", "1718")
weeks <- seq(as.Date("2015-06-05"), by = "week", length.out = 52*3)

# extract raw results
raw_data <- lapply(leagues, function(lea){
  tmp_data <- lapply(seasons, function(sea){
    weeks_str <- format(weeks, "%m%d")
    tmp_data <- lapply(weeks, function(wee){
      print(paste0("Extract data from league ", lea, " | season ", sea, " | week ", wee))
      tmp_data <- ExtractData(wee, sea, lea)
      return(tmp_data)
    })
    names(tmp_data) <- format(weeks, "%y%m%d")
  })
  names(tmp_data) <- seasons
})
names(raw_data) <- leagues