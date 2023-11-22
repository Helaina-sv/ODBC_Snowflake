library(DBI)
library(dplyr)
library(dbplyr)
library(odbc)


myconn <- dbConnect(odbc::odbc(), "shashwat", pwd= Sys.getenv('SNOWFLAKE_PASSWORD'), role = 'ACCOUNTADMIN')

DBI::dbGetQuery(myconn,"USE WAREHOUSE USP;") 
DBI::dbGetQuery(myconn,"USE DATABASE USP_DATA;") 
DBI::dbGetQuery(myconn,"USE SCHEMA OFF_GAS_DATA;") 


brcdata<- DBI::dbGetQuery(myconn,"SELECT * FROM BRC;")
head(mydata)