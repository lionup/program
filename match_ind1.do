*Program: match_ind1.do
*Date 5/April/2012

********************************************************************************
* THIS PROGRAM GENERATES MONTHLY 1-DIGIT INDUSTRY EMPLOYMENT SHARE BY EDUCATION* 
********************************************************************************

set more 1

log using log_match_ind1, text replace

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  * keep only the records at least 16 years old, employed, and with no missing value on education and ind7090 
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | mind7090 == .

  * create sorting variable "indEduc" categoried by industry and education
  tostring educ6c, gen(educ2)
  tostring mind7090, gen(ind2)
  replace educ2 = "e" + educ2
  gen str4 indEduc = ind2 + educ2
  sort indEduc

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double I = sum(fweight), by (indEduc)
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
  numlist "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"

  foreach m of numlist `r(numlist)' { 
    forvalues n = 1/6 {
      capture confirm variable I`m'e`n'
      if _rc {
        gen I`m'e`n' = 0
      }
    }
  }

  * calculate the rates from the levels
  foreach m of numlist `r(numlist)' { 
    forvalues n = 1/6 {
      gen i`m'e`n' = I`m'e`n' / (I`m'e1 + I`m'e2 + I`m'e3 + I`m'e4 + I`m'e5 + I`m'e6)
    }
  }
  drop I*
  
  foreach m of numlist `r(numlist)' { 
    forvalues n = 1/6 {
      label var i`m'e`n' "employment share of education level `n' in industry `m'"
    }
  }

   * generate sorting variables
  gen year = int( date /100 )
  gen month = int( (date - year*100) )
  gen qtr = int((month - 1) / 3) + 1
  order _all, alpha
  order year qtr month date, first

  if `x' != 197601{
	append using ../result/ind1.dta
  }
  sort year qtr month date
  saveold ../result/ind1.dta, replace

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
saveold ../result/ind1.dta, replace

log close




