##
# function to convert all non-latin-ACSII charater to latin-ACSII
CorrectMyWriting <- function(target){
  y <- stringi::stri_trans_general(target, "Latin-ASCII")
  return(y)
}

##
# Connect to mariaDB/mysql server
##
ConnMariaDB <- function(db_obj){
  conn <- DBI::dbConnect(drv = RMariaDB::MariaDB(),
                         user = db_obj$id,
                         password = db_obj$pwd,
                         dbname = db_obj$dbn,
                         host = db_obj$srv,
                         port = db_obj$prt)
  return(conn)
}

##
# Connect to sql server - SQL authentication
##
ConnMSSqlServer_SQLAuth <- function(db_obj){
  conn <- DBI::dbConnect(drv = odbc::odbc(),
                         Driver = "ODBC Driver 17 for SQL Server",
                         Server = db_obj$srv,
                         Database = db_obj$dbn,
                         UID = db_obj$id,
                         PWD = db_obj$pwd)
  return(conn)
}

##
# Connect to sql server - windows authentication
##
ConnMSSqlServer_WinAuth <- function(db_obj){
  conn <- DBI::dbConnect(drv = odbc::odbc(),
                         Driver = "ODBC Driver 17 for SQL Server",
                         Server = db_obj$srv,
                         Database = db_obj$dbn,
                         trusted_connection = "yes")
  return(conn)
}

##
# Connect to access database
# dbp : database path
##
ConnMSAccess <- function(db_obj){
  conn <- DBI::dbConnect(drv = odbc::odbc(),
                         Driver = "Microsoft Access Driver (*.mdb, *.accdb)",
                         DBQ = db_obj$path)
  return(conn)
}

##
# Data handling
##
##
# Read a table from sel server db
##
ReadDataFromDB <- function(db_obj, tbl_name){
  # establish connection to DB
  if(db_obj$dbtype == 'MariaDB'){
    conn <- ConnMariaDB(db_obj)
  } else if (db_obj$dbtype == 'MSSQLServer_SqlAuth') {
    conn <- ConnMSSqlServer_SQLAuth(db_obj)
  } else if (db_obj$dbtype == 'MSSQLServer_WinAuth') {
    conn <- ConnMSSqlServer_WinAuth(db_obj)
  } else if (db_obj$dbtype == 'MSAccessDB') {
    conn <- ConnMSAccess(db_obj)
  } else {
    conn <- NULL
  }
  
  df <- DBI::dbReadTable(conn, tbl_name)
  DBI::dbDisconnect(conn)  
  return(df)
}

##
# Write a table to sql server db
##
WriteDataToDB <- function(db_obj, data, tbl_name, apd = FALSE){
  # establish connection to DB
  if(db_obj$dbtype == 'MariaDB'){
    conn <- ConnMariaDB(db_obj)
  } else if (db_obj$dbtype == 'MSSQLServer_SqlAuth') {
    conn <- ConnMSSqlServer_SQLAuth(db_obj)
  } else if (db_obj$dbtype == 'MSSQLServer_WinAuth') {
    conn <- ConnMSSqlServer_WinAuth(db_obj)
  } else if (db_obj$dbtype == 'MSAccessDB') {
    conn <- ConnMSAccess(db_obj)
  } else {
    conn <- NULL
  }
  
  df <- DBI::dbWriteTable(conn, name = tbl_name, value = data,
                          append = apd, overwrite = !apd, row.names = FALSE)
  DBI::dbDisconnect(conn) 				  
  return(df)
}

##
# List all tables and queries
##
ListTblsFromDB <- function(db_obj){
  # establish connection to DB
  if(db_obj$dbtype == 'MariaDB'){
    conn <- ConnMariaDB(db_obj)
  } else if (db_obj$dbtype == 'MSSQLServer_SqlAuth') {
    conn <- ConnMSSqlServer_SQLAuth(db_obj)
  } else if (db_obj$dbtype == 'MSSQLServer_WinAuth') {
    conn <- ConnMSSqlServer_WinAuth(db_obj)
  } else if (db_obj$dbtype == 'MSAccessDB') {
    conn <- ConnMSAccess(db_obj)
  } else {
    conn <- NULL
  }
  
  dfs_tn <- DBI::dbListTables(conn, scheme = "dbo")
  DBI::dbDisconnect(conn)
  return(dfs_tn)
}

##
# Send query to db
##
GetQueryResFromDB <- function(db_obj, qry_str){
  # establish connection to DB
  if(db_obj$dbtype == 'MariaDB'){
    conn <- ConnMariaDB(db_obj)
  } else if (db_obj$dbtype == 'MSSQLServer_SqlAuth') {
    conn <- ConnMSSqlServer_SQLAuth(db_obj)
  } else if (db_obj$dbtype == 'MSSQLServer_WinAuth') {
    conn <- ConnMSSqlServer_WinAuth(db_obj)
  } else if (db_obj$dbtype == 'MSAccessDB') {
    conn <- ConnMSAccess(db_obj)
  } else {
    conn <- NULL
  }
  
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