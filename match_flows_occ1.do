*Program: match_flows_occ1.do
*Date 5/April/2012

*************************************************************
* THIS PROGRAM CREATES TRANSITION BETWEEN 1-DIGIT OCCUPATION*
*************************************************************
set more 1

log using log_match_flows_occ1, text replace

local x = 197601
while `x' <= 201108 {

  quietly {
    if `x' != 197601 & `x' != 197801 & `x' != 198507 & `x' != 198510 & `x' != 199401 & `x' != 199506 & `x' != 199507 & `x' != 199508 & `x' != 199509 {

	  use ../basic_extract/merg`x', replace
	  
* keep only the records at least 16 years old and with no missing value on employment status and occupation in both months
	  keep if age >= 16
	  
	  gen str1 lfs0 = "E" if status0 == 1 | status0 == 2
	  replace lfs0 = "U" if status0 == 3 
	  replace lfs0 = "I" if status0 == 4 | status0 == 5 | status0 == 6 | status0 == 7
	  replace lfs0 = "U" if status0 == 4 & `x' > 198901
	  keep if lfs0 == "E" | lfs0 == "U"
	  gen str1 lfs1 = "E" if status1 == 1 | status1 == 2
	  replace lfs1 = "U" if status1 == 3 
	  replace lfs1 = "I" if status1 == 4 | status1 == 5 | status1 == 6 | status1 == 7
	  replace lfs1 = "U" if status1 == 4 & `x' > 198900
	  keep if lfs1 == "E" | lfs0 == "U"
	  
	  * give value 99 to the occupation of unemployment
	  replace mocc1990_0 = 99 if lfs0 == "U"
	  replace mocc1990_1 = 99 if lfs1 == "U"
	  
      drop if mocc1990_0 == . | mocc1990_0 ==14 | mocc1990_0 ==15 | mocc1990_1 == .| mocc1990_1 ==14 | mocc1990_1 ==15
      
      tostring mocc1990_0, gen(occ0)
      tostring mocc1990_1, gen(occ1)    
      replace occ1 = "o" + occ1
      gen str6 occ0_occ1 = occ0 + "_" + occ1
      sort occ0_occ1
      
      * sum weight for each category  
	  replace fweight0 = 0 if fweight0 == .
	  replace fweight1 = 0 if fweight1 == .
	  gen weight = (fweight0 + fweight1) / 2
	  egen double O = sum(weight), by(occ0_occ1)

	  sort occ0_occ1
	  quietly by occ0_occ1:  gen duplic = cond(_N==1,0,_n)
	  drop if duplic > 1
	  keep occ0_occ1 O
	  
	  gen date = `x'
	  reshape wide O, i(date) j(occ0_occ1) string
	  
	  * some transitions do not exist so just give them value 0
      foreach m of numlist 1/13 99 {
        foreach n of numlist 1/13 99 {
          capture confirm variable O`m'_o`n', exact
          if _rc {
            gen O`m'_o`n' = 0
          }
        }
      }
      
      * calculate the monthly sum by occupation last month
      foreach m of numlist 1/13 99 {
        gen double monthsum`m' = 0 
        foreach n of numlist 1/13 99 {
          replace monthsum`m' = monthsum`m' + O`m'_o`n'
        }
      }
      
      * calculate the rates from the levels
      foreach m of numlist 1/13 99 {
        foreach n of numlist 1/13 99 {
          gen o`m'_o`n' = O`m'_o`n' / monthsum`m'
        }
      }

      drop monthsum* O*
    }
    
    else {
	  clear
	  set obs 1
	  gen date = `x'
      foreach m of numlist 1/13 99 {
        foreach n of numlist 1/13 99 {
          gen o`m'_o`n' = 0
        }
      }
    }
  
    if `x' >= 197602 {
      append using ../result/flows_occ1.dta
    }
    
	saveold ../result/flows_occ1.dta, replace
  }

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}


sort date 
gen t = tm(1976m1) + _n - 1
format t %tm
tsset t
gen int year = int( date /100 )
gen int month = int( (date - year*100) )
gen qtr = int((month - 1) / 3) + 1

order _all, seq
order year qtr month date t, first
sort year qtr month date t

saveold ../result/flows_occ1.dta, replace


log close


