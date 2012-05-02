*Program: match_flows_j2j.do
*Date 5/April/2012

*****************************************************
* THIS PROGRAM CREATES J2J AND SEASONALLY ADJUST IT *
*****************************************************

log using log_match_flows_j2j, text replace

local x = 199401
while `x' <= 201108 {
 quietly{
  if `x' != 199401 &`x' != 199506 & `x' != 199507 & `x' != 199508 & `x' != 199509 {

	use ../basic_extract/merg`x', replace

    * keep only the records at least 16 years old and with no missing value on labor status and same job question in both months
	keep if age >= 16

	gen str1 lfs0 = "E" if status0 == 1 | status0 == 2
	replace lfs0 = "U" if status0 == 3 | status0 == 4 | status0 == 5 | status0 == 6 | status0 == 7
	drop if lfs0 == ""
	gen str1 lfs1 = "E" if status1 == 1 | status1 == 2
	replace lfs1 = "U" if status1 == 3 | status1 == 4 | status1 == 5 | status1 == 6 | status1 == 7
	drop if lfs1 == ""

	gen str2 lfs2 = lfs0 + lfs1
	
	sort lfs2
	keep if lfs2 == "EE" & (samejob1 == 1 | samejob1 == 2)
	
	replace lfs2 = cond(samejob1 == 1,"JStay","J2J")

	replace fweight0 = 0 if fweight0 == .
	replace fweight1 = 0 if fweight1 == .
	gen weight = (fweight0 + fweight1) / 2

	egen double flows = sum(weight), by(lfs2)
	replace flows = flows / 100000

	sort lfs2
	quietly by lfs2:  gen duplic = cond(_N == 1,0,_n)
	drop if duplic > 1
	keep lfs2 flows

	gen date = `x'
	reshape wide flows, i(date) j(lfs2) string

	gen flowJ2J = flowsJ2J /(flowsJStay + flowsJ2J)
	drop flows*
  }

  else {
	clear
	set obs 1
	gen date = `x'
	gen flowJ2J = .
  }

  if `x' >= 199402 {
    append using ../result/j2j.dta
  }
    
  saveold ../result/j2j.dta, replace
 }
 
 local x = `x' + 1
 if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
 }
}

rename flowJ2J flowsJ2J 

sort date
gen t = tm(1994m1) + _n - 1
format t %tm
gen int year = int( date /100 )
gen int month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1
tsset t

order year qtr month date t, first
sort year qtr month date t
saveold ../result/j2j, replace



*** Seasonally adjust the flows (ratio-to-MA method):
qui foreach XY in J2J {
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
    drop ratio*
    sort t 
}
 
keep year qtr month date t SA_*
sort year qtr month date t

save ../result/sa_j2j.dta, replace

log close

