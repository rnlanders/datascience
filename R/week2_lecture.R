var <- 1
mode(var)
typeof(var)
class(var)

var2 <- 1L
mode(var2)
typeof(var2)
class(var2)

as.integer(1.2)
as.integer(1.9)
as.integer(TRUE)
as.integer("hello")

# TRUE and FALSE
# T and F

T <- 4
TRUE <- 4
rm(T)

1 == 4
1 > 4
4 > 1
"TRUE" == TRUE
"SOMETHING" == TRUE
"true" == TRUE
as.logical("true") == TRUE
class("TRUE")
class("true")
typeof("TRUE")

"he said 'yes'"
'he said "yes"'
"he said \"yes\""

var3 <- c(1, 2, 3)
var4 <- c(100:300)

# askjdfaksjdfhkjasd fkjhas dfkjlasd fkjasd flkjas fdlkjasd lkfjaslk fjlkas 
# dflkjasd flkjas dflkjas lkdfjaslkdfj laksjdf lkasjdflkasj flkajs dflkja sdlfkj 
# aslkdfj aslkdfj alskdjf lkasjdf lkajs dflkajs flkajs dlfkjas dlkfja slkfja 
# slkfj aslkfj alksjf lkasjf lkasjf lkasjdfl kajsdlkf 

var4[198]
var4[[198]]
var4[c(198)]
var4[c(1, 4, 6)]
var4[[c(1, 4, 6)]]

var5 <- 4:10
class(var5)
typeof(var5)
?seq
seq(from = 4, to = 10)
4:10

TRUE:5
as.integer(TRUE)
FALSE:5
TRUE:FALSE
"TRUE":6

var6 <- matrix(
  data = c(4, 5, 6, 7, 8, 9),
  nrow = 2,
  ncol = 3
)

var6[2]
var6[1,2]
var6[2,]
var6[,2]
typeof(var6[,2])

var7 <- c(1, "yes")
var8 <- list(1, "yes")
var8[1]
var8[[1]]
var8[1,1]
var8[c(1,2)]
var8[[c(1,2)]]

var9 <- data.frame(
  var1 = 1:50,
  var2 = 51:100  
)
View(var9)

var9[2]
class(var9[2])
var9[[2]]
class(var9[[2]])

# subset data frame
var9["var2"]

# extraction
var9[["var2"]]
var9$var2

# other examples
var9[c("var1","var2")]
var9[[c("var1","var2")]]

str(var9)

write.csv(var9, "sample.csv")
write.csv(var9, "out/sample.csv")
write.csv(var9, "docs/../out/sample.csv")


