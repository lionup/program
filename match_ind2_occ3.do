*Program: match_ind2_occ3.do
*Date 5/April/2012

*************************************************************************************************
* THIS PROGRAM GENERATES EMPLOYMENT SHARE BY EDUCATION, 2-DIGIT INDUSTRY, and 3-DIGIT OCCUPATION* 
*************************************************************************************************

set more 1

log using log_match_ind2_occ3, text replace

local x = 197601
while `x' <= 201108 {
  use ../basic_extract/cps`x'.dta, clear
  * keep only the records at least 16 years old, employed, and with no missing value on education, ind7090, occ1990
  keep if age >= 16
  keep if status == 1 | status == 2
  drop if educ6c == . | dind7090 == . | occ1990 == .

  sort dind7090 occ1990 educ6c

  * sum weight for each category  
  replace fweight = 0 if fweight == .
  egen double em_share = total(fweight), by (dind7090 occ1990 educ6c)
  replace em_share = em_share / 1000
  if `x' > 199400 { 
	replace em_share = em_share / 100
  }
  
  sort dind7090 occ1990 educ6c
  quietly by dind7090 occ1990 educ6c:  gen duplic = cond(_N==1,0,_n)
  drop if duplic > 1
  keep dind7090 occ1990 educ6c em_share
  gen date = `x'
  egen monthsum = total(em_share)
  replace em_share = em_share/monthsum
  drop monthsum
  
* some industry, occupation, and education category do not exist so just give them value 0
  local ind_num "1 2 3 4 5 6 7 8 9 10 11 12 13 15 16 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 50"
  
  local occ_num "3 4 7 8 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 29 33 34 35 36 37 43 44 45 47 48 53 55 56 57 59 64 65 66 67 68 69 73 74 75 76 77 78 79 83 84 85 86 87 88 89 95 96 97 98 99 103 104 105 106 113 114 115 116 118 119 123 125 127 128 139 145 147 149 150 154 155 156 157 158 159 163 164 165 166 167 168 169 173 174 175 176 178 179 183 184 185 186 187 188 189 193 194 195 198 199 200 203 204 205 206 207 208 213 214 215 217 218 223 224 225 226 227 228 229 233 234 235 243 253 254 255 256 258 274 275 276 277 283 290 303 308 313 314 315 316 317 318 319 323 326 328 329 335 336 337 338 343 344 345 346 347 348 349 354 355 356 357 359 361 364 365 366 368 373 375 376 377 378 379 383 384 385 386 387 389 390 391 405 407 408 415 417 418 423 425 426 427 434 435 436 438 439 443 444 445 446 447 448 453 454 455 456 457 458 459 461 462 463 464 465 468 469 473 474 475 476 479 480 483 484 485 486 487 488 489 496 498 503 505 507 508 509 514 516 518 519 523 525 526 527 533 534 535 536 538 539 543 544 549 558 563 567 573 575 577 579 583 584 585 588 589 593 594 595 596 597 598 599 614 615 616 617 628 634 637 643 644 645 646 649 653 657 658 659 666 667 668 669 674 675 677 678 679 684 686 687 688 693 694 695 696 699 703 706 707 708 709 713 717 719 723 724 726 727 728 729 733 734 735 736 738 739 743 744 745 747 748 749 753 754 755 756 757 759 763 764 765 766 768 769 773 774 779 783 784 785 789 796 799 803 804 808 809 813 815 823 824 825 829 834 844 848 853 859 865 866 869 874 875 876 877 878 883 885 887 888 889 890" 
  
  qui foreach i of numlist `ind_num' { 	
        foreach j of numlist `occ_num' { 
          forvalues m = 1/6 {
            count if dind7090 == `i' & occ1990 == `j' & educ6c == `m'
            if r(N) == 0 {
                set obs `=_N + 1'
                replace date = `x'
			    replace dind7090 = `i' in L
			    replace occ1990 = `j' in L
			    replace educ6c = `m' in L
                replace em_share = 0 in L
            }
          }
        }
      }
  sort dind7090 occ1990 educ6c
  

   * generate sorting variables
  gen year = int( date /100 )
  gen month = int( (date - year*100) )
  gen qtr = int((month - 1) / 3) + 1
  order year qtr month date dind7090 occ1990 educ6c em_share, first

  if `x' != 197601{
	append using ../result/ind2_occ3.dta
  }
  sort year qtr month date dind7090 occ1990 educ6c
  saveold ../result/ind2_occ3.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}


log close




