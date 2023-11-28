library(DBI)
library(dplyr)
library(dbplyr)
library(odbc)
library(reshape2)
library(ggplot2)



connect_to_snowflake <- function(warehouse, database, schema) {
  # Attempt to connect to Snowflake using provided credentials
  success <- tryCatch({
    myconn <- dbConnect(odbc::odbc(), "shashwat", role = 'ACCOUNTADMIN', PWD = "Shyam_Sundar_Tewari31!")
    
    # Set the warehouse, database, and schema to the specified values
    dbExecute(myconn, paste0("USE WAREHOUSE ", toupper(warehouse), ";"))
    dbExecute(myconn, paste0("USE DATABASE ", toupper(database), ";"))
    dbExecute(myconn, paste0("USE SCHEMA ", toupper(schema), ";"))
    
    # Assuming Snowflake session variables are available for retrieval like this
    current_warehouse <- dbGetQuery(myconn, "SELECT CURRENT_WAREHOUSE() AS WAREHOUSE;")
    current_database <- dbGetQuery(myconn, "SELECT CURRENT_DATABASE() AS DATABASE;")
    current_schema <- dbGetQuery(myconn, "SELECT CURRENT_SCHEMA() AS SCHEMA;")
    
    list(
      warehouse = current_warehouse$WAREHOUSE,
      database = current_database$DATABASE,
      schema = current_schema$SCHEMA
    )
  }, error = function(e) {
    message("Error connecting to Snowflake: ", e$message)
    NULL
  })
  
  if (!is.null(success)) {
    print("Connected to Snowflake successfully.")
  }
  
  return(myconn)
}

myconn<- connect_to_snowflake("ANALYTICS","ANALYTICS_DATA","HPLC_DATA")

dbGetQuery(myconn, "USE WAREHOUSE ANALYTICS;")
dbGetQuery(myconn, "USE DATABASE ANALYTICS_DATA;")
dbGetQuery(myconn, "USE SCHEMA HPLC_DATA;")

hplc<- dbGetQuery(myconn,"SELECT DISTINCT SAMPLE_NAME FROM LACTOFERRIN;")

sample_data<- dbGetQuery(myconn,"SELECT * FROM LACTOFERRIN WHERE SAMPLE_NAME IN ('046-P2-E7-HTS-USP-231108CC-Ops-Prod-2-E7');")
