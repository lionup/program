*Program: match_edu_basic.do
*Date 5/April/2012

***************************************************************
* THIS PROGRAM GENERATES MONTHLY E2U AND U2E RATE BY EDUCATION* 
***************************************************************

set more 1

log using log_match_edu_basic, text replace

local x = 197601
while `x' <= 201108 {
  quietly {
    if `x' != 197601 & `x' != 197801 & `x' != 198507 & `x' != 198510 & `x' != 199401 & `x' != 199506 & `x' != 199507 & `x' != 199508 & `x' != 199509 {
	  use ../basic_extract/merg`x', replace
	  
	  * keep only the records at least 16 years old and with no missing value on labor status in both months and eduction on first month
	  keep if age >= 16

	  gen str1 lfs0 = "E" if status0 == 1 | status0 == 2
	  replace lfs0 = "U" if status0 == 3 
	  replace lfs0 = "I" if status0 == 4 | status0 == 5 | status0 == 6 | status0 == 7
	  replace lfs0 = "U" if status0 == 4 & `x' > 198901
	  drop if lfs0 == ""
	  gen str1 lfs1 = "E" if status1 == 1 | status1 == 2
	  replace lfs1 = "U" if status1 == 3 
	  replace lfs1 = "I" if status1 == 4 | status1 == 5 | status1 == 6 | status1 == 7
	  replace lfs1 = "U" if status1 == 4 & `x' > 198900
	  drop if lfs1 == ""

	  gen str2 lfs2 = lfs0 + lfs1
      
	  * flows conditional on the eduction category of last month
	  drop if educ6c0 == .  
	  tostring educ6c0, gen(educ2)

      gen lfsEduc = lfs2 + educ2
	  sort lfsEduc

	  replace fweight0 = 0 if fweight0 == .
	  replace fweight1 = 0 if fweight1 == .
	  gen weight = (fweight0 + fweight1) / 2
	  egen double flows = sum(weight), by(lfsEduc)
	  replace flows = flows/1000
	  if `x' > 199400 { 
	    replace flows = flows / 100
	  }

	  sort lfsEduc
	  quietly by lfsEduc:  gen duplic = cond(_N==1,0,_n)
	  drop if duplic > 1
	  keep lfsEduc flows

	  gen date = `x'
	  reshape wide flows, i(date) j(lfsEduc) string
      
	  forvalues i = 1/6 {
	    gen flowEU`i' = flowsEU`i' / (flowsEE`i' + flowsEU`i' + flowsEI`i')
	    gen flowUE`i' = flowsUE`i' / (flowsUE`i' + flowsUU`i' + flowsUI`i')
	  }
	  drop flows*
	}

	else {
	  clear
	  set obs 1
	  gen date = `x'
	  forvalues i = 1/6 {
	    gen flowEU`i' = .
	    gen flowUE`i' = .
	  }
	}

	if `x' >= 197602 {
      append using ../result/edu_basic.dta
    }
    
	saveold ../result/edu_basic.dta, replace
  }
 
  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

forvalues i = 1/6 {
  rename flowEU`i' flowsEU`i' 
  rename flowUE`i' flowsUE`i'
}

order _all, alpha

sort date
gen t = tm(1976m1) + _n - 1
format t %tm
tsset t
gen int year = int( date /100 )
gen int month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1

order year qtr month date t, first
sort year qtr month date t
saveold ../result/basic_edu.dta, replace


log close


  

