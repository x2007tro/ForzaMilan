##
# function to convert all non-latin-ACSII charater to latin-ACSII
CorrectMyWriting <- function(target){
  y <- stringi::stri_trans_general(target, "Latin-ASCII")
  return(y)
}

##
# db operations
##
# Connect to access database
# dbp : database path
##
ConnAccess <- function(dbj){
  conn <- DBI::dbConnect(drv = odbc::odbc(),
                         Driver = "Microsoft Access Driver (*.mdb, *.accdb)",
                         DBQ = dbj$path)
  return(conn)
}

##
# Data handling
##
##
# Read a table from sel server db
##
ReadDataFromDB <- function(db_obj, tbl_name){
  conn <- ConnAccess(db_obj) # conn can be SQL Server, MySql or AcceDB database
  df <- DBI::dbReadTable(conn, tbl_name)
  DBI::dbDisconnect(conn)  
  return(df)
}

##
# Write a table to sql server db
##
WriteDataToDB <- function(db_obj, data, tbl_name, apd = FALSE){
  conn <- ConnAccess(db_obj)
  df <- DBI::dbWriteTable(conn, name = tbl_name, value = data,
                          append = apd, overwrite = !apd, row.names = FALSE)
  DBI::dbDisconnect(conn) 				  
  return(df)
}

##
# List all tables and queries
##
ListTblsFromDB <- function(db_obj){
  conn <- ConnAccess(db_obj)
  dfs_tn <- DBI::dbListTables(conn, scheme = "dbo")
  DBI::dbDisconnect(conn)
  return(dfs_tn)
}

##
# Send query to db
##
GetQueryResFromDB <- function(db_obj, qry_str){
  conn <- ConnAccess(db_obj)
  qry_conn <- DBI::dbSendQuery(conn, qry_str)
  res <- DBI::dbFetch(qry_conn)
  DBI::dbClearResult(qry_conn)
  DBI::dbDisconnect(conn)
  return(res)
}

##
# PLot
##
UtilPlotPlayerPerf <- function(master_plot_data, metric, seas, leag){
  
  tmp_data <- master_plot_data
  if(seas != "all"){
    tmp_data <- tmp_data %>% 
      dplyr::filter(season == seas)
  } 
  
  if(leag != "all"){
    tmp_data <- tmp_data %>% 
      dplyr::filter(league == leag)
  } 
  
  my_plot <- ggplot(tmp_data, aes_string(x = 'matchDate', y = metric, color = 'name')) +
    geom_line() +
    ggtitle(paste0(metric)) +
    #labs(caption = paste0("Plot produced on ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))) +
    theme_pka() +
    theme(line = element_line(size = 1))
  
  return(my_plot)
}