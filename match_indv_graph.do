*Program: match_indv_graph.do
*Date 5/April/2012

*********************************************************************************************
* THIS PROGRAM GENERATES MONTHLY RANKED BEA INDUSTRY EMPLOYMENT SHARE BY EDUCATION FOR GRAPH* 
*********************************************************************************************

set more 1
log using log_match_indv_graph, text replace


local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
 
  * keep only the records at least 16 years old, employed, and with no missing value on education and vind7090 
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | vind7090 == .


  sort vind7090 educ6c

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double I`x' = total(fweight), by (vind7090 educ6c)
  replace I`x' = I`x' / 1000
  if `x' > 199400 { 
	replace I`x' = I`x' / 100
  }
  
  sort vind7090 educ6c
  quietly by vind7090 educ6c:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep vind7090 educ6c I`x'
  
  egen monthsum = total(I`x')
  replace I`x'= I`x'/monthsum
  drop monthsum
  
  twoway contour I`x' vind7090 educ6c, levels(20) clegend(off) 
  graph export ../graph/indv/`x'.png, replace
    
  sort vind7090 educ6c
 
  if `x' != 197601{
	merge vind7090 educ6c using ../result/indv_graph.dta
	drop _merge
  }
  sort vind7090 educ6c
  
  saveold ../result/indv_graph.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

log close


