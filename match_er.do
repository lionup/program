*Program: match_er.do
*Date 5/April/2012

*****************************************
**Generates the labor force share of workers employed in jobs (ranked BEA industry and 1-digit occupation pair) by all workers; and also seperately by education group
*****************************************

set more 1

log using log_match_er, text replace

local x = 197601
while `x' <= 201108 {
		
  use ../basic_extract/cps`x'.dta, clear

  * keep only the records at least 16 years old and with no missing value on labor status
  keep if age >= 16

  gen str1 lfs = "E" if status == 1 | status == 2
  replace lfs = "U" if status == 3 
  replace lfs = "I" if status == 4 | status == 5 | status == 6 | status == 7
  replace lfs = "U" if status == 4 & `x' > 198900
  keep if lfs == "E" | lfs == "U" 
  replace lfs = "U" if job == .
  sort lfs
  
  * sum weight for each category
  replace fweight = 0 if fweight == .
  egen double weight = sum(fweight), by(lfs)
  replace weight = weight / 1000
  if `x' > 199400 { 
	replace weight = weight / 100
  }
  
  sort lfs
  quietly by lfs:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep lfs weight
  gen date = `x'
  reshape wide weight, i(date) j(lfs) string
      
  * calculate the rates from the levels
  gen er = weightE / (weightU + weightE)
  drop weight*


  if `x' != 197601{
	append using ../result/er.dta
  }
  sort date
  saveold ../result/er.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}
  
  
* generate sorting variables
gen year = int( date /100 )
gen month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1
gen t = tm(1976m1) + _n - 1
format t %tm
tsset t

order year qtr month date t, first
sort year qtr month date t
saveold ../result/er.dta, replace

***********************************************************************

*BY EDUCATION GROUP* 


local x = 197601
while `x' <= 201108 {
		
  use ../basic_extract/cps`x'.dta, clear

  * keep only the records at least 16 years old and with no missing value on labor status and education 
  keep if age >= 16

  gen str1 lfs = "E" if status == 1 | status == 2
  replace lfs = "U" if status == 3 
  replace lfs = "I" if status == 4 | status == 5 | status == 6 | status == 7
  replace lfs = "U" if status == 4 & `x' > 198900
  keep if lfs == "E" | lfs == "U" 
  replace lfs = "U" if job == .
  drop if educ6c == .
  rename educ6c edu
  sort lfs edu
  
  * sum weight for each category
  replace fweight = 0 if fweight == .
  egen double weight = sum(fweight), by(lfs edu)
  replace weight = weight / 1000
  if `x' > 199400 { 
	replace weight = weight / 100
  }
  
  sort lfs edu
  quietly by lfs edu:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep lfs edu weight

  reshape wide weight, i(edu) j(lfs) string
  gen date = `x' 
  * calculate the rates from the levels
  gen er = weightE / (weightU + weightE)
  drop weight*


  if `x' != 197601{
	append using ../result/edu_er.dta
  }
  sort date edu
  saveold ../result/edu_er.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}
  
  
* generate sorting variables
gen year = int( date /100 )
gen month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1

order year qtr month date edu, first
sort year qtr month date edu
saveold ../result/edu_er.dta, replace

log close

