*Program: match_ind3_occ2_s.do
*Date 5/April/2012

*************************************************************************************************
* THIS PROGRAM GENERATES EMPLOYMENT SHARE BY EDUCATION, 3-DIGIT INDUSTRY, and 2-DIGIT OCCUPATION* 
*************************************************************************************************

set more 1

log using log_match_ind3_occ2_s, text replace

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  * keep only the records at least 16 years old, employed, and with no missing value on education, ind7090, occ1990
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | ind7090 == . | docc1990 == .

  sort ind7090 docc1990 educ6c

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double em_share = total(fweight), by (ind7090 docc1990 educ6c)
  replace em_share = em_share / 1000
  if `x' > 199400 { 
	replace em_share = em_share / 100
  }
  
  sort ind7090 docc1990 educ6c
  quietly by ind7090 docc1990 educ6c:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep ind7090 docc1990 educ6c em_share
  gen date = `x'
  egen monthsum = total(em_share)
  replace em_share = em_share/monthsum
  drop monthsum
  

   * generate sorting variables
  gen year = int( date /100 )
  gen month = int( (date - year*100) )
  gen qtr = int((month - 1) / 3) + 1
  order year qtr month date ind7090 docc1990 educ6c em_share, first

  if `x' != 197601{
	append using ../result/ind3_occ2_s.dta
  }
  sort year qtr month date ind7090 docc1990 educ6c
  saveold ../result/ind3_occ2_s.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}


log close




