*Program: matchorg.do
*Date 5/April/2012

*********************************************************************
* THIS PROGRAM MERGES TWO CONSECUTIVE CEPR CPS ORG UNIFORM EXTRACTS *
*********************************************************************

log using log_matchorg, text replace
set more 1

capture program drop match2
program define match2
  local nextyear = `1' + 1

* STEP 1:  Load data for individuals in time t+1
  clear
  display "Reading in t+1 Data"
  use ../cepr/cepr_org_`nextyear' if minsamp==8
  drop minsamp
  label drop _all
  
  * Rename t+1 variables
  foreach x of varlist _all {
	rename `x' m`x'
  } 

  *mym is the year and month of the file where matching observations would be
  gen int mym = `nextyear' * 10 + 8
  label var mym "Match year and month-in-sample"
  * Sort and save t+1 data
  display "Sort vars"
  rename mmonth month
  rename mhhid hhid
  rename mhhnum hhnum
  rename mlineno lineno
  rename mstate state
  local sort_stem mym month state hhid hhnum 
  if (`nextyear' <= 2006) {
	local sort `sort_stem' lineno
  }
  if (`nextyear' >= 2007 & `nextyear' <= 2011  ) {
	rename mhhid2 hhid2
	tostring hhid2, replace
	local sort `sort_stem' lineno hhid2 
  }
  display "sort `sort'"
  sort `sort'
  display "Generate id"
  gen obsno2 = _n
  saveold match`nextyear'8.dta, replace

  clear


* STEP 2:  Load data for individuals in time t
  display "Reading in individual data"
  use ../cepr/cepr_org_`1' if minsamp==4

  *mym is the year and month of the file where matching observations would be
  display "Generate mym for minsamp 4"
  gen int mym = `1' * 10  + 18
  label var mym "Match year and month-in-sample"
  * Sort t data
  display "Sort vars"
  if (`1' <= 2005) {
	local sort `sort_stem' lineno
  }
  if (`1' >= 2006 & `1' <= 2011  ) {
    tostring hhid2, replace
	local sort `sort_stem' lineno hhid2 
  }
  display "sort `sort'"
  sort `sort'
  display "Generate id"
  gen obsno = _n


* STEP 3:  Merge t+1 data to t data
  display "Household/family-level match"
  ** Matching is not possible due to sample redesigns between
  ** Jul to Dec 1984 4s to their 1985 8s
  ** Jan to Sep 1985 4s to their 1986 8s
  ** Jun to Dec 1994 4s to their 1995 8s
  ** Jan to Aug 1995 4s to their 1996 8s
  **( 79:8s don't have matches )
  ** No matches yet for most recent year's minsamp 4s
  
  capture describe
  local obs_pre = r(N)
    
  display "Merging `1' minsamp 4 households to minsamp 8 using match`nextyear'8.dta "
  merge `sort' using match`nextyear'8.dta 
  erase match`nextyear'8.dta 


* STEP 4:  Define merge quality variables
** Create dummy variables to verify that sex, race, and age match.
** A value of 1 indicates a match.  Zero means no match.
  gen byte sexdif  = female  == mfemale
  gen byte racedif = wbho == mwbho
  gen byte mage_age= mage-age
  gen byte nragedif = (mage_age>=-1 & mage_age<=3)
  gen byte ragedif = (mage_age>=0 & mage_age<=2)
  gen byte edudif = meduc-educ
  gen byte redudif = (edudif==0 | edudif==1)
  gen byte nredudif = (edudif==-1 | edudif==0 | edudif==1 | edudif==2)

* Deal with duplicate observations

  qui do multobs
  drop _merge 

  gen byte match=0
  replace match=1 if sexdif+racedif+nragedif==3
  
  * keep only the matched observations
  keep if match == 1
  drop match
  
  capture describe
  local obs_post = r(N)
  display `"`obs_pre' observations prior to match"' 
  display `"`obs_post' observations after match"'
  
  *save the obs_pre and obs_post to file matchorg_match.txt
  if (`1' == 1979) {
    file open mr using "../result/org_match_rate.txt", write replace
    file write mr "year" _tab "obs_pre" _tab "obs_post" _n
    file write mr %8.0f `"`1'"' _tab %8.0f `"`obs_pre'"' _tab %8.0f `"`obs_post'"' _n
    file close mr
  }
  else {
    file open mr using "../result/org_match_rate.txt", write append
    file write mr %8.0f `"`1'"' _tab %8.0f `"`obs_pre'"' _tab %8.0f `"`obs_post'"' _n
    file close mr
  }
  
  sort `sort' 
  saveold ../basic_extract/org_merg`1', replace
  clear
end 

match2 1979
match2 1980 
match2 1981 
match2 1982 
match2 1983
match2 1984
match2 1985 
match2 1986 
match2 1987 
match2 1988 
match2 1989 
match2 1990 
match2 1991 
match2 1992 
match2 1993 
match2 1994 
match2 1995 
match2 1996 
match2 1997 
match2 1998 
match2 1999 
match2 2000
match2 2001
match2 2002
match2 2003
match2 2004
match2 2005
match2 2006
match2 2007
match2 2008
match2 2009
match2 2010

log close


