*Program: match_edu_flows_job.do
*Date 5/April/2012

**************************************************************
* THIS PROGRAM CREATES TRANSITION RATE BETWEEN JOBS (RANKED BEA INDUSTRY AND 1-DIGIT OCCUPATION PAIR) BY EDUCATION GROUP *
**************************************************************
set more 1

log using log_match_edu_flows_job, text replace

set maxvar 32767

local x = 197601
while `x' <= 201108 {

  quietly {
    if `x' != 197601 & `x' != 197801 & `x' != 198507 & `x' != 198510 & `x' != 199401 & `x' != 199506 & `x' != 199507 & `x' != 199508 & `x' != 199509 {

	  use ../basic_extract/merg`x', replace
	  
* keep only the records at least 16 years old, with no missing value on employment status and job in both months, and with no missing value on education in last month
	  keep if age >= 16
	  
	  gen str1 lfs0 = "E" if status0 == 1 | status0 == 2
	  replace lfs0 = "U" if status0 == 3 
	  replace lfs0 = "I" if status0 == 4 | status0 == 5 | status0 == 6 | status0 == 7
	  replace lfs0 = "U" if status0 == 4 & `x' > 198901
	  keep if lfs0 == "E" | lfs0 == "U"
	  gen str1 lfs1 = "E" if status1 == 1 | status1 == 2
	  replace lfs1 = "U" if status1 == 3 
	  replace lfs1 = "I" if status1 == 4 | status1 == 5 | status1 == 6 | status1 == 7
	  replace lfs1 = "U" if status1 == 4 & `x' > 198900
	  keep if lfs1 == "E" | lfs1 == "U"
	  
	  * give value 0 to the job of unemployment
	  replace job0 = 0 if lfs0 == "U"
	  replace job1 = 0 if lfs1 == "U"
	  
      drop if job0 == . | job1 == . | educ6c0 == .      
      rename educ6c0 edu
      tostring job0, gen(J0)
      tostring job1, gen(J1)     
      replace J1 = "J" + J1
      gen str7 job0_job1 = J0 + J1
      sort job0_job1 edu
      
      * sum weight for each category  
	  replace fweight0 = 0 if fweight0 == .
	  replace fweight1 = 0 if fweight1 == .
	  gen weight = (fweight0 + fweight1) / 2
	  egen double I = sum(weight), by(job0_job1 edu)

	  sort job0_job1 edu
	  quietly by job0_job1 edu:  gen duplic = cond(_N==1,0,_n)
	  drop if duplic > 1
	  keep job0_job1 edu I
	  

	  reshape wide I, i(edu) j(job0_job1) string
	  gen date = `x'
      
      forvalues m = 0/165 {
        gen double monthsum`m' = 0     
        forvalues n = 0/165 {
        
          * some transitions do not exist, so give them value 0       
          capture confirm variable I`m'J`n', exact
          if _rc {
            gen I`m'J`n' = 0
          }
          
          * calculate the monthly sum by job last month
          replace I`m'J`n' = 0 if I`m'J`n' == . 
          replace monthsum`m' = monthsum`m' + I`m'J`n'
        }
        
        * calculate the rates from the levels
        forvalues n = 0/165 {
          gen J`m'J`n' = I`m'J`n' / monthsum`m'
          replace J`m'J`n' = 0 if J`m'J`n' == . 
          label var J`m'J`n' "transition rate of job `m' to job `n'"
        }
        
        drop monthsum`m' I`m'J*
      }

    }
    
    else {
	  clear
	  set obs 1
	  gen date = `x'
	  gen edu = 1
	  forvalues i = 2/6 {
        set obs `=_N + 1'
        replace date = `x' in L
        replace edu = `i' in L
      }
      
      forvalues m = 0/165 {
        forvalues n = 0/165 {
          gen J`m'J`n' = 0
        }
      }
    }
  
    if `x' >= 197602 {
      append using ../result/edu_flows_job.dta
    }
    
	saveold ../result/edu_flows_job.dta, replace
  }

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}


sort date edu
gen int year = int( date /100 )
gen int month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1

order _all, seq
order year qtr month date edu, first
sort year qtr month date edu

compress

saveold ../result/edu_flows_job.dta, replace


log close


