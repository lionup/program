*Program: match_job.do
*Date 5/April/2012

*******************************************************************
* THIS PROGRAM GENERATES MONTHLY EMPLOYMENT SHARE FOR JOBS (RANKED BEA INDUSTRY AND 1-DIGIT OCCUPATION PAIR)* 
*******************************************************************

set more 1

log using log_match_job, text replace

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  
  * keep only the records at least 16 years old, employed, and with no missing value on job. 
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if job == . 
  sort job
  tostring job, replace

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double I = total(fweight), by (job)
  replace I = I / 1000
  if `x' > 199400 { 
	replace I = I / 100
  }
  
  sort job
  quietly by job:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep job I
  gen date = `x'
  reshape wide I, i(date) j(job) string

  gen monthsum = 0
  forvalues m = 1/165 { 
  
      *some job category do not exist, so just give them value 0
      capture confirm variable I`m'
      if _rc {
        gen I`m' = 0
      }
      
      * calculate the monthly sum       
      replace monthsum = monthsum + I`m'     
  }

  * calculate the rates from the levels
  forvalues m = 1/165 {
      gen J`m' = I`m' / monthsum
      label var J`m' "employment share of job `m'"
  }
  drop monthsum I* 
  

  if `x' != 197601{
	append using ../result/job.dta
  }
  sort date
  saveold ../result/job.dta, replace

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

order _all, seq
order year qtr month date t, first
sort year qtr month date t
saveold ../result/job.dta, replace

log close




