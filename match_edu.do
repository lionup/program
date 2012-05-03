*Program: match_edu.do
*Date 5/April/2012

***************************************************
* THIS PROGRAM GENERATES CONSISTENT EDUCATION CODE* 
***************************************************


set more 1

log using log_match_edu, text replace

local x = 197601
while `x' <= 201108 {

  use ../basic_extract/cps`x', clear
  
  /* 6 education categories */
  
  if `x' <= 199112 {
  gen byte educ6c = 1 if 0 <= educ & educ <= 8  /* dropouts before high school */
  replace educ6c = 2 if 9 <= educ & educ<=11 /* dropouts during high school */
  replace educ6c = 3 if educ == 12  /* high school graduates */
  replace educ6c = 4 if 13 <= educ & educ <= 15 /* didn't complete college */
  replace educ6c = 5 if educ == 16 /* completed college */
  replace educ6c = 5 if educ == 17 /* "completed 4 or 5 years college" */
  replace educ6c = 6 if 18 <= educ & educ !=.
  }
  
  if 199201 <= `x' {
  gen byte educ6c = 1 if 31 <= educ & educ <= 34
  replace educ6c = 2 if 35 <= educ & educ <= 37 /* includes "no diploma" */
  replace educ6c = 3 if 38 <= educ & educ <= 39 /* includes "no diploma" */
  replace educ6c = 4 if 40 <= educ & educ <= 42
  replace educ6c = 5 if educ == 43
  replace educ6c = 6 if 44 <= educ & educ <= 46
  }
  
  lab var educ6c "6 categroy education level"
  #delimit ;
  lab define educ6c
  1 "Dropouts before high school, completed 0~8 grade"
  2 "Dropouts during high school, completed 9~11 grade"
  3 "High school graduates, no college, completed 12 grade"
  4 "Some college, completed 13~15 grade"
  5 "College, completed 16~17 grade"
  6 "Advanced, completed 18 grade and over"
  ;
  #delimit cr
  lab val educ6c educ6c

  saveold ../basic_extract/cps`x'.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

log close


