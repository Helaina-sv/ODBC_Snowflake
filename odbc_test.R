library(DBI)
library(dplyr)
library(dbplyr)
library(odbc)
library(reshape2)
library(ggplot2)



connect_to_snowflake <- function(warehouse, database, schema) {
  # Attempt to connect to Snowflake using provided credentials
  success <- tryCatch({
    myconn <- dbConnect(odbc::odbc(), "shashwat", role = 'ACCOUNTADMIN')
    
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
  
  return(success)
}


connect_to_snowflake("USP","USP_DATA","OFF_GAS_DATA")

solaris<- dbGetQuery(myconn,"SELECT * FROM SOLARIS WHERE RUNID IN ('I4 - W50', 'I3 - W51');")

colnames(solaris)<- tolower(colnames(solaris))

df<- melt(solaris, id.vars = c("elapsedtimes","runid"))
df<- df %>%
  filter(!value %in% NA)%>%
  filter(value>0)%>%
  mutate(elapsedtimes = elapsedtimes/3600)%>%
  filter(elapsedtimes <100)
df_to_plot<- df %>% 
  filter(variable %in% c("process_do2_"))

ggplot( df_to_plot[seq(0, nrow(df_to_plot),100),], 
        aes(
  x= elapsedtimes,
  y= value,
  color = runid
))+
  geom_line()+
  facet_wrap(~variable, scales = "free")+
  geom_point(size = 0.1)+
theme_linedraw()
