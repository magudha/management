cd"C:\Users\User\Documents\data"
dir
***importing STIData.
import excel "C:\Users\DOM\Desktop\Amrec\stata\STATA TRAINING\STIData.xls", sheet("STIData") firstrow
dir
gen bmi
bmi=Weight/((Height/100)^2)
**generating new variable**
gen bmi= Weight/ (Height/100)^2
list IdNumber if bmi==.
***creating categories***
gen bmi2=.
replace bmi2 =1 if bmi>12 & bmi<=20
replace bmi2 =2 if bmi>21 & bmi<=30
replace bmi2 =3 if bmi>30
***labelling the values***
label define bmi2 1"underweight"2"Normal"3"overweight"
label values bmi2 bmi2
label variable bmi2 "BMI status"
codebook bmi2
***alternatively***
gen Bmi_cat=""
replace Bmi_cat="underweight" if bmi2==1
replace Bmi_cat="overweight" if bmi2==2
replace Bmi_cat="obese" if bmi2==3
br Bmi_cat
codebook A1Age
gen age_cat=.
***importing csv file
import delimited "C:\Users\DOM\Desktop\Amrec\stata\Tuesday Stata\link_unformatted_extraTrain.csv"
***working with dates**
gen date=substr(_savepoint_timestamp,1,10)
br date _savepoint_timestamp
****converting date from string to numeric
gen date2=date(date,"YMD")
format date2 %td
br date date2
*********generating age
gen dob=substr(sd_a_birthdate,1,10)
gen dob1=date(dob,"YMD")
format dob1 %td
gen Dob=round((date2-dob1)/365,1)
br Dob
****merging=variables, appending=observations**
***importing dta**
use "C:\Users\DOM\Desktop\Amrec\stata\Tuesday Stata\set2_1to1.dta" 
***checking duplicates**
duplicates list 
br if idnumber==51
drop if idnumber==51 & a1age==23
sort idnumber
br idnumber
**********saving the new dataset**
save,replace
use "C:\Users\DOM\Desktop\Amrec\stata\Tuesday Stata\set2_1to1.dta"
duplicates report idnumber 
duplicates list idnumber
****generating a running number since idnumber is a true duplicate*** 
gen dup=_n
br dup idnumber
drop if idnumber==51 & dup==52
br dup idnumber
br if idnumber==51
sort idnumber
save,replace
use "set2_1to1.dta",clear
merge 1:1 idnumber using set2_1to1.dta
br
use"set1_1tom.dta",clear
merge 1:m idnumber using set2_1tom.dta
***many to one**
clear
use"set2_1tom.dta"
merge m:1 idnumber using set1_1tom.dta
***many to many**
clear
use"set1_miss.dta" 
merge m:m idnumber using set2_1tom.dta
**checking if an observation is in the missing in master dataset and in using data set and vice versa**
br _merge if idnumber==1
br _merge if idnumber==2
*****Appending**
use"setb_append.dta"
append using seta_append.dta
****Reshaping*
 import excel "C:\Users\DOM\Desktop\Amrec\stata\Tuesday Stata\TEST-TREAT-TRACK - FEASIBILITY EVALUATION OF THE TTTT STRATEGY (created 2019-07-17) 2019-07-17.xlsx",/*
 */ sheet("Repeat- Repeat_group2C") firstrow
 *********long to wide
 drop number number__1
 rename number__0 number
rename suggestionsEfficiencyC efficiency
bys number:gen j=_n
reshape wide efficiency, i(number)j(j)
destring,replace
save repeat_01
merge 1:1 number using repeat_01
drop _merge
save,replace
*************GroupC
import excel "C:\Users\DOM\Desktop\Amrec\stata\Tuesday Stata\TEST-TREAT-TRACK - FEASIBILITY EVALUATION OF THE TTTT STRATEGY (created 2019-07-17) 2019-07-17.xlsx",/*
 */ sheet("Repeat- Repeat_groupC") firstrow clear
  drop number number__1
 rename number__0 number
 rename barriers_challenges_experiencedC challanges
 bys number:gen j=_n
 reshape wide challanges ,i(number) j(j)
 destring,replace
 duplicates report number
 save repeat_02
 import excel "C:\Users\User\Documents\data\TEST-TREAT-TRACK - FEASIBILITY EVALUATION OF THE TTTT STRATEGY (created 2019-07-17) 2019-07-17.xlsx",/*
 */ sheet("Forms") firstrow clear
 destring,replace
 duplicates report number
 merge 1:1 number using repeat_02
 drop _merge
 save,replace
  import excel "C:\Users\User\Documents\data\TEST-TREAT-TRACK - FEASIBILITY EVALUATION OF THE TTTT STRATEGY (created 2019-07-17) 2019-07-17.xlsx",/*
 */ sheet("Repeat- Repeat_group2G") firstrow clear
 drop number number__1
 rename number__0 number
 rename suggestionsEfficiencyG suggEff 
 bys number:gen j=_n
 reshape wide suggEff ,i(number) j(j)
 destring,replace
 duplicates report number
 save repeat_03
destring,replace
 merge 1:1 number using repeat_03
 drop _merge
 save,replace
 ****importing repeat group G**
 import excel "C:\Users\User\Documents\data\TEST-TREAT-TRACK - FEASIBILITY EVALUATION OF THE TTTT STRATEGY (created 2019-07-17) 2019-07-17.xlsx",/*
 */ sheet("Repeat- Repeat_groupG") firstrow clear
  drop number number__1
 rename number number_0
 rename barriers_challenges_experiencedC challExp 
 bys number:gen j=_n
 reshape wide challExp  ,i(number) j(j)
 destring,replace
 duplicates report number
 save repeat_04
merge 1:1 number using repeat_04
drop _merge
save,replace
 ***importing repeat group GP2***
 import excel "C:\Users\User\Documents\data\TEST-TREAT-TRACK - FEASIBILITY EVALUATION OF THE TTTT STRATEGY (created 2019-07-17) 2019-07-17.xlsx",/*
 */ sheet("Repeat- Repeat_groupGP2") firstrow clear
 drop number number__1
 rename number__0 number
 rename  barriers_challenges_experiencedC challExpGP2 
 bys number:gen j=_n
 reshape wide challExpGP2,i(number) j(j)
 destring,replace
 duplicates report number
 save repeat_05
merge 1:1 number using "C:\Users\DOM\Desktop\Amrec\stata\Tuesday Stata\repeat_05.dta"
drop _merge
save,replace
br
 ******importing repeat group GP22**
 import excel "C:\Users\DOM\Desktop\Amrec\stata\Tuesday Stata\TEST-TREAT-TRACK - FEASIBILITY EVALUATION OF THE TTTT STRATEGY (created 2019-07-17) 2019-07-17.xlsx",/*
 */ sheet("Repeat- Repeat_groupGP22") firstrow clear
 drop number number__1
 rename number__0 number
 rename suggestionsEfficiencyGP2 suggEff_GP2 
 bys number:gen j=_n
 reshape wide suggEff_GP2  ,i(number) j(j)
 destring,replace
 duplicates report number
 save repeat_06
merge 1:1 number using "C:\Users\DOM\Desktop\Amrec\stata\Tuesday Stata\repeat_05.dta"
drop _merge
save,replace
 ***importing repeat group 2I***
 import excel "C:\Users\User\Documents\data\TEST-TREAT-TRACK - FEASIBILITY EVALUATION OF THE TTTT STRATEGY (created 2019-07-17) 2019-07-17.xlsx",/*
 */ sheet("Repeat- Repeat_group2I") firstrow clear
 drop number number__1
 rename number__0 number
 rename suggestionsEfficiencyG suggEff_G 
 bys number:gen j=_n
 reshape wide suggEff_G  ,i(number) j(j)
 destring,replace
 duplicates report number
 save repeat_07
 merge 1:1 number using repeat_07
 drop _merge
 save,replace
 br
 



 

