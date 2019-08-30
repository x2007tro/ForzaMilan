library(magrittr)

# get data
json_file <- 'https://datahub.io/sports-data/italian-serie-a/datapackage.json'
json_data <- jsonlite::fromJSON(paste(readLines(json_file), collapse=""))

# get list of all resources:
print(json_data$resources$name)

# print all tabular data(if exists any)
data_list <- lapply(1:length(json_data$resources$datahub$type), function(i){
  print(paste0("Read data at iter ", i))
  if(json_data$resources$datahub$type[i]=='derived/csv'){
    path_to_file <- json_data$resources$path[i]
    data <- read.csv(url(path_to_file), stringsAsFactors = FALSE)
    data <- data %>% 
      dplyr::mutate(Date = as.Date(Date, format = "%d/%m/%Y"))
  } else {
    data <- NULL
  }
})
data_list <- data_list[-which(sapply(data_list, is.null))]

# 18-19 season data
data_1819 <- data_list[[1]]
