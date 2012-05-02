*Program: pctile.do
*Date 5/April/2012

**************************************************
* THIS PROGRAM GENERATES MONTHLY WAGE PERCENTILES* 
**************************************************

log using log_pctile, text replace
set more 1

local x = 1979

while `x' <= 2011 {
	
	clear
	use ../cepr/cepr_org_`x'
	* calculate the percentiles for hourly wage series w_ln_no  
	statsby, by (year month) clear: _pctile w_ln_no [aweight=orgwgt], nq(100)
	
	forvalues i = 1(1)99 {
		rename r`i' p`i'
		label var p`i' "`i' pctile of hourly wage"
	}
	
	gen date = year * 100 + month
	gen qtr = int((month - 1) / 3) + 1
	order _all, seq
	order year qtr month date, first
	
	if `x' != 1979{
		append using ../result/pctile.dta
	}
	
	sort year qtr month date
	
	saveold ../result/pctile.dta, replace
	local x = `x' + 1
	
}

gen t = tm(1979m1) + _n - 1
format t %tm
tsset t
order year qtr month date t, first
sort year qtr month date t
saveold ../result/pctile.dta, replace


*** Seasonally adjust the percentiles (ratio-to-MA method):
qui foreach XY of varlist p* {
    tssmooth ma MA_`XY' = `XY', weights(.5 1 1 1 1 1 <1> 1 1 1 1 1 .5)
    gen ratio = `XY' / MA_`XY'
    forvalues M = 1/12 { 
      egen ratio`M' = mean(ratio) if month==`M' 
    }
    forvalues M = 1/12 { 
      replace ratio = ratio`M' if month==`M' 
    }
    ameans ratio if year==1998
    local k = r(mean_g)
    replace ratio = ratio / `k'
    gen SA_`XY' = `XY' / ratio
    drop ratio*
    sort t 
}
 
keep year qtr month date t SA_*
sort year qtr month date t

saveold ../result/sa_pctile.dta, replace

log close


