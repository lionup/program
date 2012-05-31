*Program: match_ind3_occ1.do
*Date 5/April/2012

*************************************************************************************************
* THIS PROGRAM GENERATES EMPLOYMENT SHARE BY EDUCATION, 3-DIGIT INDUSTRY, and 1-DIGIT OCCUPATION* 
*************************************************************************************************

set more 1

log using log_match_ind3_occ1, text replace

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  * keep only the records at least 16 years old, employed, and with no missing value on education, ind7090, occ1990
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | ind7090 == . | mocc1990 == .

  sort ind7090 mocc1990 educ6c

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double em_share = total(fweight), by (ind7090 mocc1990 educ6c)
  replace em_share = em_share / 1000
  if `x' > 199400 { 
	replace em_share = em_share / 100
  }
  
  sort ind7090 mocc1990 educ6c
  quietly by ind7090 mocc1990 educ6c:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep ind7090 mocc1990 educ6c em_share
  gen date = `x'
  egen monthsum = total(em_share)
  replace em_share = em_share/monthsum
  drop monthsum
  
  * some industry, occupation, and education category do not exist so just give them value 0
  local ind_num "11 20 21 30 31 40 41 42 50 60 100 101 102 110 111 112 120 121 122 130 132 140 141 142 150 151 152 160 161 162 171 172 180 181 182 190 191 192 200 201 211 212 220 221 222 230 231 241 242 250 251 252 261 262 270 271 272 280 281 282 290 291 300 301 310 311 312 320 321 322 331 332 340 341 342 350 351 360 361 362 370 371 372 380 381 391 392 400 401 402 410 411 412 420 421 422 432 441 442 460 461 462 470 471 472 500 502 511 512 521 531 540 541 542 550 551 552 560 561 562 571 580 581 591 592 600 601 602 610 611 612 620 621 622 630 631 632 640 641 642 650 660 670 671 672 681 682 691 700 702 710 711 712 721 722 731 732 740 741 742 750 752 760 761 762 770 771 772 780 782 790 800 801 802 812 820 821 822 831 832 840 841 842 850 852 860 870 871 872 880 881 882 890 901"
  
  qui foreach i of numlist `ind_num' { 
        forvalues j = 1/13 {
          forvalues m = 1/6 {
            count if ind7090 == `i' & mocc1990 == `j' & educ6c == `m'
            if r(N) == 0 {
                set obs `=_N + 1'
                replace date = `x'
			    replace ind7090 = `i' in L
			    replace mocc1990 = `j' in L
			    replace educ6c = `m' in L
                replace em_share = 0 in L
            }
          }
        }
      }
  sort ind7090 mocc1990 educ6c
  

   * generate sorting variables
  gen year = int( date /100 )
  gen month = int( (date - year*100) )
  gen qtr = int((month - 1) / 3) + 1
  order year qtr month date ind7090 mocc1990 educ6c em_share, first

  if `x' != 197601{
	append using ../result/ind3_occ1.dta
  }
  sort year qtr month date ind7090 mocc1990 educ6c
  saveold ../result/ind3_occ1.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}


log close




