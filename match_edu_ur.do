*Program: match_edu_ur.do
*Date 5/April/2012

*******************************************************************************************
* THIS PROGRAM GENERATES UNEMPLOYMENT RATE AND EMPLOYMENT TO POPULATION RATIO BY EDUCATION* 
*******************************************************************************************

set more 1

log using log_match_edu_ur, text replace

local x = 197601
while `x' <= 201108 {
		
  use ../basic_extract/cps`x'.dta, clear

  * keep only the records at least 16 years old and with no missing value on labor status and education 
  keep if age >= 16

  gen str1 lfs = "E" if status == 1 | status == 2
  replace lfs = "U" if status == 3 
  replace lfs = "I" if status == 4 | status == 5 | status == 6 | status == 7
  replace lfs = "U" if status == 4 & `x' > 198900
  drop if lfs == ""
  drop if educ6c == .

  * create sorting variable "lfsEduc" categoried by labor force status and education  
  tostring educ6c, gen(educ2)
  gen lfsEduc = lfs + educ2
  sort lfsEduc
  
  * sum weight for each category
  replace fweight = 0 if fweight == .
  egen double weight = sum(fweight), by(lfsEduc)
  replace weight = weight / 1000
  if `x' > 199400 { 
	replace weight = weight / 100
  }
  
  sort lfsEduc
  quietly by lfsEduc:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep lfsEduc weight
  gen date = `x'
  reshape wide weight, i(date) j(lfsEduc) string
      
  * calculate the rates from the levels
  forvalues i = 1/6 {
    gen ur`i' = weightU`i' / (weightU`i' + weightE`i') * 100
    gen epr`i' = weightE`i' / (weightU`i' + weightE`i' +weightI`i') * 100
  }
  drop weight*

  * generate sorting variables
  gen year = int( date /100 )
  gen month = int( (date - year*100) )
  gen qtr = int((month - 1) / 3) + 1
  order _all, seq
  order year qtr month date ur*, first

  if `x' != 197601{
	append using ../result/edu_ur.dta
  }
  sort year qtr month date
  saveold ../result/edu_ur.dta, replace

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
saveold ../result/edu_ur.dta, replace

log close


