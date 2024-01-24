x <- 234
x = 655

1 < 5
result <- 1 < c(1,6)
modecheck <- mode(result)
typeof(result)
typeof(modecheck)

T
F
TRUE
FALSE

"st'ring text"
'st"ring text'

# Mytext <- “text”
# '`"/\

x

1 == "1"
as.numeric("1")

c(1,"1")
c(1,"w")
c(1,F)

1:6
y <- c(7,4,1,8,51,26)

y[1]
y[5:6]
y[c(1,2)]

z <- matrix(
  data = c(6,1,3,9),
  nrow = 2,
  ncol = 2,
  byrow = F
)

z[3]
z[2,]
z[,1]
z[2,2]

x1 <- list(2:6,T:F)
unlist(list(2,T))

x1[1][1][1][1]

x1[1]
x1[[1]][2]

x1 <- data.frame(2:6,T:F)
