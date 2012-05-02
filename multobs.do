* PROGRAM:  multobs.do
* Data 5/April/2012


sort obsno
  display "Number of duplicate time t observations"
  count if (obsno==obsno[_n-1]|obsno==obsno[_n+1]) & _merge==3

  drop if sexdif==0 & (obsno==obsno[_n-1] | obsno==obsno[_n+1]) & _merge==3
  display "Number of duplicate time t observations: sex the same"
  count if (obsno==obsno[_n-1]| obsno==obsno[_n+1]) & _merge==3

  drop if racedif==0 & (obsno==obsno[_n-1] | obsno==obsno[_n+1]) & _merge==3
  display "Number of duplicate time t observations: sex and race the same"
  count if (obsno==obsno[_n-1]| obsno==obsno[_n+1]) & _merge==3

  drop if nragedif==0 & (obsno==obsno[_n-1] | obsno==obsno[_n+1]) & _merge==3
  drop if ragedif==0 & (obsno==obsno[_n-1] | obsno==obsno[_n+1]) & _merge==3
  display "Number of duplicate time t observations: sex, race and age the same"
  count if (obsno==obsno[_n-1]| obsno==obsno[_n+1]) & _merge==3

  drop if nredudif==0 & (obsno==obsno[_n-1] | obsno==obsno[_n+1]) & _merge==3
  drop if redudif==0 & (obsno==obsno[_n-1] | obsno==obsno[_n+1]) & _merge==3
  display "Number of duplicate time t observations: sex, race, age and education the same"
  count if (obsno==obsno[_n-1]| obsno==obsno[_n+1]) & _merge==3

  display "Number of remaining duplicate time t observations dropped:"
  drop if (obsno==obsno[_n-1]|obsno==obsno[_n+1]) & _merge==3
  assert obsno~=obsno[_n-1] if _merge==3

sort obsno2
  display "Number of duplicate time t observations"
  count if (obsno2==obsno2[_n-1]| obsno2==obsno2[_n+1]) & _merge==3

  drop if sexdif==0 & (obsno2==obsno2[_n-1] | obsno2==obsno2[_n+1]) & _merge==3
  display "Number of duplicate time t observations: sex the same"
  count if (obsno2==obsno2[_n-1]| obsno2==obsno2[_n+1]) & _merge==3

  drop if racedif==0 & (obsno2==obsno2[_n-1] | obsno2==obsno2[_n+1]) & _merge==3
  display "Number of duplicate time t observations: sex and race the same"
  count if (obsno2==obsno2[_n-1]| obsno2==obsno2[_n+1]) & _merge==3

  drop if nragedif==0 & (obsno2==obsno2[_n-1] | obsno2==obsno2[_n+1]) & _merge==3
  drop if ragedif==0 & (obsno2==obsno2[_n-1] | obsno2==obsno2[_n+1]) & _merge==3
  display "Number of duplicate time t observations: sex, race and age the same"
  count if (obsno2==obsno2[_n-1]| obsno2==obsno2[_n+1]) & _merge==3

  drop if nredudif==0 & (obsno2==obsno2[_n-1] | obsno2==obsno2[_n+1]) & _merge==3
  drop if redudif==0 & (obsno2==obsno2[_n-1] | obsno2==obsno2[_n+1]) & _merge==3
  display "Number of duplicate time t observations: sex, race, age and education the same"
  count if (obsno2==obsno2[_n-1]| obsno2==obsno2[_n+1]) & _merge==3

  display "Number of remaining duplicate time t observations dropped:"
  drop if (obsno2==obsno2[_n-1]|obsno2==obsno2[_n+1]) & _merge==3
  assert obsno2~=obsno2[_n-1] if _merge==3


