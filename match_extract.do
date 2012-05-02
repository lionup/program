*Program: match_extract.do
*Date 5/April/2012

****************************************************
* THIS PROGRAM EXTRACTS VARIABLES FROM CPS RAW DATA* 
****************************************************

set more 1

log using log_match_extract, text replace

local x=197601

while `x' <=197712 {
clear
infix hh 4-8 hh1 9-12 hh2 25-26 line 94-95 mis 2 age 97-98 race 100 sex 101 status 109 str dur 66-67 double fweight 121-132 educ 103-104 grade 105 mar 99 str ind 88-90 str occu 91-93 str lk 40 str class 87 using ../basic/cpsb`x'.raw
generate double hh3 = hh*1000000+hh1*100+hh2
generate educ1 = educ - 1 if educ >= 1
replace educ1 = educ1 - 1 if grade == 2 & educ1 >= 1
replace race = 3 if race > 2
drop hh hh1 hh2 educ
rename hh3 hh
rename educ1 educ
replace dur ="." if dur =="--"
replace ind ="." if ind =="---"
replace occu ="." if occu =="---"
replace lk ="." if lk =="-"
replace class ="." if class =="-"

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=198212 {
clear
infix double hh 4-15 line 94-95 mis 2 age 97-98 race 100 sex 101 status 109 str dur 66-67 double fweight 121-132 educ 103-104 grade 105 mar 99 str ind 88-90 str occu 91-93 str lk 40 str class 87 using ../basic/cpsb`x'.raw
replace race=3 if race>2
generate educ1 = educ - 1 if educ >= 1
replace educ1 = educ1 - 1 if grade == 2 & educ1 >= 1
drop educ
rename educ1 educ
replace dur ="." if dur =="--"
replace ind ="." if ind =="---"
replace occu ="." if occu =="---"
replace lk ="." if lk =="-"
replace class ="." if class =="-"

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=198312 {
clear
infix  double hh 4-15 line 94-95 mis 2 age 97-98 race 100 sex 101 status 109 str dur 66-67 double fweight 121-132 educ 103-104 grade 105 mar 99 str ind 524-526 str occu 527-529 str lk 40 str class 511 using ../basic/cpsb`x'.raw
replace race=3 if race>2
generate educ1 = educ - 1 if educ >= 1
replace educ1 = educ1 - 1 if grade == 2 & educ1 >= 1
drop educ
rename educ1 educ
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
replace lk ="." if lk =="-"
replace class ="." if class =="-"

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=198812 {
clear
infix  double hh 4-15 line 541-542 mis 2 age 97-98 race 100 sex 101 status 109 str dur 66-67 double fweight 121-132 educ 103-104 grade 105 mar 99 str ind 524-526 str occu 527-529 str lk 40 str class 511 using ../basic/cpsb`x'.raw
replace race=3 if race>2
generate educ1 = educ - 1 if educ >= 1
replace educ1 = educ1 - 1 if grade == 2 & educ1 >= 1
drop educ
rename educ1 educ
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
replace lk ="." if lk =="-"
replace class ="." if class =="-"

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=199112 {
clear
infix  double hh 145-156 line 264-265 mis 70 age 270-271 race 280 sex 275 status 348 str dur 304-305 double fweight 398-405 double lweight 576-583 llind 584 educ 277-278 grade 279 mar 272 str ind 310-312 str occu 313-315 str lk 197 str class 316 using ../basic/cpsb`x'.raw
replace race=3 if race>2
generate educ1 = educ
replace educ1 = educ1 - 1 if grade == 2 & educ1 >= 1
drop educ
rename educ1 educ
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
replace lk ="." if lk =="-"
replace class ="." if class =="-"

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=199312 {
clear
infix  double hh 145-156 line 264-265 mis 70 age 270-271 race 280 sex 275 status 348 str dur 304-305 double fweight 398-405 double lweight 576-583 llind 584 educ 277-278 mar 272 str ind 310-312 str occu 313-315 str lk 197 str class 316 using ../basic/cpsb`x'.raw
replace race=3 if race>2
replace dur="." if dur=="--"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
replace lk ="." if lk =="-"
replace class ="." if class =="-"

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=199508 {
clear
infix gestfips 93-94 double hrhhid 1-12 str hrsersuf 75-76 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 436-438 str occu 439-441 str lk 294-295 str class 462-463 samejob 426-427 using ../basic/cpsb`x'.raw
generate double hh=gestfips*1000000000000+hrhhid
replace race=3 if race>2
replace dur="." if dur=="---"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
replace lk ="." if lk =="--"
replace class ="." if class =="--"
drop hrhhid gestfips

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}


while `x' <=200212 {
clear
infix double hh 1-15 str hrsersuf 75-76 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 436-438 str occu 439-441 str lk 294-295 str class 462-463 samejob 426-427 using ../basic/cpsb`x'.raw
replace race=3 if race>2
replace dur="." if dur=="---"
replace ind="." if ind=="---"
replace occu="." if occu=="---"
replace lk ="." if lk =="--"
replace class ="." if class =="--"

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}


while `x' <=200404 {
clear
infix double hh 1-15 str hrsersuf 75-76 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 856-859 str occu 860-863 str lk 294-295 str class 462-463 samejob 426-427 using ../basic/cpsb`x'.raw
replace race=3 if race>2
replace dur="." if dur=="---"
replace ind="." if ind=="----"
replace occu="." if occu=="----"
replace lk ="." if lk =="--"
replace class ="." if class =="--"

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

while `x' <=201108 {
clear
infix double hh 1-15 str hhid2 71-75 line 147-148 mis 63-64 age 122-123 race 139-140 sex 129-130 status 180-181 str dur 407-409 double fweight 613-622 double lweight 593-602 llind 69-70 educ 137-138 mar 125-126 str ind 856-859 str occu 860-863 str lk 294-295 str class 462-463 samejob 426-427 using ../basic/cpsb`x'.raw
replace race=3 if race>2
replace dur="." if dur=="---"
replace ind="." if ind=="----"
replace occu="." if occu=="----"
replace lk ="." if lk =="--"
replace class ="." if class =="--"

compress
saveold ../basic_extract/cps`x'.dta

local x = `x' + 1
if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    }
}

log close
