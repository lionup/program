*Program: match_flows_basic.do
*Date 5/April/2012

***************************************************************
* THIS PROGRAM CREATES E2U AND U2E AND SEASONALLY ADJUST THEM *
***************************************************************


log using log_match_flows_basic, text replace

local x = 197601
while `x' <= 201108 {

  quietly {
    if `x' != 197601 & `x' != 197801 & `x' != 198507 & `x' != 198510 & `x' != 199401 & `x' != 199506 & `x' != 199507 & `x' != 199508 & `x' != 199509 {

	  use ../basic_extract/merg`x', replace
	  
	  * keep only the records at least 16 years old and with no missing value on labor status in both months
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

	  sort lfs2
	  replace fweight0 = 0 if fweight0 == .
	  replace fweight1 = 0 if fweight1 == .
	  gen weight = (fweight0 + fweight1) / 2
	  egen double flows = sum(weight), by(lfs2)
	  replace flows = flows/1000
	  if `x' > 199400 { 
	    replace flows = flows / 100
	  }

	  sort lfs2
	  quietly by lfs2:  gen duplic = cond(_N==1,0,_n)
	  drop if duplic > 1
	  keep lfs2 flows

	  gen date = `x'
	  reshape wide flows, i(date) j(lfs2) string

	  gen flowEU = flowsEU / (flowsEE + flowsEU + flowsEI)
	  gen flowUE = flowsUE / (flowsUE + flowsUU + flowsUI)
	  drop flows*
	}

	else {
	  clear
	  set obs 1
	  gen date = `x'
	  gen flowEU = .
	  gen flowUE = .
	}

	if `x' >= 197602 {
      append using ../result/basic.dta
    }
    
	saveold ../result/basic.dta, replace
  }
 
  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

sort date
saveold ../result/basic.dta, replace


*** Take the Bleakley/Ritter data
clear 
use ../result/flows_67
keep if date <= 197601
keep date flowsEU flowsUE
order _all, alpha
save temp1, replace

clear
use ../result/basic
rename flowEU flowsEU 
rename flowUE flowsUE 
drop if date == 197601
order _all, alpha


*** Merge it with older data
append using temp1
erase temp1.dta

sort date
gen t = tm(1967m6) + _n - 1
format t %tm
tsset t
gen int year = int( date /100 )
gen int month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1

order year qtr month date t, first
sort year qtr month date t
saveold ../result/basic.dta, replace


*** Seasonally adjust the flows (ratio-to-MA method):
qui foreach XY in EU UE {
    tssmooth ma MA_`XY' = flows`XY', weights(.5 1 1 1 1 1 <1> 1 1 1 1 1 .5)
    gen ratio = flows`XY' / MA_`XY'
    forvalues M = 1/12 { 
      egen ratio`M' = mean(ratio) if month==`M' 
    }
    forvalues M = 1/12 { 
      replace ratio = ratio`M' if month==`M' 
    }
    ameans ratio if year==1998
    local k = r(mean_g)
    replace ratio = ratio / `k'
    gen SA_`XY' = flows`XY' / ratio
    replace SA_`XY' = 0 if SA_`XY'==. & flowsEU !=.
    drop ratio*
    sort t 
}
 
keep year qtr month date t SA_*
sort year qtr month date t

save ../result/sa_basic.dta, replace

log close


