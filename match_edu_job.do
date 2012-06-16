*Program: match_edu_job.do
*Date 5/April/2012

*******************************************************************
* THIS PROGRAM GENERATES MONTHLY EMPLOYMENT SHARE FOR JOBS (RANKED BEA INDUSTRY AND 1-DIGIT OCCUPATION PAIR) BY EDUCATION GROUP* 
*******************************************************************

set more 1

log using log_match_edu_job, text replace

local x = 197601
while `x' <= 201108  {
  use ../basic_extract/cps`x'.dta, clear
  
  * keep only the records at least 16 years old, employed, and with no missing value on job and education. 
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if job == . | educ6c == . 
  tostring job, replace
  rename educ6c edu
  sort job edu

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double I = total(fweight), by (job edu)
  replace I = I / 1000
  if `x' > 199400 { 
	replace I = I / 100
  }
  
  sort job edu
  quietly by job edu:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep job edu I
  reshape wide I, i(edu) j(job) string

  gen date = `x'
  gen monthsum = 0
  forvalues m = 1/165 { 
  
      *some job category do not exist, so just give them value 0
      capture confirm variable I`m'
      if _rc {
        gen I`m' = 0
      }
      
      * calculate the monthly sum      
      replace I`m' = 0 if I`m' == . 
      replace monthsum = monthsum + I`m'     
  }

  * calculate the rates from the levels
  forvalues m = 1/165 {
      gen J`m' = I`m' / monthsum
      label var J`m' "employment share of job `m'"
  }
  drop monthsum I* 
  

  if `x' != 197601{
	append using ../result/edu_job.dta
  }
  sort date edu
  saveold ../result/edu_job.dta, replace

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

order _all, seq
order year qtr month date edu, first
sort year qtr month date edu
saveold ../result/edu_job.dta, replace

log close




