c(TRUE, FALSE, TRUE) & (c(TRUE) | FALSE)

{
  x <- 1
  y <- 1
}

if (x == 1) { 
  print("made it") 
} else if (y <- y + 1) { 
  print("nope") 
} else { 
  print("almost never") 
}
  print("UHOH")  # misleading tab!

if (x<0) {
  print("negative")
} else if (x>0) {
  print("positive") 
} else { 
  print("zero")
}

i <- 0
while (i<10) {
  i <- i + 1
  print(paste("this line is", i))
}

for (i in c(1,6,4)) {
  print(i)
  if(i==6) break  # don't do this!
}

seq(5,1)
seq(from=5, to=1)
seq(from=5)
seq(to=1, 5)  

x <- seq(1,5)

print_one <- function(y = "default") {
  print(1)
  print(y)
  return("my return")
}

add_one <- function(x, y = 1) { return (x+y)}

strv <- c("yes","no","MAYBE")
casefold(strv, upper=T)
lapply(strv, casefold, upper=T)
sapply(strv, casefold, upper=T)

library(psych)
data(bfi)

View(data.frame(sapply(bfi, 
       function(x) 
         return(
           list(
             mean = mean(x, na.rm=T), 
             sd = sd(x, na.rm=T)
             )
           )
       )))

x <- list(c(1,2,3), c(4,5,6))
lapply(x, function(x) return(mean(x)))
sapply(x, function(x) return(mean(x)))
