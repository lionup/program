*Program: match_indv_graph.do
*Date 5/April/2012


set more 1
log using log_match_indv_graph, text replace


local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  
  *rank the industry by value added per worker
  sort vind7090
  merge vind7090 using ../result/va_ind_rank_merge.dta
  drop _merge
  
  * keep only the records at least 16 years old, employed, and with no missing value on education and mean_rank 
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | mean_rank == .


  sort mean_rank educ6c

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double I`x' = total(fweight), by (mean_rank educ6c)
  replace I`x' = I`x' / 1000
  if `x' > 199400 { 
	replace I`x' = I`x' / 100
  }
  
  sort mean_rank educ6c
  quietly by mean_rank educ6c:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep mean_rank educ6c I`x'
  
  egen monthsum = total(I`x')
  replace I`x'= I`x'/monthsum
  drop monthsum
  
  twoway contour I`x' mean_rank educ6c, levels(20) clegend(off) 
  graph export ../graph/indv/`x'.png, replace
    
  sort mean_rank educ6c
 
  if `x' != 197601{
	merge mean_rank educ6c using ../result/indv_graph.dta
	drop _merge
  }
  sort mean_rank educ6c
  
  saveold ../result/indv_graph.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

log close


