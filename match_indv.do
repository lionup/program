*Program: match_indv.do
*Date 5/April/2012

***********************************************************************************
* THIS PROGRAM GENERATES MONTHLY RANKED BEA INDUSTRY EMPLOYMENT SHARE BY EDUCATION* 
***********************************************************************************

set more 1

log using log_match_indv, text replace

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  
  * keep only the records at least 16 years old, employed, and with no missing value on education and vind7090 
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | vind7090 == .

  * create sorting variable "indEduc" categoried by industry and education
  tostring educ6c, gen(educ2)
  tostring vind7090, gen(ind2)
  replace educ2 = "e" + educ2
  gen str4 indEduc = ind2 + educ2
  sort indEduc

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double I = total(fweight), by (indEduc)
  replace I = I / 1000
  if `x' > 199400 { 
	replace I = I / 100
  }
  
  sort indEduc
  quietly by indEduc:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep indEduc I
  gen date = `x'
  reshape wide I, i(date) j(indEduc) string
 
  * some industry and education category do not exist so just give them value 0
  forvalues m = 1/15 { 
    forvalues n = 1/6 {
      capture confirm variable I`m'e`n'
      if _rc {
        gen I`m'e`n' = 0
      }
    }
  }

  * calculate the rates from the levels
  gen monthsum = 0
  forvalues m = 1/15 { 
    forvalues n = 1/6 {
      replace monthsum = monthsum + I`m'e`n'
    }
  }
  
  forvalues m = 1/15 { 
    forvalues n = 1/6 {
      gen i`m'e`n' = I`m'e`n' / monthsum
    }
  }
  drop monthsum I* 
  
  forvalues m = 1/15 { 
    forvalues n = 1/6 {
      label var i`m'e`n' "employment share of industry `m' and education `n'"
    }
  }

   * generate sorting variables
  gen year = int( date /100 )
  gen month = int( (date - year*100) )
  gen qtr = int((month - 1) / 3) + 1
  order _all, seq
  order year qtr month date, first

  if `x' != 197601{
	append using ../result/indv.dta
  }
  sort year qtr month date
  saveold ../result/indv.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

gen t = tm(1976m1) + _n - 1
format t %tm
tsset t

order year qtr month date t, first
sort year qtr month date t
saveold ../result/indv.dta, replace

log close




