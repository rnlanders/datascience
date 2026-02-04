# Comparators
c(1,2,3) == c(1,2)
c(1,2,3) == c(1,2,4)
c(1,2) == c(1,2,3,4)
c(1,2) == c(1,2,3,4,5)

TRUE & FALSE
TRUE & TRUE
TRUE & FALSE & TRUE
TRUE | FALSE & TRUE
c(1,2) & c(2,3)
as.logical(c(1,2)) & 
  as.logical(c(2,3))
c(TRUE, TRUE) & c(TRUE, TRUE)
c(0,2) & c(2,3)
c(0,2) && c(2,3)
c(0,2) | c(2,3)
c(0,2) || c(2,3)

9 < (5 %% 3) + 7 | (5 > 9) | FALSE
9 < 2 + 7 | (5 > 9) | FALSE
9 < 9 | 5 > 9 | FALSE
FALSE | FALSE | FALSE

FALSE & FALSE
FALSE == FALSE
"F" & "T"
as.logical("F") & as.logical("T")
2 & 4
1 & 0
"1" & "0"
as.logical("1") & as.logical("0")

if (1 == 1) print("YES") 
if (1 == 1)
  print("YES") 
if (1 == 1) {
  print("YES")
  print("IT IS")
}
if (TRUE) print ("YES")
x <- 1
if (x) print("YES")
if (c(TRUE,TRUE)) print("YES")

if (x < 0) print("negative") else print("nope")

x <- "1"  # ""
if (x < 0) {
  print("negative")
} else if (x > 0) {
  print("positive")
} else {
  print("zero")
}

x <- 0
while (x < 10) {
  x <- x + 1
  print(x)
}
while (x < 10) x <- x + 1
for (x in 1:10) { 
  print(x) 
}
df1 <- mtcars
df2 <- mtcars
df_list <- list(df1, df2)
for (df in df_list) {  # doesn't need to be numbers!!!
  str(df)
}

mean(x = mtcars[1:4,]$cyl)
result <- mean(x = subset(mtcars, cyl == 6)$hp)
my_subset <- subset(mtcars, cyl == 6)
result <- mean(x = my_subset$hp)

my_function <- function() { print("did it")}
my_function()  

my_function <- function(x) { print(x) }
my_function(1)
my_function()  

my_function <- function(x) { print(x = 1) }
my_function()

my_df <- data.frame(
  var1 = c(1,2,3),
  var2 = c("5","2","1"),
  var3 = c("9","2","3")
)
new_df <- lapply(my_df, as.numeric)
new_df <- lapply(my_df, function(x) { as.numeric(x) })
new_df <- lapply(my_df, \(x) { as.numeric(x) })

lapply(mtcars, hist)

Sys.time()
as.numeric(Sys.time())  # UNIX epoch

mean(c(1,2,3))
mean(c(1,NA,3))
mean(c(1,NA,3), na.rm=T)
