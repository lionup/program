*Program: match_merge.do
*Date 5/April/2012

***************************************************************
* THIS PROGRAM MATCHES CONSECUTIVE MONTHLY CPS BASIC EXTRACTS *
***************************************************************

log using log_match_merge, text replace

local first=197601
while `first' <=201107 {

local second = `first' + 1
if (`first'-12)/100 == int((`first'-12)/100) {
   local second = `first' + 89
   }
   
if `second' != 197801 & `second' != 198507 & `second' != 198510 & `second' != 199401 & `second' != 199506 & `second' != 199507 & `second' != 199508 & `second' != 199509 {

clear
use ../basic_extract/cps`second'.dta
drop if mis==1 | mis == 5

rename mis mis1
rename educ educ1
rename educ6c educ6c1
rename status status1
rename fweight fweight1
rename mar mar1
rename dur dur1
rename ind ind1
rename ind7090 ind7090_1
rename dind7090 dind7090_1
rename mind7090 mind7090_1
rename vind7090 vind7090_1
rename occu occu1
rename occ1990 occ1990_1
rename docc1990 docc1990_1
rename mocc1990 mocc1990_1
rename lk lk1
rename class class1

if `second' > 199400 {
rename samejob samejob1 
  }
gen mis0 = mis1 - 1

* sort records
if `second' < 199400 {
  local hh hh
  }
if `second' > 199400 & `second' < 200405 {
  local hh hh hrsersuf  
  }
if `second' == 200405 {
  local hh hh
  }
if `second' > 200405 {
  local hh hh hhid2  
  }

sort `hh' line race sex age mis0
quietly by `hh' line race sex age mis0: gen dup = cond(_N==1,0,_n)
    *** Flag any duplicate records so none of them can be matched.
sort `hh' line race sex age mis0 dup
save `second'

clear
use ../basic_extract/cps`first'
drop if mis == 4 | mis == 8

capture describe
local obs_pre = r(N)

rename mis mis0
rename educ educ0
rename educ6c educ6c0
rename status status0
rename fweight fweight0
rename mar mar0
rename dur dur0
rename ind ind0
rename ind7090 ind7090_0
rename dind7090 dind7090_0
rename mind7090 mind7090_0
rename vind7090 vind7090_0
rename occu occu0
rename occ1990 occ1990_0
rename docc1990 docc1990_0
rename mocc1990 mocc1990_0

rename lk lk0
rename class class0

if `first' > 199400 {
rename samejob samejob0 
  }

if `first' < 199400 {
  local hh hh
  }
if `first' > 199400 & `first' < 200404 {
  local hh hh hrsersuf  
  }
if `first' == 200404 {
  local hh hh
  }
if `first' > 200404 {
  local hh hh hhid2  
  }

sort `hh' line race sex age mis0
quietly by `hh' line race sex age mis0: gen dup = cond(_N==1,0,0-_n)
   *** Flag any duplicate records with a negative number so none of them can be matched
   
sort `hh' line race sex age mis0 dup
merge `hh' line race sex age mis0 dup using `second'
rename _merge _merge1
saveold ../basic_extract/merg`second'.dta
   *** This creates a record of all individuals, matched if they agree on hh, line, race, sex, and exactly on age. And also neither record can be duplicated.
   
erase `second'.dta
keep if _merge1 == 2
replace age = age - 1
sort `hh' line race sex age mis0 dup
save touse

clear
use ../basic_extract/merg`second'
keep if _merge1 == 1
sort `hh' line race sex age mis0 dup
merge `hh' line race sex age mis0 dup using touse, update
drop if _merge == 1 | _merge == 2
   *** So now we have a data set with individuals whose age was off by one year
   *** We expect _merge == 5 because of the mismatched values llind, z, lweight
   
erase touse.dta
append using ../basic_extract/merg`second'
   *** This is a combined data set

sort `hh' line race sex age mis0 dup _merge
quietly by `hh' line race sex age mis0 dup: gen dup1 = cond(_N==1,0,_n)
drop if dup1 > 0 & _merge != 5
drop dup1
   *** All the records that were matched by allowing for age changes are now duplicated.
   *** First drop the ones with the younger age.
   
replace age = age+1 if _merge == 5
sort `hh' line race sex age mis0 dup _merge
quietly by `hh' line race sex age mis0 dup: gen dup1 = cond(_N==1,0,_n)
drop if dup1 > 0 & _merge != 5
   *** Then drop the ones with the older age.

drop dup1
replace _merge1 = 3 if _merge == 5
   *** Records that were merged with age off by one year now count as merged.
keep if _merge1 ==3
drop _merge1 _merge
   *** Keep only the matched records

capture describe
local obs_post = r(N)
display `"`obs_pre' observations prior to match"' 
display `"`obs_post' observations after match"'
  
*save the obs_pre and obs_post to file matchorg_match.txt
  if (`first' == 197601) {
    file open mr using "../result/basic_match_rate.txt", write replace
    file write mr "date" _tab "obs_pre" _tab "obs_post" _n
    file write mr %8.0f `"`first'"' _tab %8.0f `"`obs_pre'"' _tab %8.0f `"`obs_post'"' _n
    file close mr
  }
  else {
    file open mr using "../result/basic_match_rate.txt", write append
    file write mr %8.0f `"`first'"' _tab %8.0f `"`obs_pre'"' _tab %8.0f `"`obs_post'"' _n
    file close mr
  }
  
saveold ../basic_extract/merg`second', replace

}
local first=`second'
}

log close



