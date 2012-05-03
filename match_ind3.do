*Program: match_ind3.do
*Date 5/April/2012

********************************************************************************
* THIS PROGRAM GENERATES MONTHLY 3-DIGIT INDUSTRY EMPLOYMENT SHARE BY EDUCATION* 
********************************************************************************

set more 1

log using log_match_ind3, text replace

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  * keep only the records at least 16 years old, employed, and with no missing value on education and ind7090 
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | ind7090 == .

  * create sorting variable "indEduc" categoried by industry and education
  tostring educ6c, gen(educ2)
  tostring ind7090, gen(ind2)
  replace educ2 = "e" + educ2
  gen str5 indEduc = ind2 + educ2
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
  #delimit ;
  numlist "11 20 21 30 31 40 41 42 50 60 100 101 
  102 110 111 112 120 121 122 130 132 140 141
  142 150 151 152 160 161 162 171 172 180 181 
  182 190 191 192 200 201 211 212 220 221 222 230
  231 241 242 250 251 252 261 262 270 271 272 
  280 281 282 290 291 300 301 310 311 312 320 321
  322 331 332 340 341 342 350 351 360 361 362
  370 371 372 380 381 391 392 400 401 402 410 411
  412 420 421 422 432 441 442 460 461 462 470
  471 472 500 502 511 512 521 531 540 541 542 550
  551 552 560 561 562 571 580 581 591 592 600 
  601 602 610 611 612 620 621 622 630 631 632 640
  641 642 650 660 670 671 672 681 682 691 700
  702 710 711 712 721 722 731 732 740 741 742 750
  752 760 761 762 770 771 772 780 782 790 800
  801 802 812 820 821 822 831 832 840 841 842 850
  852 860 870 871 872 880 881 882 890 901"
  ;
  #delimit cr

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
  order _all, seq
  order year qtr month date, first

  if `x' != 197601{
	append using ../result/ind3.dta
  }
  sort year qtr month date
  saveold ../result/ind3.dta, replace

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
saveold ../result/ind3.dta, replace

log close


