*Program: match_indv_occ1_flows_edu.do
*Date 5/April/2012

***************************************************************************************
* THIS PROGRAM CREATES TRANSITION BETWEEN 1-DIGIT INDUSTRY AND 1-DIGIT OCCUPATION PAIR*
***************************************************************************************

set more 1

log using log_match_indv_occ1_flows_edu, text replace

local x = 197602
while `x' <= 201108 {

  quietly {
    if `x' != 197801 & `x' != 198507 & `x' != 198510 & `x' != 199401 & `x' != 199506 & `x' != 199507 & `x' != 199508 & `x' != 199509 {

	  use ../basic_extract/merg`x', replace
	  
* keep only the records at least 16 years old and with no missing value on industry and occupation in both months
	  keep if age >= 16
	  keep if (status0 == 1 | status0 == 2) & (status1 == 1 | status1 == 2)
      drop if mocc1990_0 == . | vind7090_0 == . | mocc1990_1 == . | vind7090_1 == .

* create sorting variable "indOcc2" categoried by industry and occupation
      tostring mocc1990_0, gen(occ2_0)
      tostring vind7090_0, gen(ind2_0)
      tostring mocc1990_1, gen(occ2_1)
      tostring vind7090_1, gen(ind2_1)
      
      replace occ2_0 = "o" + occ2_0
      replace ind2_0 = "i" + ind2_0
      gen str6 indOcc0 = ind2_0 + occ2_0
      
      replace occ2_1 = "o" + occ2_1
      replace ind2_1 = "i" + ind2_1
      gen str6 indOcc1 = ind2_1 + occ2_1
      
      gen str13 indOcc2 = indOcc0 + "_" + indOcc1
      
* flows conditional on the eduction category of last month
	  drop if educ6c0 == .  
	  tostring educ6c0, gen(educ2)

      sort indOcc2 educ2

	  replace fweight0 = 0 if fweight0 == .
	  replace fweight1 = 0 if fweight1 == .
	  gen weight = (fweight0 + fweight1) / 2
	  egen double E = sum(weight), by(indOcc2 educ2)

	  sort indOcc2 educ2
	  quietly by indOcc2 educ2:  gen duplic = cond(_N==1,0,_n)
	  drop if duplic > 1
	  keep indOcc2 educ2 E
	  
	  reshape wide E, i(indOcc2) j(educ2) string

	  gen date = `x'
	  
	  * calculate the rates from the levels
      gen double rowsum = 0
      forvalues n = 1/6 {
        replace E`n' = 0 if E`n'== .
        replace rowsum = rowsum + E`n'
      }
      
      forvalues n = 1/6 {
        replace E`n' = E`n'/rowsum
      } 
      drop rowsum
      
      if `x' >= 197603 {
        append using ../result/indv_occ1_flows_edu.dta
      }
      saveold ../result/indv_occ1_flows_edu.dta, replace
	}	
  }
 
  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}


sort date indOcc2
gen int year = int( date /100 )
gen int month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1

order year qtr month date indOcc2, first
sort year qtr month date indOcc2
saveold ../result/indv_occ1_flows_edu.dta, replace


log close


