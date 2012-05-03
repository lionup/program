*Program: combine.do
*Data 5/April/2012

************************************************
* THIS PROGRAM MERGE ALL THE DATA SERIES TOGETER *
************************************************
log using log_combine, text replace
set more 1

local sort year qtr month date t

*merge unemployment, vacancy, productivity, E2U, U2E, J2J, wage percentiles, copula parameters, and flows between wage deciles

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
label var SA_EU "E2U flows seasonally adjusted"
label var SA_UE "U2E flows seasonally adjusted"

merge 1:1 `sort' using ../result/sa_j2j.dta
drop _merge
sort `sort'
label var SA_J2J "J2J flows seasonally adjusted"


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



*merge the following series by education levels: unemployment, E2U, U2E, J2J
clear
use ../result/edu_ur.dta
forvalues i = 1/6 {
  label var ur`i'  "unemployment rate of education level `i'"
  label var epr`i'  "employment population ratio of education level `i'"
}

merge 1:1 `sort' using ../result/edu_basic.dta
drop _merge
sort `sort'
forvalues i = 1/6 {
  label var flowsEU`i' "E2U flows of education level `i'"
  label var flowsUE`i' "U2E flows of education level `i'"
}

merge 1:1 `sort' using ../result/edu_j2j.dta
drop _merge
sort `sort'
forvalues i = 1/6 {
  label var flowsJ2J`i' "J2J flows of education level `i'"
}


saveold ../result/edu.dta, replace


log close



