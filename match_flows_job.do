*Program: match_flows_job.do
*Date 5/April/2012

**************************************************************
* THIS PROGRAM CREATES TRANSITION RATE BETWEEN JOBS (RANKED BEA INDUSTRY AND 1-DIGIT OCCUPATION PAIR)*
**************************************************************
set more 1

log using log_match_flows_job, text replace

set maxvar 32767

local x = 197601
while `x' <= 201108 {

  quietly {
    if `x' != 197601 & `x' != 197801 & `x' != 198507 & `x' != 198510 & `x' != 199401 & `x' != 199506 & `x' != 199507 & `x' != 199508 & `x' != 199509 {

	  use ../basic_extract/merg`x', replace
	  
* keep only the records at least 16 years old and with no missing value on employment status and job in both months
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
	  
	  * give value 0 job of unemployment
	  replace job0 = 0 if lfs0 == "U"
	  replace job1 = 0 if lfs1 == "U"
	  
      drop if job0 == . | job1 == .
      
      tostring job0, gen(J0)
      tostring job1, gen(J1)    
      replace J1 = "J" + J1
      gen str7 job0_job1 = J0 + J1
      sort job0_job1
      
      * sum weight for each category  
	  replace fweight0 = 0 if fweight0 == .
	  replace fweight1 = 0 if fweight1 == .
	  gen weight = (fweight0 + fweight1) / 2
	  egen double I = sum(weight), by(job0_job1)

	  sort job0_job1
	  quietly by job0_job1:  gen duplic = cond(_N==1,0,_n)
	  drop if duplic > 1
	  keep job0_job1 I
	  
	  gen date = `x'
	  reshape wide I, i(date) j(job0_job1) string
	  
      forvalues m = 0/165 {
        gen double monthsum`m' = 0     
        forvalues n = 0/165 {
        
          * some transitions do not exist, so give them value 0       
          capture confirm variable I`m'J`n', exact
          if _rc {
            gen I`m'J`n' = 0
          }
          
          * calculate the monthly sum by job last month
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
      forvalues m = 0/165 {
        forvalues n = 0/165 {
          gen J`m'J`n' = 0
        }
      }
    }
  
    if `x' >= 197602 {
      append using ../result/flows_job.dta
    }
    
	saveold ../result/flows_job.dta, replace
  }

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}


sort date 
gen t = tm(1976m1) + _n - 1
format t %tm
tsset t
gen int year = int( date /100 )
gen int month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1

order _all, seq
order year qtr month date t, first
sort year qtr month date t

compress

saveold ../result/flows_job.dta, replace


log close


