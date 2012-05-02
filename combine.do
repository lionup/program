*Program: combine.do
*Data 5/April/2012

************************************************
* THIS PROGRAM MERGE ALL THE DATA SERIES TOGETER *
************************************************
log using log_combine, text replace
set more 1

local sort year qtr month date t

use ../BLS/unemployment_raw_m.dta

merge 1:1 `sort' using ../BLS/prod_raw_q.dta
drop _merge
sort `sort'

merge 1:1 `sort' using ../BLS/jolts_raw_m.dta
drop _merge
sort `sort'

merge 1:1 `sort' using ../BLS/help_raw_m.dta
drop _merge
sort `sort'

merge 1:1 `sort' using ../BLS/help_online_raw_m.dta
drop _merge
sort `sort'

merge 1:1 `sort' using ../result/sa_basic.dta
drop _merge
sort `sort'
label var SA_EU "montly E2U flows seasonally adjusted"
label var SA_UE "montly U2E flows seasonally adjusted"

merge 1:1 `sort' using ../result/sa_j2j.dta
drop _merge
sort `sort'
label var SA_J2J "montly J2J flows seasonally adjusted"


merge 1:1 `sort' using ../result/sa_copula.dta
drop _merge
sort `sort'
label var SA_corr "correlation of t-copula of this month and the same month last year seasonally adjusted"
label var SA_df "degree of freedom of t-copula of this month and the same month last year seasonally adjusted"


merge 1:1 `sort' using ../result/sa_pctile.dta
drop _merge
sort `sort'
forvalues i = 1(1)99 {
  label var SA_p`i' "`i' pctile of hourly wage seasonally adjusted"
}

merge 1:1 `sort' using ../result/sa_transition.dta
drop _merge
sort `sort'
forvalues m = 1/10 { 
  forvalues n = 1/10 {
    label var SA_tranD`m'D`n' "flow to decile`n' of this month from decile`m' of the same month last year (SA)"
  }
}

saveold ../result/final.dta, replace

log close



