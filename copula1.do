*Program: copula1.do
*Date 5/April/2012

*************************************************************************
* THIS PROGRAM GENERATES MATCHED MONTHLY WAGE FILE FOR COPULA ESTIMATION* 
*************************************************************************

log using log_copula1, text replace
set more 1

capture program drop copula2
program define copula2
  copula3 `1' 1  `1'01
  copula3 `1' 2  `1'02
  copula3 `1' 3  `1'03
  copula3 `1' 4  `1'04
  copula3 `1' 5  `1'05
  copula3 `1' 6  `1'06
  copula3 `1' 7  `1'07
  copula3 `1' 8  `1'08
  copula3 `1' 9  `1'09
  copula3 `1' 10 `1'10
  copula3 `1' 11 `1'11
  copula3 `1' 12 `1'12
end

capture program drop copula3
program define copula3
  ** Matching is not possible due to sample redesigns between
  ** Jul to Dec 1984 4s to their 1985 8s
  ** Jan to Sep 1985 4s to their 1986 8s
  ** Jun to Dec 1994 4s to their 1995 8s
  ** Jan to Aug 1995 4s to their 1996 8s
  if (`3' != 198407 & `3' != 198408 & `3' != 198409 & `3' != 198410 /*
	*/ & `3' != 198411 & `3' != 198412 & `3' != 198501 & `3' != 198502 /*
	*/ & `3' != 198503 & `3' != 198504 & `3' != 198505 & `3' != 198506 /*
	*/ & `3' != 198507 & `3' != 198508 & `3' != 198509 & `3' != 199406 /*
	*/ & `3' != 199407 & `3' != 199408 & `3' != 199409 & `3' != 199410 /*
	*/ & `3' != 199411 & `3' != 199412 & `3' != 199501 & `3' != 199502 /*
	*/ & `3' != 199503 & `3' != 199504 & `3' != 199505 & `3' != 199506 /*
	*/ & `3' != 199507 & `3' != 199508) {
      clear 
      use ../basic_extract/org_merg`1' if month == `2' 
	  * keep only the observations have wage information in both months
      keep if w_ln_no != . & mw_ln_no != . 
	  keep w_ln_no mw_ln_no
	  saveold ../result/copula`3'	  
    }
end 

copula2 1979
copula2 1980 
copula2 1981 
copula2 1982 
copula2 1983
copula2 1984
copula2 1985 
copula2 1986 
copula2 1987 
copula2 1988 
copula2 1989 
copula2 1990 
copula2 1991 
copula2 1992 
copula2 1993 
copula2 1994 
copula2 1995 
copula2 1996 
copula2 1997 
copula2 1998 
copula2 1999 
copula2 2000
copula2 2001
copula2 2002
copula2 2003
copula2 2004
copula2 2005
copula2 2006
copula2 2007
copula2 2008
copula2 2009
copula2 2010

log close


