# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RMariaDB)
library(keyring)

# Data Import and Cleaning
conn <- dbConnect(MariaDB(),
                  user="lande065",
                  password=key_get("latis-mysql","lande065"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = '../mysql_hotel_umn_20220728_interm.cer'
)

result1 <- dbExecute(conn, "USE cla_tntlab;")

dbGetQuery(conn, "
  SELECT COUNT(*) FROM datascience_employees AS employees
  	LEFT JOIN datascience_offices 
  		AS offices 
  		ON employees.city = offices.office
  	INNER JOIN datascience_testscores
  		AS testscores
      ON employees.employee_id = testscores.employee_id
")

dbGetQuery(conn, "
  SELECT COUNT(DISTINCT(employees.employee_id)) FROM datascience_employees AS employees
  	LEFT JOIN datascience_offices 
  		AS offices 
  		ON employees.city = offices.office
  	INNER JOIN datascience_testscores
  		AS testscores
      ON employees.employee_id = testscores.employee_id
")

dbGetQuery(conn, "
  SELECT city,COUNT(employees.employee_id) FROM datascience_employees AS employees
  	LEFT JOIN datascience_offices 
  		AS offices 
  		ON employees.city = offices.office
  	INNER JOIN datascience_testscores
  		AS testscores
      ON employees.employee_id = testscores.employee_id
    WHERE manager_hire = 'N'
    GROUP BY city
")

dbGetQuery(conn, "
  SELECT performance_group, AVG(yrs_employed),STDDEV(yrs_employed) FROM datascience_employees AS employees
  	LEFT JOIN datascience_offices 
  		AS offices 
  		ON employees.city = offices.office
  	INNER JOIN datascience_testscores
  		AS testscores
      ON employees.employee_id = testscores.employee_id
    GROUP BY performance_group
")

dbGetQuery(conn, "
  SELECT employees.employee_id, type, test_score FROM datascience_employees AS employees
  	LEFT JOIN datascience_offices 
  		AS offices 
  		ON employees.city = offices.office
  	INNER JOIN datascience_testscores
  		AS testscores
      ON employees.employee_id = testscores.employee_id
    ORDER BY type, test_score DESC
")
