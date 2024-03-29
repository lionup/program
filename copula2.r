# This program apply the t-copula to hourly wage of t and t+1 and estimate the parameters

r <- data.frame()

require(foreign)
require(copula)

date <- 197901
cop <- tCopula(0.3)

while(date <= 201012) {
  
  if (date == 198407 | date == 198408 | date == 198409 | date == 198410 | 
    date == 198411 | date == 198412 | date == 198501 | date == 198502 | 
    date == 198503 | date == 198504 | date == 198505 | date == 198506 | 
    date == 198507 | date == 198508 | date == 198509 | date == 199406 | 
    date == 199407 | date == 199408 | date == 199409 | date == 199410 |
    date == 199411 | date == 199412 | date == 199501 | date == 199502 | 
    date == 199503 | date == 199504 | date == 199505 | date == 199506 | 
    date == 199507 | date == 199508) {
    cat(date,"\n")
    t <- date + 100
    r1 <- data.frame(date = t , corr = NA, df = NA)
  } else {
    cat(date,"\n")
    # loading the data 
    path <- paste("../result/copula",date,".dta",sep="")
    data <- read.dta(path)
    
    # delete the data file created by copula1.do
    unlink(path)
    
    # wage copula of t and t+1 
    n <- nrow(data)
    u <- apply(data, 2, rank) / (n + 1) 
    fit.mpl <- fitCopula(cop, u, method="mpl", start = c(0.3, 10), estimate.variance = F)
    t <- date + 100
    r1 <- data.frame(date = t , corr = fit.mpl@estimate[1], df = fit.mpl@estimate[2])
  }
  
  r <- rbind(r,r1)
  
  date <- date + 1
  if ((date - 13) / 100 == floor((date - 13) / 100)) {
    date <- date + 88
  }
}

write.dta(r, "../result/copula.dta")
q()

