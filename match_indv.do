*Program: match_indv.do
*Date 5/April/2012


set more 1

log using log_match_indv, text replace

use ../result/va_ind_rank.dta
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
14 "Management of companies and enterprises"
15 "Administrative and waste managemether services"
16 "Educational services"
17 "Health care and social assistance"
18 "Arts, entertainment, and recreation"
19 "Accommodation and food services"
20 "Other services, except government"
21 "Government"
;
  #delimit cr
  lab val vind7090 vind7090

sort vind7090
saveold ../result/va_ind_rank_merge.dta


local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  
  *rank the industry by value added per worker
  sort vind7090
  merge vind7090 using ../result/va_ind_rank_merge.dta
  drop _merge
  
  * keep only the records at least 16 years old, employed, and with no missing value on education and mean_rank 
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | mean_rank == .

  * create sorting variable "indEduc" categoried by industry and education
  tostring educ6c, gen(educ2)
  tostring mean_rank, gen(ind2)
  replace educ2 = "e" + educ2
  gen str4 indEduc = ind2 + educ2
  sort indEduc

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double I = total(fweight), by (indEduc)
  replace I = I / 1000
  if `x' > 199400 { 
	replace I = I / 100
  }
  
  sort indEduc
  quietly by indEduc:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep indEduc I
  gen date = `x'
  reshape wide I, i(date) j(indEduc) string
 
  * some industry and education category do not exist so just give them value 0
  numlist "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21"

  foreach m of numlist `r(numlist)' { 
    forvalues n = 1/6 {
      capture confirm variable I`m'e`n'
      if _rc {
        gen I`m'e`n' = 0
      }
    }
  }

  * calculate the rates from the levels
  gen monthsum = 0
  foreach m of numlist `r(numlist)' { 
    forvalues n = 1/6 {
      replace monthsum = monthsum + I`m'e`n'
    }
  }
  
  foreach m of numlist `r(numlist)' { 
    forvalues n = 1/6 {
      gen i`m'e`n' = I`m'e`n' / monthsum
    }
  }
  drop monthsum I* 
  
  foreach m of numlist `r(numlist)' { 
    forvalues n = 1/6 {
      label var i`m'e`n' "employment share of industry `m' and education `n'"
    }
  }

   * generate sorting variables
  gen year = int( date /100 )
  gen month = int( (date - year*100) )
  gen qtr = int((month - 1) / 3) + 1
  order _all, seq
  order year qtr month date, first

  if `x' != 197601{
	append using ../result/indv.dta
  }
  sort year qtr month date
  saveold ../result/indv.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

gen t = tm(1976m1) + _n - 1
format t %tm
tsset t

order year qtr month date t, first
sort year qtr month date t
saveold ../result/indv.dta, replace

log close




