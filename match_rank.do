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
  rename mean_rank vind7090
  sort vind7090

  lab var vind7090 "BEA industry ranked by value added per worker"
  #delimit ;
  label define vind7090
1	"Other services"2	"Arts, entertainment, and recreation, accommodation, and food services"3	"Educational services, health care, and social assistance"4	"Retail trade"5	"Construction"6	"Professional and business service"7	"Manufacturing-Durable goods"8	"Manufacturing-Nondurable goods"9	"Transportation and warehousing"10	"Agriculture, forestry, fishing, and hunting"11	"Wholesale trade"12	"Information"13	"Mining"14	"Finance and insurance, real estate, rental, and leasing"15	"Utilities"16	"Government"
;
  #delimit cr
  lab val vind7090 vind7090
  

**********************************************************************
**Generates jobs based on ranked BEA industry and 1-digit occupation pair
  sort vind7090 mocc1990
  merge vind7090 mocc1990 using job.dta
  tab _merge
  drop if _merge == 2 
  drop _merge
  summ job
  
 
  saveold ../basic_extract/cps`x'.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

erase ../result/va_ind_rank_merge.dta

log close


