*Program: match_ind2_occ2.do
*Date 5/April/2012

*************************************************************************************************
* THIS PROGRAM GENERATES EMPLOYMENT SHARE BY EDUCATION, 2-DIGIT INDUSTRY, and 2-DIGIT OCCUPATION* 
*************************************************************************************************

set more 1

log using log_match_ind2_occ2, text replace

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  * keep only the records at least 16 years old, employed, and with no missing value on education, ind7090, occ1990
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | dind7090 == . | docc1990 == .

  sort dind7090 docc1990 educ6c

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double em_share = total(fweight), by (dind7090 docc1990 educ6c)
  replace em_share = em_share / 1000
  if `x' > 199400 { 
	replace em_share = em_share / 100
  }
  
  sort dind7090 docc1990 educ6c
  quietly by dind7090 docc1990 educ6c:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep dind7090 docc1990 educ6c em_share
  gen date = `x'
  egen monthsum = total(em_share)
  replace em_share = em_share/monthsum
  drop monthsum
  
* some industry, occupation, and education category do not exist so just give them value 0
  local ind_num "1 2 3 4 5 6 7 8 9 10 11 12 13 15 16 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 50"
  
  qui foreach i of numlist `ind_num' { 
        forvalues j = 1/43 {
          forvalues m = 1/6 {
            count if dind7090 == `i' & docc1990 == `j' & educ6c == `m'
            if r(N) == 0 {
                set obs `=_N + 1'
                replace date = `x'
			    replace dind7090 = `i' in L
			    replace docc1990 = `j' in L
			    replace educ6c = `m' in L
                replace em_share = 0 in L
            }
          }
        }
      }
  sort dind7090 docc1990 educ6c
  

   * generate sorting variables
  gen year = int( date /100 )
  gen month = int( (date - year*100) )
  gen qtr = int((month - 1) / 3) + 1
  order year qtr month date dind7090 docc1990 educ6c em_share, first

  if `x' != 197601{
	append using ../result/ind2_occ2.dta
  }
  sort year qtr month date dind7090 docc1990 educ6c
  saveold ../result/ind2_occ2.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}


log close




