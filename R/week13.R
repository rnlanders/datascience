library(RMariaDB)
library(keyring)

conn <- dbConnect(MariaDB(),
                  user="lande065",
                  password=key_get("latis-mysql","lande065"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = 'mysql_hotel_umn_20220728_interm.cer'
)

result1 <- dbGetQuery(conn, "SHOW DATABASES;")
result2 <- dbExecute(conn, "USE cla_tntlab;")
result3 <- dbGetQuery(conn, "DESCRIBE hirevue_practice;")