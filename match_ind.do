*Program: match_ind.do
*Date 5/April/2012

**************************************************
* THIS PROGRAM GENERATES CONSISTENT INDUSTRY CODE* 
**************************************************

set more 1

log using log_match_ind, text replace

local x = 197601
while `x' <= 201108 {

  use ../basic_extract/cps`x', clear

  if `x' <= 198212 {
    destring ind, gen(ind70)
	recode ind70 (29 58 78 267 399 499 599 699 719 767 799 817 899 = -1)
	sort ind70
	merge in70 using ind70.dta
	tab _merge
	drop ind70 _merge
	summ in7090
  }
  if `x' <= 199112 & `x' >= 198301 {
	destring ind, gen(ind80)
    recode ind80 (131 991 992 = -1) 
	sort ind80
	merge in80 using ind80.dta
	tab _merge
	drop ind80 _merge
	summ in7090
  }
  if `x' >= 199201 & `x' <= 200212  {
	destring ind, gen(ind90)
    recode ind90 (131 991 992 = -1) 
	sort ind90
	merge in90 using ind90.dta
	tab _merge
	drop ind90 _merge
	summ in7090
  }
  if `x' >= 200301 {
	destring ind, gen(ind02)
    recode ind02 (5591 5592 = 5590) (4285 = 4590) (6672 6675 = 6780) (6692 6695 = 6790) (9670 / 9990 = -1), gen(ind90)
    replace ind90 = int(ind90 / 10) if ind90 > 0
	#delimit ; 
    recode ind90 
(17 = 10)
(18 = 11)
(19 = 31)
(27 = 230)
(28 = 32)
(29 = 30)
(37 = 42)
(38 = 41)
(39 = 40)
(47 = 50)
(48 = -1)
(49 = -1)
(57 = 450)
(58 = 451)
(59 = 452)
(67 = 470)
(68 = 471)
(69 = 472)
(77 = 60)
(107 = 110)
(108 = 112)
(109 = 102)
(117 = 101)
(118 = 100)
(119 = 610)
(127 = 111)
(128 = 121)
(129 = 122)
(137 = 120)
(139 = 130)
(147 = 142)
(148 = 142)
(149 = 140)
(157 = 141)
(159 = 150)
(167 = 132)
(168 = 151)
(169 = 152)
(177 = 221)
(179 = 222)
(187 = 160)
(188 = 162)
(189 = 161)
(199 = 172)
(207 = 200)
(209 = 201)
(217 = 180)
(218 = 191)
(219 = 181)
(227 = 190)
(228 = 182)
(229 = 192)
(237 = 212)
(238 = 210)
(239 = 211)
(247 = 261)
(248 = 252)
(249 = 250)
(257 = 251)
(259 = 262)
(267 = 270)
(268 = 272)
(269 = 280)
(277 = 271)
(278 = 291)
(279 = 281)
(287 = 282)
(288 = 290)
(289 = 300)
(297 = 292)
(298 = 300)
(299 = 301)
(307 = 311)
(308 = 312)
(309 = 321)
(317 = 320)
(318 = 310)
(319 = 331)
(329 = 332)
(336 = 322)
(337 = 341)
(338 = 371)
(339 = 342)
(347 = 340)
(349 = 342)
(357 = 351)
(358 = 352)
(359 = 362)
(367 = 361)
(368 = 360)
(369 = 370)
(377 = 231)
(378 = 231)
(379 = 232)
(387 = 241)
(389 = 242)
(396 = 372)
(397 = 390)
(398 = 391)
(399 = 392)
(407 = 500)
(408 = 501)
(409 = 502)
(417 = 510)
(418 = 511)
(419 = 512)
(426 = 521)
(427 = 530)
(428 = 531)
(429 = 532)
(437 = 540)
(438 = 541)
(439 = 542)
(447 = 550)
(448 = 551)
(449 = 552)
(456 = 560)
(457 = 561)
(458 = 562)
(459 = 571)
(467 = 612)
(468 = 622)
(469 = 620)
(477 = 631)
(478 = 632)
(479 = 633)
(487 = 580)
(488 = 581)
(489 = 582)
(497 = 601)
(498 = 611)
(499 = 650)
(507 = 642)
(508 = 682)
(509 = 621)
(517 = 623)
(518 = 630)
(519 = 660)
(527 = 651)
(528 = 662)
(529 = 640)
(537 = 652)
(538 = 591)
(539 = 600)
(547 = 681)
(548 = 652)
(549 = 682)
(557 = 661)
(558 = 682)
(559 = 663)
(567 = 670)
(568 = 672)
(569 = 671)
(579 = 691)
(607 = 421)
(608 = 400)
(609 = 420)
(617 = 410)
(618 = 401)
(619 = 402)
(627 = 422)
(628 = 401)
(629 = 432)
(637 = 412)
(638 = 410)
(639 = 411)
(647 = 171)
(648 = 172)
(649 = 732)
(657 = 800)
(659 = 741)
(667 = 440)
(668 = 441)
(669 = 442)
(677 = 852)
(678 = 741)
(679 = 732)
(687 = 700)
(688 = 701)
(689 = 702)
(697 = 710)
(699 = 711)
(707 = 712)
(708 = 742)
(717 = 801)
(718 = 741)
(719 = 741)
(727 = 841)
(728 = 890)
(729 = 882)
(737 = 741)
(738 = 732)
(739 = 892)
(746 = 891)
(747 = 721)
(748 = 12)
(749 = 893)
(757 = -1)
(758 = 731)
(759 = 741)
(767 = 432)
(768 = 740)
(769 = 722)
(777 = 20)
(778 = 741)
(779 = 471)
(786 = 842)
(787 = 850)
(788 = 851)
(789 = 860)
(797 = 812)
(798 = 820)
(799 = 821)
(807 = 822)
(808 = 830)
(809 = 812)
(817 = 840)
(818 = 840)
(819 = 831)
(827 = 832)
(829 = 870)
(837 = 871)
(838 = 871)
(839 = 861)
(847 = 862)
(856 = 810)
(857 = 872)
(858 = 802)
(859 = 810)
(866 = 762)
(867 = 770)
(868 = 641)
(869 = 641)
(877 = 751)
(878 = 750)
(879 = 752)
(887 = 760)
(888 = 760)
(889 = 782)
(897 = 780)
(898 = 772)
(899 = 772)
(907 = 771)
(908 = 781)
(909 = 791)
(916 = 880)
(917 = 881)
(918 = 873)
(919 = 881)
(929 = 761)
(937 = 900)
(938 = 921)
(939 = 901)
(947 = 910)
(948 = 922)
(949 = 930)
(957 = 931)
(959 = 932)
;

    #delimit cr

	sort ind90
	merge in90 using ind90.dta
	tab _merge
	drop ind90 ind02 _merge
	summ in7090
  }



  *label consistent three-digit codes ind7090 
  label var ind7090 "consistent three-digit industry"
  #delimit ;
  label define ind7090
11 "Ag production crops & livestock"
20 "Ag services, except horticultural"
21 "Horticultural services"
30 "Forestry"
31 "Fishing, hunting and trapping"
40 "Metal mining"
41 "Coal mining"
42 "Crude petroleum and natural gas extraction"
50 "Nonmetallic mining and quarrying, except fuel"
60 "Construction"
100 "Meat products"
101 "Dairy products"
102 "Canned and preserved fuits and vegetables"
110 "Gain mill products"
111 "Bakery products"
112 "Sugar and confectionary products"
120 "Beverage industries"
121 "Misc. food preparations and kindred products"
122 "Not specified food industries"
130 "Tobacco manufactures"
132 "Knitting mills"
140 "Dyeing and finishing textiles, except wool and knit goods"
141 "Floor coverings, except hard surfaces"
142 "Yarn, thread, and fabric mills"
150 "Misc. textile mill products"
151 "Apparel and accessories, except knit"
152 "Misc. fabricated textile products"
160 "Pulp, paper, and paperboard mills"
161 "Misc. paper and pulp products"
162 "Paperboard containers and boxes"
171 "Newspaper publishing and printing"
172 "Printing, publishing, and allied industries except newspapers"
180 "Plastics, synthetics, and resins"
181 "Drugs"
182 "Soaps and cosmetics"
190 "Paints, varnishes, and related products"
191 "Agricultural chemicals"
192 "Industrial and miscellaneous chemicals"
200 "Petroleum refining"
201 "Misc. petroleum and coal products"
211 "Other rubber products, and plastics footwear and belting + Tires & Inner tubes"
212 "Misc. plastic products"
220 "Leather tanning and finishing"
221 "Footwear, except rubber and plastic"
222 "Leather products, except footwear"
230 "Logging"
231 "Sawmills, planning mills, and millwork"
241 "Misc. wood products"
242 "Furniture and fixtures"
250 "Glass and glass products"
251 "Cement, concrete, and gypsum, and plaster products"
252 "Structural clay products"
261 "Pottery and related products"
262 "Misc. nonmetallic mineral and stone products"
270 "Blast furnaces, steelworks, rolling and finishing mills"
271 "Iron and stell foundaries"
272 "Primary aluminum industries"
280 "Other primary metal industries"
281 "Cutlery, handtools, and other hardware"
282 "Fabricated structural metal products"
290 "Screw machine products"
291 "Metal forgings and stampings"
300 "Misc. fabricated metal products"
301 "Not specified metal industries"
310 "Engines and turbines"
311 "Farm machinery and equipment"
312 "Construction and material handling machines"
320 "Metalworking machinery"
321 "Office and accounting machines"
322 "Electronic computing equipment"
331 "Machinery, except electrical, n.e.c."
332 "Not specified machinery"
340 "Household appliances"
341 "Radio, T.V. and communication equipment"
342 "Eletrical machinery, equipment, and supplies, n.e.c."
350 "Not specified eletrical machinery, equipment, and supplies"
351 "Transporation equipment"
360 "Ship and boat building and repairing"
361 "Railroad locamotives and equipment"
362 "Guided missiles, space vehicles, and parts, Ordnance, and Aircraft and parts"
370 "Cycles and misc. transporation equipment & Wood buildings and mobile homes"
371 "Scientific and controlling instruments"
372 "Optical and health services supplies"
380 "Photographic equipment and supplies"
381 "Watches, clocks, and clockwork operated devices"
391 "Misc. manufacturing industries and toys, amusement and sporting goods"
392 "Not specified manufacturing industries"
400 "Railroads"
401 "Bus service and urban transit"
402 "Taxicab service"
410 "Trucking service"
411 "Warehousing and storage"
412 "U.S. Postal Service"
420 "Water transportation"
421 "Air transportation"
422 "Pipe lines, except natural gas"
432 "Services incidental to transportation"
441 "Telephone (wire and radio)"
442 "Telegraph and misc. communication services & Radio television and broadcasting"
460 "Electric light and power"
461 "Gas and steam supply systems"
462 "Eletric and gas, and other combinations"
470 "Water supply and irrigation"
471 "Sanitary services"
472 "Not specified utilities"
500 "Motor vehicles and equipment"
502 "Lumber and construction materials"
511 "Metals and minerals, except petroleum"
512 "Electrical goods"
521 "Hardware, plumbing and heating supplies"
531 "Scrap and waste materials"
540 "Paper and paper products"
541 "Drugs, chemicals, and allied products"
542 "Apparel, fabrics, and notions"
550 "Groceries and related products"
551 "Farm products, raw materials"
552 "Petroleum products"
560 "Alcoholic beverages"
561 "Farm supplies & Retail nurseries and garden stores"
562 "Misc. wholesale, durable AND non-durable goods. Sporting goods, toys, and hobby goods. Furniture and home furnishings. Machinery, equipment and supplies."
571 "Not specified wholesale trade"
580 "Lumber and building material retailing"
581 "Hardware stores"
591 "Deparment stores & Mail order houses"
592 "Variety stores"
600 "Misc. general merchandise stores and Sewing, needlework, and piece good stores"
601 "Grocery stores"
602 "Diary product stores"
610 "Retail bakeries"
611 "Food stores, n.e.c"
612 "Motor vehicle dealers"
620 "Auto and home supply stores"
621 "Gasoline service stations"
622 "Misc. vehicle dealers and Mobile home dealers"
630 "Apparel and accessory stores, except shoe"
631 "Shoe stores"
632 "Furniture and home furnishings stores"
640 "Household appliances, TV, and radio stores"
641 "Eating and drinking places"
642 "Drug stores"
650 "Liquor stores"
660 "Jewelry stores"
670 "Vending machine operators"
671 "Direct selling establishments"
672 "Fuel and ice dealers"
681 "Retail florists"
682 "Misc. retail stores. Sporting goods, bicycles and hobby stores. Book and stationery stores"
691 "Not specified retail trade"
700 "Banking"
702 "Credit agencies, n.e.c.. Savings and Loan associations"
710 "Security, commodity brokerage, and investment companies"
711 "Insurance"
712 "Real estate. including real estate-insurance-law offices"
721 "Advertising"
722 "Services to dwellings and other buildings"
731 "Personlle supply services"
732 "Misc. personal services. Business management and consulting. Commercial research, development and testing labs. Funeral services and creamtories. Misc. p.rofessional and related services. Noncommercial educational and scientific research"
740 "Computer and data processing services"
741 "Detective and protective services"
742 "Business services, n.e.c."
750 "Automotive repair shops. automotive services, except repair"
752 "Electrical repair shops"
760 "Misc. repair services"
761 "Private households"
762 "Hotels and motels"
770 "Lodging places, except hotels and motels"
771 "Laundry, cleaning, and garment services"
772 "Beauty shops"
780 "Barber shops"
782 "Shoe repair shops"
790 "Dressmaking shops"
800 "Theaters and motion pictures"
801 "Bowling alleys, billiard and pool parlors"
802 "Misc. entertainment and recreation services"
812 "Offices of physicians"
820 "Offices of dentists"
821 "Offices of chiropractors"
822 "Offices of health practitioners, n.e.c.. offices of optometrists"
831 "Hospitals"
832 "Nursing and personal care facillities"
840 "Heath services, n.e.c.. Job training and voc rehab services"
841 "Legal services"
842 "Elementary and secondary schools. child day care services"
850 "Colleges and universities"
852 "Libraries"
860 "Educational services, n.e.c.. Busines, trade, and vocational schools"
870 "Residential care facillities, without nursing"
871 "Social services, n.e.c"
872 "Museums, art galleries, and zoos"
880 "Religious organizations"
881 "Membership organizations"
882 "Engineering, architectural, and surveying services"
890 "Accounting, auditing, andd bookkeeping services"
901 "All public administration"
;
  #delimit cr
  lab val ind7090 ind7090




  * label consistent two-digit codes dind7090

  lab var dind7090 "consistent 2-digit industry"
  #delimit ;
  label define dind7090
1  "Agriculture Service"           
2  "Other Agriculture"             
3  "Mining"                        
4  "Construction"                  
5  "Lumber and wood products , except furniture"
6  "Furniture and fixtures"        
7  "Stone clay ,glass and concrete product"
8  "Primary metals"                
9  "Fabricated metal"              
10 "Not specified metal industries"
11 "Machinery, except electrical"  
12 "Electrical Machinery, equipment ,and supplies"
13 "Motor vehicles and equipment"          
15 "Other transportation equipment and Aircrafts and parts"
16 "Professional and photographic equipment"
18 "Miscellaneous and not specified manufacturing industries and Toys, amusements ,and sporting goods"
19 "Food and kindred products"     
20 "Tobacco manufactures"          
21 "Textile mill products"         
22 "Apparel and other finished textile prod."
23 "Paper and allied products"
24 "Printing ,publishing and allied industries"
25 "Chemicals and allied products" 
26 "Petroleum and coal products"   
27 "Rubber and miscellaneous plastics products"
28 "Leather and leather products"  
29 "Transportation"                
30 "Communications"                
31 "Utilities and Sanitary Services"
32 "Wholesale Trade"               
33 "Retail Trade"                  
34 "Banking and Other Finance"     
35 "Insurance and Real Estate"     
36 "Private Household Services"    
37 "Business Services"             
38 "Repair Services"               
39 "Personal Services , Except Private Household"
40 "Entertainment and Recreation Services"
41 "Hospitals"  
42 "Health Services and Job training and voc rehab services, Except Hospitals"
43 "Educational Services and Child day care services"          
44 "Social Services"               
45 "Other professional Services"   
46 "Forestry and Fisheries"        
50 "Public Administration"
;
  #delimit cr
  lab val dind7090 dind7090




  * label consistent one-digit codes mind7090

  lab var mind7090 "consistent 1-digit industry"
  #delimit ;
  label define mind7090
1 "AGRICULTURE"
2 "MINING"
3 "CONSTRUCTION"
4 "MANUFACTURING - DURABLE GOODS"
5 "MANUFACTURING - NON-DURABLE GOODS"
6 "TRANSPORTATION"
7 "COMMUNICATION"    
8 "UTILITIES AND SANITARY SERVICES"
9 "WHOLESALE TRADE"
10 "RETAIL TRADE"
11 "FINANCE, INSURANCE, AND REAL ESTATE"
12 "PRIVATE HOUSEHOLDS"
13 "BUSINESS, AUTO AND REPAIR SERVICES"
14 "PERSONAL SERVICES, EXC. PRIVATE HHLDS"
15 "ENTERTAINMENT AND RECREATION SERVICES"
16 "HOSPITALS"
17 "HEALTH SERVICES AND JOB TRAINING AND VOC REHAB SERVICES, EXCEPT HOSPITALS"
18 "EDUCATIONAL SERVICES AND CHILD DAY CARE SERVICES"
19 "SOCIAL SERVICES"
20 "OTHER PROFESSIONAL SERVICES"
21 "FORESTRY AND FISHERIES"
22 "PUBLIC ADMINISTRATION"
;
  #delimit cr
  lab val mind7090 mind7090

  saveold ../basic_extract/cps`x'.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

log close




