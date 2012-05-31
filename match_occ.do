*Program: match_occ.do
*Date 28/May/2012

****************************************************
* THIS PROGRAM GENERATES CONSISTENT OCCUPATION CODE* 
****************************************************

set more 1

log using log_match_occ, text replace

local x = 197601
while `x' <= 201108 {

  use ../basic_extract/cps`x', clear

  if `x' <= 198212 {
    destring occu, gen(occ70)
	sort occ70
	merge occ70 using occ70.dta
	tab _merge
  	drop if _merge == 2 
	drop occ70 _merge
	summ occ1990
  }
  if `x' <= 199112 & `x' >= 198301 {
	destring occu, gen(occ80)
	sort occ80
	merge occ80 using occ80.dta
	tab _merge
	drop if _merge == 2 
	drop occ80 _merge
	summ occ1990
  }
  if `x' >= 199201 & `x' <= 200212  {
    replace occu = "-1" if occu == "-1-" | occu == "1-1" | occu == "1 1"
	destring occu, gen(occ90)
	sort occ90
	merge occ90 using occ90.dta
	tab _merge
	drop if _merge == 2 
	drop occ90 _merge
	summ occ1990
  }
  if `x' >= 200301 & `x' <= 201012 {
	destring occu, gen(occ02)

    replace occ02 = int(occ02 / 10) if occ02 > 0
	sort occ02
	merge occ02 using occ02.dta
	tab _merge
	drop if _merge == 2 
	drop occ02 _merge
	summ occ1990
  }
  
  if `x' >= 201101 {
	destring occu, gen(occ11)
	sort occ11
	merge occ11 using occ11.dta
	tab _merge
	drop if _merge == 2 
	drop occ11 _merge
	summ occ1990
  }
  
  

  *label consistent three-digit codes occ1990 
  label var occ1990 "consistent three-digit occupation"
  #delimit ;
  label define occ1990
3  "Legislators"
4  "Chief executives and public administrators"
7  "Financial managers"
8  "Human resources and labor relations managers"
13  "Managers and specialists in marketing, advertising, and public relations"
14  "Managers in education and related fields"
15  "Managers of medicine and health occupations"
16  "Postmasters and mail superintendents"
17  "Managers of food-serving and lodging establishments"
18  "Managers of properties and real estate"
19  "Funeral directors"
21  "Managers of service organizations, n.e.c."
22  "Managers and administrators, n.e.c."
23  "Accountants and auditors"
24  "Insurance underwriters"
25  "Other financial specialists"
26  "Management analysts"
27  "Personnel, HR, training, and labor relations specialists"
28  "Purchasing agents and buyers, of farm products"
29  "Buyers, wholesale and retail trade"
33  "Purchasing managers, agents and buyers, n.e.c."
34  "Business and promotion agents"
35  "Construction inspectors"
36  "Inspectors and compliance officers, outside construction"
37  "Management support occupations"
43  "Architects"
44  "Aerospace engineer"
45  "Metallurgical and materials engineers, variously phrased"
47  "Petroleum, mining, and geological engineers"
48  "Chemical engineers"
53  "Civil engineers"
55  "Electrical engineer"
56  "Industrial engineers"
57  "Mechanical engineers"
59  "Not-elsewhere-classified engineers"
64  "Computer systems analysts and computer scientists"
65  "Operations and systems researchers and analysts"
66  "Actuaries"
67  "Statisticians"
68  "Mathematicians and mathematical scientists"
69  "Physicists and astronomers"
73  "Chemists"
74  "Atmospheric and space scientists"
75  "Geologists"
76  "Physical scientists, n.e.c."
77  "Agricultural and food scientists"
78  "Biological scientists"
79  "Foresters and conservation scientists"
83  "Medical scientists"
84  "Physicians"
85  "Dentists"
86  "Veterinarians"
87  "Optometrists"
88  "Podiatrists"
89  "Other health and therapy"
95  "Registered nurses"
96  "Pharmacists"
97  "Dietitians and nutritionists"
98  "Respiratory therapists"
99  "Occupational therapists"
103  "Physical therapists"
104  "Speech therapists"
105  "Therapists, n.e.c."
106  "Physicians' assistants"
113  "Earth, environmental, and marine science instructors"
114  "Biological science instructors"
115  "Chemistry instructors"
116  "Physics instructors"
118  "Psychology instructors"
119  "Economics instructors"
123  "History instructors"
125  "Sociology instructors"
127  "Engineering instructors"
128  "Math instructors"
139  "Education instructors"
145  "Law instructors"
147  "Theology instructors"
149  "Home economics instructors"
150  "Humanities profs/instructors, college, nec"
154  "Subject instructors (HS/college)"
155  "Kindergarten and earlier school teachers"
156  "Primary school teachers"
157  "Secondary school teachers"
158  "Special education teachers"
159  "Teachers , n.e.c."
163  "Vocational and educational counselors"
164  "Librarians"
165  "Archivists and curators"
166  "Economists, market researchers, and survey researchers"
167  "Psychologists"
168  "Sociologists"
169  "Social scientists, n.e.c."
173  "Urban and regional planners"
174  "Social workers"
175  "Recreation workers"
176  "Clergy and religious workers"
178  "Lawyers "
179  "Judges"
183  "Writers and authors"
184  "Technical writers"
185  "Designers"
186  "Musician or composer"
187  "Actors, directors, producers"
188  "Art makers: painters, sculptors, craft-artists, and print-makers"
189  "Photographers"
193  "Dancers"
194  "Art/entertainment performers and related"
195  "Editors and reporters"
198  "Announcers"
199  "Athletes, sports instructors, and officials"
200  "Professionals, n.e.c."
203  "Clinical laboratory technologies and technicians"
204  "Dental hygenists"
205  "Health record tech specialists"
206  "Radiologic tech specialists"
207  "Licensed practical nurses"
208  "Health technologists and technicians, n.e.c."
213  "Electrical and electronic (engineering) technicians"
214  "Engineering technicians, n.e.c."
215  "Mechanical engineering technicians"
217  "Drafters"
218  "Surveyors, cartographers, mapping scientists and technicians"
223  "Biological technicians"
224  "Chemical technicians"
225  "Other science technicians"
226  "Airplane pilots and navigators"
227  "Air traffic controllers"
228  "Broadcast equipment operators"
229  "Computer software developers"
233  "Programmers of numerically controlled machine tools"
234  "Legal assistants, paralegals, legal support, etc"
235  "Technicians, n.e.c."
243  "Supervisors and proprietors of sales jobs"
253  "Insurance sales occupations"
254  "Real estate sales occupations"
255  "Financial services sales occupations"
256  "Advertising and related sales jobs"
258  "Sales engineers"
274  "Salespersons, n.e.c."
275  "Retail sales clerks"
276  "Cashiers"
277  "Door-to-door sales, street sales, and news vendors"
283  "Sales demonstrators / promoters / models"
290  "Sales workers--allocated (1990 internal census)"
303  "Office supervisors"
308  "Computer and peripheral equipment operators"
313  "Secretaries"
314  "Stenographers"
315  "Typists"
316  "Interviewers, enumerators, and surveyors"
317  "Hotel clerks"
318  "Transportation ticket and reservation agents"
319  "Receptionists"
323  "Information clerks, nec"
326  "Correspondence and order clerks"
328  "Human resources clerks, except payroll and timekeeping"
329  "Library assistants"
335  "File clerks"
336  "Records clerks"
337  "Bookkeepers and accounting and auditing clerks"
338  "Payroll and timekeeping clerks"
343  "Cost and rate clerks (financial records processing)"
344  "Billing clerks and related financial records processing"
345  "Duplication machine operators / office machine operators"
346  "Mail and paper handlers"
347  "Office machine operators, n.e.c."
348  "Telephone operators"
349  "Other telecom operators"
354  "Postal clerks, excluding mail carriers"
355  "Mail carriers for postal service"
356  "Mail clerks, outside of post office"
357  "Messengers"
359  "Dispatchers"
361  "Inspectors, n.e.c."
364  "Shipping and receiving clerks"
365  "Stock and inventory clerks"
366  "Meter readers"
368  "Weighers, measurers, and checkers"
373  "Material recording, scheduling, production, planning, and expediting clerks"
375  "Insurance adjusters, examiners, and investigators"
376  "Customer service reps, investigators and adjusters, except insurance"
377  "Eligibility clerks for government programs; social welfare"
378  "Bill and account collectors"
379  "General office clerks"
383  "Bank tellers"
384  "Proofreaders"
385  "Data entry keyers"
386  "Statistical clerks"
387  "Teacher's aides"
389  "Administrative support jobs, n.e.c."
390  "Professional, technical, and kindred workers--allocated (1990 internal census)"
391  "Clerical and kindred workers--allocated (1990 internal census)"
405  "Housekeepers, maids, butlers, stewards, and lodging quarters cleaners"
407  "Private household cleaners and servants"
408  "Private household workers--allocated (1990 internal census)"
415  "Supervisors of guards"
417  "Fire fighting, prevention, and inspection"
418  "Police, detectives, and private investigators"
423  "Other law enforcement: sheriffs, bailiffs, correctional institution officers"
425  "Crossing guards and bridge tenders"
426  "Guards, watchmen, doorkeepers"
427  "Protective services, n.e.c."
434  "Bartenders"
435  "Waiter/waitress"
436  "Cooks, variously defined"
438  "Food counter and fountain workers"
439  "Kitchen workers"
443  "Waiter's assistant"
444  "Misc food prep workers"
445  "Dental assistants"
446  "Health aides, except nursing"
447  "Nursing aides, orderlies, and attendants"
448  "Supervisors of cleaning and building service"
453  "Janitors"
454  "Elevator operators"
455  "Pest control occupations"
456  "Supervisors of personal service jobs, n.e.c."
457  "Barbers"
458  "Hairdressers and cosmetologists"
459  "Recreation facility attendants"
461  "Guides"
462  "Ushers"
463  "Public transportation attendants and inspectors"
464  "Baggage porters"
465  "Welfare service aides"
468  "Child care workers"
469  "Personal service occupations, nec"
473  "Farmers (owners and tenants)"
474  "Horticultural specialty farmers"
475  "Farm managers, except for horticultural farms"
476  "Managers of horticultural specialty farms"
479  "Farm workers"
480  "Farm laborers and farm foreman--allocated (1990 internal census)"
483  "Marine life cultivation workers"
484  "Nursery farming workers"
485  "Supervisors of agricultural occupations"
486  "Gardeners and groundskeepers"
487  "Animal caretakers except on farms"
488  "Graders and sorters of agricultural products"
489  "Inspectors of agricultural products"
496  "Timber, logging, and forestry workers"
498  "Fishers, hunters, and kindred"
503  "Supervisors of mechanics and repairers"
505  "Automobile mechanics"
507  "Bus, truck, and stationary engine mechanics"
508  "Aircraft mechanics"
509  "Small engine repairers"
514  "Auto body repairers"
516  "Heavy equipment and farm equipment mechanics"
518  "Industrial machinery repairers"
519  "Machinery maintenance occupations"
523  "Repairers of industrial electrical equipment "
525  "Repairers of data processing equipment"
526  "Repairers of household appliances and power tools"
527  "Telecom and line installers and repairers"
533  "Repairers of electrical equipment, n.e.c."
534  "Heating, air conditioning, and refigeration mechanics"
535  "Precision makers, repairers, and smiths"
536  "Locksmiths and safe repairers"
538  "Office machine repairers and mechanics"
539  "Repairers of mechanical controls and valves"
543  "Elevator installers and repairers"
544  "Millwrights"
549  "Mechanics and repairers, n.e.c."
558  "Supervisors of construction work"
563  "Masons, tilers, and carpet installers"
567  "Carpenters"
573  "Drywall installers"
575  "Electricians"
577  "Electric power installers and repairers"
579  "Painters, construction and maintenance"
583  "Paperhangers"
584  "Plasterers"
585  "Plumbers, pipe fitters, and steamfitters"
588  "Concrete and cement workers"
589  "Glaziers"
593  "Insulation workers"
594  "Paving, surfacing, and tamping equipment operators"
595  "Roofers and slaters"
596  "Sheet metal duct installers"
597  "Structural metal workers"
598  "Drillers of earth"
599  "Construction trades, n.e.c."
614  "Drillers of oil wells"
615  "Explosives workers"
616  "Miners"
617  "Other mining occupations"
628  "Production supervisors or foremen"
634  "Tool and die makers and die setters"
637  "Machinists"
643  "Boilermakers"
644  "Precision grinders and filers"
645  "Patternmakers and model makers"
646  "Lay-out workers"
649  "Engravers"
653  "Tinsmiths, coppersmiths, and sheet metal workers"
657  "Cabinetmakers and bench carpenters"
658  "Furniture and wood finishers"
659  "Other precision woodworkers"
666  "Dressmakers and seamstresses"
667  "Tailors"
668  "Upholsterers"
669  "Shoe repairers"
674  "Other precision apparel and fabric workers"
675  "Hand molders and shapers, except jewelers "
677  "Optical goods workers"
678  "Dental laboratory and medical appliance technicians"
679  "Bookbinders"
684  "Other precision and craft workers"
686  "Butchers and meat cutters"
687  "Bakers"
688  "Batch food makers"
693  "Adjusters and calibrators"
694  "Water and sewage treatment plant operators"
695  "Power plant operators"
696  "Plant and system operators, stationary engineers "
699  "Other plant and system operators"
703  "Lathe, milling, and turning machine operatives"
706  "Punching and stamping press operatives"
707  "Rollers, roll hands, and finishers of metal"
708  "Drilling and boring machine operators"
709  "Grinding, abrading, buffing, and polishing workers"
713  "Forge and hammer operators"
717  "Fabricating machine operators, n.e.c."
719  "Molders, and casting machine operators"
723  "Metal platers"
724  "Heat treating equipment operators"
726  "Wood lathe, routing, and planing machine operators"
727  "Sawing machine operators and sawyers"
728  "Shaping and joining machine operator (woodworking)"
729  "Nail and tacking machine operators  (woodworking)"
733  "Other woodworking machine operators"
734  "Printing machine operators, n.e.c."
735  "Photoengravers and lithographers"
736  "Typesetters and compositors"
738  "Winding and twisting textile/apparel operatives"
739  "Knitters, loopers, and toppers textile operatives"
743  "Textile cutting machine operators"
744  "Textile sewing machine operators"
745  "Shoemaking machine operators"
747  "Pressing machine operators (clothing)"
748  "Laundry workers"
749  "Misc textile machine operators"
753  "Cementing and gluing maching operators"
754  "Packers, fillers, and wrappers"
755  "Extruding and forming machine operators"
756  "Mixing and blending machine operatives"
757  "Separating, filtering, and clarifying machine operators"
759  "Painting machine operators"
763  "Roasting and baking machine operators (food)"
764  "Washing, cleaning, and pickling machine operators"
765  "Paper folding machine operators"
766  "Furnace, kiln, and oven operators, apart from food"
768  "Crushing and grinding machine operators"
769  "Slicing and cutting machine operators"
773  "Motion picture projectionists"
774  "Photographic process workers"
779  "Machine operators, n.e.c."
783  "Welders and metal cutters"
784  "Solderers"
785  "Assemblers of electrical equipment"
789  "Hand painting, coating, and decorating occupations"
796  "Production checkers and inspectors"
799  "Graders and sorters in manufacturing"
803  "Supervisors of motor vehicle transportation"
804  "Truck, delivery, and tractor drivers"
808  "Bus drivers"
809  "Taxi cab drivers and chauffeurs"
813  "Parking lot attendants"
815  "Transport equipment operatives--allocated (1990 internal census)"
823  "Railroad conductors and yardmasters"
824  "Locomotive operators (engineers and firemen)"
825  "Railroad brake, coupler, and switch operators"
829  "Ship crews and marine engineers"
834  "Water transport infrastructure tenders and crossing guards"
844  "Operating engineers of construction equipment"
848  "Crane, derrick, winch, and hoist operators"
853  "Excavating and loading machine operators"
859  "Misc material moving occupations"
865  "Helpers, constructions"
866  "Helpers, surveyors"
869  "Construction laborers"
874  "Production helpers"
875  "Garbage and recyclable material collectors"
876  "Materials movers: stevedores and longshore workers"
877  "Stock handlers"
878  "Machine feeders and offbearers"
883  "Freight, stock, and materials handlers"
885  "Garage and service station related occupations"
887  "Vehicle washers and equipment cleaners"
888  "Packers and packagers by hand"
889  "Laborers outside construction"
890  "Laborers, except farm--allocated (1990 internal census)"
905  "Military"
991  "Unemployed"
999  "N/A and unknown"  
;
  #delimit cr
  lab val occ1990 occ1990
  
  
  * label consistent two-digit codes docc1990

  lab var docc1990 "consistent 2-digit occupation"
  #delimit ;
  label define docc1990
1  "EXECUTIVE, ADMINISTRATIVE, AND MANAGERIAL OCCUPATIONS"
2  "MANAGEMENT RELATED OCCUPATIONS"
3  "ENGINEERS, ARCHITECHTS, AND SURVEYORS"
4  "MATHEMATICAL AND COMPUTER SCIENTISTS"
5  "NATURAL SCIENTISTS"
6  "HEALTH DIAGNOSING OCCUPATIONS"
7  "THERAPISTS, HEALTH ASSESSMENT AND TREATMENT OCCUPATIONS"
8  "TEACHERS, POSTSECONDARY"
9  "TEACHERS, EXCEPT POSTSECONDARY"
10  "SOCIAL SCIENTISTS AND URBAN PLANNERS"
11  "LAWYERS AND JUDGES"
12  "OTHER PROFESSIONAL SPECIALITU OCCUPATIONS"
13  "HEALTH TECHNOLOGISTS AND TECHNICIANS"
14  "TECHNOLOGISTS AND TECHNICIANS, EXCEPT HEALTH"
15  "TECHNICIANS, EXCEPT HEALTH, ENGINEERING, AND SCIENCE"
16  "SUPERVISORS AND PROPRIETORS, SALES OCCUPATIONS"
17  "SALES REPs, FINANCE AND BUSINESS SERVICES"
18  "SALES REPs, COMMODITIES"
19  "SALES RELATED OCCUPATIONS"
20  "SUPERVISORS, ADMINISTRATIVE SUPPORT"
21  "COMPUTER EQUIPTMENT OPERATORS"
22  "SECRETARIES, STENOGRAPHERS, AND TYPISTS"
23  "FINANCIAL RECORDS PROCESSING"
24  "MAIL AND MESSAGE DISTRIBUTION"
25  "OTHER ADMIN. SUPPORT, INCLUDING CLERICAL"
26  "PRIVATE HOUSEHOLD SERVICE OCCUPATIONS"
27  "PROTECTIVE SERVICE"
28  "FOOD PREPARATION AND SERVICE"
29  "HEALTH SERVICE"
30  "CLEANING AND BUILDING SERVICE, EXCEPT HOUSEHOLDS"
31  "PERSONAL SERVICE"
32  "MECHANICS AND REPAIRERS"
33  "CONSTRUCTION TRADES"
34  "OTHER PRECISION PRODUCTION, CRAFT, AND REPAIR"
35  "MACHINE OPERATORS, AND TENDERS, EXCEPT PRECISION"
36  "FABRICATORS, ASSEMBLERS, INSPECTORS, SAMPLERS"
37  "MOTOT VEHICLE OPERATORS"
38  "OTHER TRANSPORTATION AND MATERIAL MOVING OCCUPATIONS"
39  "HELPERS, CONSTRUCTION AND EXTRACTIVE OCCUPATIONS"
40  "FREIGHT, STOCK, & MATERIALS HANDLERS"
41  "FARM OPERATORS AND MANAGERS"
42  "FARM WORKERS AND RELATED OCCUPATIONS"
43  "FORESTRY AND FISHING OCCUPATIONS"
44  "ARMED FORCES"
45  "EXPERIENCED UNEMPLOYED NOT CLASSIFIED BY OCCUPATION"
;
  #delimit cr
  lab val docc1990 docc1990




  * label consistent one-digit codes mocc1990

  lab var mocc1990 "consistent 1-digit occupation"
  #delimit ;
  label define mocc1990
1  "EXECUTIVE, ADMINISTRATIVE, & MANAGERIAL OCCUPATIONS"
2  "PROFESSIONAL SPECIALTY OCCUPATIONS"
3  "TECHNICIANS AND RELATED SUPPORT OCCUPATIONS"
4  "SALES OCCUPATIONS"
5  "ADMINISTRATIVE SUPPORT OCCUPATIONS, INCLUDING CLERICAL"
6  "PRIVATE HOUSEHOLD OCCUPATIONS"
7  "PROTECTIVE SERVICE OCCUPATIONS"
8  "SERVICE OCCUPATIONS, EXCEPT PROTECTIVE & HHLD"
9  "PRECISION PRODUCTION, CRAFT & REPAIR OCCUPATIONS"
10  "MACHINE OPERATORS, ASSEMBLERS & INSPECTORS"
11  "TRANSPORTATION AND MATERIAL MOVING OCCUPATIONS"
12  "HANDLERS, EQUIP CLEANERS, HELPERS, LABORERS"
13  "FARMING, FORESTRY AND FISHING OCCUPATIONS"
14  "ARMED FORCES"
15  "EXPERIENCED UNEMPLOYED NOT CLASSIFIED BY OCCUPATION"
;
  #delimit cr
  lab val mocc1990 mocc1990

  saveold ../basic_extract/cps`x'.dta, replace

  local x = `x' + 1
  if (`x'-13)/100 == int((`x'-13)/100) {
    local x = `x' + 88
    noisily display (`x'-1)/100
  }
}

log close



