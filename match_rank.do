*Program: match_rank.do
*Date 5/April/2012

******************************************************************************
* THIS PROGRAM RANKS VIND7090 IN CPS BASIC EXTRACTS BY VALUE ADDED PER WORKER* 
******************************************************************************

set more 1
log using log_match_rank, text replace

* calculate the rank of industry by value added per value, the best industry with the biggest number

import excel "../result/va_ind.xlsx", sheet("Sheet1") firstrow

forvalues i = 1948/2010 {
  egen y`i'rank = rank(y`i'), track
}

order _all, seq

gen sum = 0
forvalues i = 1948/2010 {
  replace sum = sum + y`i'rank
}

replace sum = sum / 63

egen mean_rank = rank(sum), track

saveold ../result/va_ind_rank.dta, replace




* prepare the file for merging with cps basic extracts

gen vind7090 = _n
keep vind7090 mean_rank
sort vind7090

  * label BEA codes vind7090
  lab var vind7090 "BEA industry"
  #delimit ;
  label define vind7090
1 "Agriculture, forestry, fishing, and hunting"
2 "Mining"
3 "Utilities"
4 "Construction"
5 "Manufacturing-Durable goods"
6 "Manufacturing-Nondurable goods"
7 "Wholesale trade"
8 "Retail trade"
9 "Transportation and warehousing"
10 "Information"
11 "Finance and insurance"
12 "Real estate, rental, and leasing"
13 "Professional, scientific, and technical services"
14 "Management, Administrative and waste services"
15 "Educational services"
16 "Health care and social assistance"
17 "Arts, entertainment, and recreation"
18 "Accommodation and food services"
19 "Other services, except government"
20 "Government"
;
  #delimit cr
  lab val vind7090 vind7090

sort vind7090
saveold ../result/va_ind_rank_merge.dta, replace



* rank the vind7090 in cps basic extracts by value added per worker, the best industry ranked with the biggest number

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  
  *rank the industry by value added per worker
  sort vind7090
  merge vind7090 using ../result/va_ind_rank_merge.dta
  drop if _merge==2
  drop vind7090 _merge
  label drop vind7090
  rename mean_rank vind7090
  sort vind7090

  lab var vind7090 "BEA industry ranked by value added per worker"
  #delimit ;
  label define vind7090
1 "Accommodation and food services"
2 "Educational services"
3 "Other services, except government"
4 "Health care and social assistance"
5 "Retail trade"
6 "Government"
7 "Arts, entertainment, and recreation"
8 "Management, Administrative and waste services"
9 "Construction"
10 "Manufacturing-Durable goods"
11 "Manufacturing-Nondurable goods"
12 "Transportation and warehousing"
13 "Professional, scientific, and technical services"
14 "Agriculture, forestry, fishing, and hunting"
15 "Finance and insurance"
16 "Wholesale trade"
17 "Information"
18 "Mining"
19 "Utilities"
20 "Real estate, rental, and leasing"
;
  #delimit cr
  lab val vind7090 vind7090
 
  saveold ../basic_extract/cps`x'.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

log close


