*Program: copula3.do
*Date 5/April/2012

*********************************************************
* THIS PROGRAM SEASONALLY ADJUSTED THE COPULA PARAMETERS* 
*********************************************************
set more 1

use ../result/copula.dta
sort date
gen year = int( date /100 )
gen month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1
label var date ""
label var corr "correlation of t copula"
label var df "degree of freedom of t copula"

gen t = tm(1980m1) + _n - 1
format t %tm
tsset t

order year qtr month date t, first
sort year qtr month date t
saveold ../result/copula.dta, replace

qui foreach XY in corr df {
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

saveold ../result/sa_copula.dta, replace

