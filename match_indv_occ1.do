*Program: match_indv_occ1.do
*Date 5/April/2012

****************************************************************************************************
* THIS PROGRAM GENERATES EMPLOYMENT SHARE BY EDUCATION, RANKED BEA INDUSTRY, AND 1-DIGIT OCCUPATION* 
****************************************************************************************************

set more 1

log using log_match_indv_occ1, text replace

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  * keep only the records at least 16 years old, employed, and with no missing value on education, vind7090, occ1990
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | vind7090 == . | mocc1990 == .

  sort vind7090 mocc1990 educ6c

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double em_share = total(fweight), by (vind7090 mocc1990 educ6c)
  
  sort vind7090 mocc1990 educ6c
  quietly by vind7090 mocc1990 educ6c:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep vind7090 mocc1990 educ6c em_share
  gen date = `x'
  egen double monthsum = total(em_share)
  replace em_share = em_share/monthsum
  drop monthsum
  
  * some industry, occupation, and education category do not exist so just give them value 0
  qui forvalues i = 1/20 {
        forvalues j = 1/13 {
          forvalues m = 1/6 {
            count if vind7090 == `i' & mocc1990 == `j' & educ6c == `m'
            if r(N) == 0 {
                set obs `=_N + 1'
                replace date = `x'
			    replace vind7090 = `i' in L
			    replace mocc1990 = `j' in L
			    replace educ6c = `m' in L
                replace em_share = 0 in L
            }
          }
        }
      }
  sort vind7090 mocc1990 educ6c
  

   * generate sorting variables
  gen year = int( date /100 )
  gen month = int( (date - year*100) )
  gen qtr = int((month - 1) / 3) + 1
  order year qtr month date vind7090 mocc1990 educ6c em_share, first

  if `x' != 197601{
	append using ../result/indv_occ1.dta
  }
  sort year qtr month date vind7090 mocc1990 educ6c
  saveold ../result/indv_occ1.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

compress
saveold ../result/indv_occ1.dta, replace

log close




