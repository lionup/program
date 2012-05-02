*Program: transition.do
*Date 5/April/2012

***************************************************************************
* THIS PROGRAM GENERATES TRANSITION BETWEEN WAGE DECILES FROM MERGED FILES*
***************************************************************************

log using log_transition, text replace
set more 1

capture program drop transition2
program define transition2
  transition3 `1' 1  
  transition3 `1' 2
  transition3 `1' 3
  transition3 `1' 4
  transition3 `1' 5
  transition3 `1' 6
  transition3 `1' 7
  transition3 `1' 8
  transition3 `1' 9
  transition3 `1' 10
  transition3 `1' 11
  transition3 `1' 12
end

capture program drop transition3
program define transition3
  quietly {
  ** Matching is not possible due to sample redesigns between
  ** Jul to Dec 1984 4s to their 1985 8s
  ** Jan to Sep 1985 4s to their 1986 8s
  ** Jun to Dec 1994 4s to their 1995 8s
  ** Jan to Aug 1995 4s to their 1996 8s
    if (`1' == 1984 & (`2' == 7 | `2' == 8 | `2' == 9 | `2' == 10| `2' == 11| `2' == 12)) | (`1' == 1985 & (`2' == 1 | `2' == 2 | `2' == 3 | `2' == 4 | `2' == 5 | `2' == 6 |`2' == 7 | `2' == 8 | `2' == 9)) | (`1' == 1994 & (`2' == 6 | `2' == 7 | `2' == 8 | `2' == 9 | `2' == 10 | `2' == 11 | `2' == 12)) | (`1' == 1995 & (`2' == 1 | `2' == 2 | `2' == 3 | `2' == 4 | `2' == 5 | `2' == 6 |`2' == 7 | `2' == 8)) {
      clear
      set obs 1
      * the series is saved in the same month last year
	  gen year = `1' + 1
      gen month = `2'
	  gen qtr = int((month - 1) / 3) + 1
      gen date = year * 100 + month
      forvalues m = 1/10 { 
        forvalues n = 1/10 {
          gen tranD`m'D`n' = .
        }
      }
    }
    
    else {
      clear 
	  use ../result/merg`1' if month == `2' 
	  * find the wage decile for each observation
      xtile decile = w_ln_no [pweight = orgwgt], nq(10)
      xtile mdecile = mw_ln_no [pweight = morgwgt], nq(10)
      
	  * keep only the observations have wage information in both months
      keep if decile != . & mdecile != . 

      * create sorting variable "tran" categoried by transition between wage deciles	  
      tostring decile, replace
      tostring mdecile, replace
      replace decile = "D" + decile 
      replace mdecile = "D" + mdecile
      gen str6 tran = decile + mdecile 
      
      gen date = (year + 1) * 100 + month
      sort date tran

      * sum weight for each category  	  
      replace orgwgt = 0 if orgwgt == .
      replace morgwgt = 0 if morgwgt == .
      gen weight = (orgwgt+morgwgt)/2
      egen double trans = sum(weight), by(date tran)
      replace trans = trans / 1000
  	  
      sort date tran
      quietly by date tran:  gen duplic = cond(_N==1,0,_n)
      drop if duplic > 1
      keep date tran trans

      reshape wide trans, i(date) j(tran) string
      
	  * some transitions do not exist so just give them value 0
      forvalues m = 1/10 { 
        forvalues n = 1/10 {
          capture confirm variable transD`m'D`n'
          if _rc {
            gen transD`m'D`n' = 0
          }
        }
      }
      
	  * calculate the rates from the levels
      forvalues m = 1/10 { 
        forvalues n = 1/10 {
          gen tranD`m'D`n' = transD`m'D`n' / (transD`m'D1 + transD`m'D2 /*
          */ + transD`m'D3 + transD`m'D4 + transD`m'D5 + transD`m'D6 /*
          */ + transD`m'D7 + transD`m'D8 + transD`m'D9 + transD`m'D10)
        }
      }

      drop trans*
      gen year = `1' + 1
      gen month = `2'
	  gen qtr = int((month - 1) / 3) + 1
    }
    
    order year qtr month date, first

    if date >= 198002 {
      append using ../result/transition.dta
    }
    
    saveold ../result/transition.dta, replace
  }
  
  sort year qtr month date 
  saveold ../result/transition.dta, replace
end 

transition2 1979
transition2 1980 
transition2 1981 
transition2 1982 
transition2 1983
transition2 1984
transition2 1985 
transition2 1986 
transition2 1987 
transition2 1988 
transition2 1989 
transition2 1990 
transition2 1991 
transition2 1992 
transition2 1993 
transition2 1994 
transition2 1995 
transition2 1996 
transition2 1997 
transition2 1998 
transition2 1999 
transition2 2000
transition2 2001
transition2 2002
transition2 2003
transition2 2004
transition2 2005
transition2 2006
transition2 2007
transition2 2008
transition2 2009
transition2 2010

*** Seasonally adjust the wage transitions (ratio-to-MA method):
gen t = tm(1980m1) + _n - 1
format t %tm
tsset t
order year qtr month date t, first
sort year qtr month date t
saveold ../result/transition.dta, replace

qui foreach XY of varlist tran* {
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

saveold ../result/sa_transition.dta, replace


log close


