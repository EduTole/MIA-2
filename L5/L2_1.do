/*
---------------------------------------------------
Curso: Microeconometria Aplicada II
Tema: EEA
Autor: Edinson Tolentino
---------------------------------------------------
*/

cls
clear all
capture mkdir "D:\Dropbox\Docencia\UNI\L5\Aplicacion"
set more off
gl main 	"D:\Dropbox\Docencia\UNI\L5\Aplicacion"
gl clean 	"${main}/clean"
gl codigos 	"${main}/Codigos"
gl tablas 	"${main}/Tablas"

cd $clean

pwd 
dir
*Pagina web desde 2019
*--------------------------------------------------
global url "http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS"
*-------------------------------------------------------------------------
* 1.- Cargando las Bases de Datos
*-------------------------------------------------------------------------
*2019
clear all
cd "${clean}"
copy "$url/733-Modulo1592.zip" 733-Modulo1592.zip, replace
unzipfile 733-Modulo1592.zip, replace

cap cd .//733-Modulo1592//a2018_CAP_01
import spss "a2018_CAP_01.sav", clear
cd "${clean}"
saveold a2018_CAP_01.dta, replace
clear all


*2018
clear all
cd "${clean}"
copy "$url/645-Modulo1428.zip" 645-Modulo1428.zip, replace
unzipfile 645-Modulo1428.zip, replace

cap cd .//630-Modulo1560//a2017_CAP_01
import spss "a2017_CAP_01.sav", clear
cd "${clean}"
saveold a2017_CAP_01.dta, replace
clear all

*2017
clear all
cd "${clean}"
copy "$url/627-Modulo1348.zip" 627-Modulo1348.zip, replace
unzipfile 627-Modulo1348.zip, replace

cap cd .//552-Modulo1116//a2016_CAP_01
import spss "a2016_CAP_01.sav", clear
cd "${clean}"
saveold a2016_CAP_01.dta, replace
clear all

*-------------------------------------------------------
* Year : 2019
*-------------------------------------------------------

clear all
cd "${clean}"
copy "$url/733-Modulo1602.zip" 733-Modulo1602.zip, replace
unzipfile 733-Modulo1602.zip, replace

*Informacion de base de datos de valor agregado
*-----------------------------------------------------------------
cap cd .//733-Modulo1602//a2018_s11_fD2
import spss "a2018_s11_fD2_c03_1.sav", clear
cd "${clean}"
saveold a2018_s11_fD2_c03_1.dta, replace
clear all

*Informacion de base de datos de numero de trabajadores
*-------------------------------------------------------------------------
cap cd .//733-Modulo1602//a2018_s11_fD2
import spss "a2018_s11_fD2_c11_1.sav", clear
cd "${clean}"
saveold a2018_s11_fD2_c11_1.dta, replace
clear all

*Informacion de base de datos de capital
*-------------------------------------------------------------------------
cap cd .//733-Modulo1602//a2018_s11_fD2
import spss "a2018_s11_fD2_c05_1.sav", clear
cd "${clean}"
saveold a2018_s11_fD2_c05_1.dta, replace
clear all

*-------------------------------------------------------
* Year : 2018
*-------------------------------------------------------
clear all
cd "${clean}"
copy "$url/645-Modulo1438.zip" 645-Modulo1438.zip, replace
unzipfile 645-Modulo1438.zip, replace

*Informacion de base de datos de valor agregado
*-------------------------------------------------------------------------
cap cd .//630-Modulo1570//a2017_s11_fD2
import spss "a2017_s11_fD2_c03_1.sav", clear
cd "${clean}"
saveold a2017_s11_fD2_c03_1.dta, replace
clear all

*Informacion de base de datos de numero de trabajadores
*-------------------------------------------------------------------------
cap cd .//630-Modulo1570//a2017_s11_fD2
import spss "a2017_s11_fD2_c11_1.sav", clear
cd "${clean}"
saveold a2017_s11_fD2_c11_1.dta, replace
clear all

*Informacion de base de datos de capital
*-------------------------------------------------------------------------
cap cd .//630-Modulo1570//a2017_s11_fD2
import spss "a2017_s11_fD2_c05_1.sav", clear
cd "${clean}"
saveold a2017_s11_fD2_c05_1.dta, replace
clear all


*-------------------------------------------------------
* Year : 2017
*-------------------------------------------------------
clear all
cd "${clean}"
copy "$url/627-Modulo1358.zip" 627-Modulo1358.zip, replace
unzipfile 627-Modulo1358.zip, replace

*Informacion de base de datos de valor agregado
*-------------------------------------------------------------------------
cap cd .//552-Modulo1126//a2016_s11_fD2
import spss "a2016_s11_fD2_c03_1.sav", clear
cd "${clean}"
saveold a2016_s11_fD2_c03_1.dta, replace
clear all

*Informacion de base de datos de numero de trabajadores
*-------------------------------------------------------------------------
cap cd .//552-Modulo1126//a2016_s11_fD2
import spss "a2016_s11_fD2_c11_1.sav", clear
cd "${clean}"
saveold a2016_s11_fD2_c11_1.dta, replace
clear all

*Informacion de base de datos de capital
*-------------------------------------------------------------------------
cap cd .//552-Modulo1126//a2016_s11_fD2
import spss "a2016_s11_fD2_c05_1.sav", clear
cd "${clean}"
saveold a2016_s11_fD2_c05_1.dta, replace
clear all



*-------------------------------------------------------------------------
* 3.- Limpiando las Bases de Datos
*-------------------------------------------------------------------------
local bases "a2018_s11_fD2_c03_1 a2018_s11_fD2_c11_1 a2018_s11_fD2_c05_1 a2017_s11_fD2_c03_1 a2017_s11_fD2_c11_1 a2017_s11_fD2_c05_1 a2016_s11_fD2_c03_1 a2016_s11_fD2_c11_1 a2016_s11_fD2_c05_1"
foreach q in `bases' {
clear all
unicode analyze "`q'.dta" //Para cada uno cambiar la ruta.
unicode encoding set "latin1"
unicode translate "`q'.dta"
*** Modulo de Manufactura
use "`q'.dta", clear
d
clear all
}

*-------------------------------------------------------------------------
* 4.- Procesando las Bases de Datos
*-------------------------------------------------------------------------
*** Midiendo el valor agregado
forvalues i=2016/2018{
u "${clean}/a`i'_s11_fD2_c03_1.dta",clear
do "${codigos}/1.- rva.do"
g ryear=`i'
tempfile bd_rva_`i'
saveold `bd_rva_`i'',replace
}

u `bd_rva_2016'
append using `bd_rva_2017'
append using `bd_rva_2018'
tempfile bd_rva
save `bd_rva',replace

forvalues i=2016/2018{
u "${clean}/a`i'_s11_fD2_c11_1.dta",clear
do "${codigos}/2.- rl.do"
g ryear=`i'
tempfile bd_rl_`i'
saveold `bd_rl_`i'',replace
}

u `bd_rl_2016'
append using `bd_rl_2017'
append using `bd_rl_2018'
tempfile bd_rl
save `bd_rl',replace


forvalues i=2016/2018{
u "${clean}/a`i'_s11_fD2_c05_1.dta",clear
do "${codigos}/3.- rk.do"
g ryear=`i'
tempfile bd_rk_`i'
saveold `bd_rk_`i'',replace
}

u `bd_rk_2016'
append using `bd_rk_2017'
append using `bd_rk_2018'
tempfile bd_rk
save `bd_rk',replace

forvalues i=2016/2018{
	u "${clean}/a`i'_CAP_01.dta",clear
	do "${codigos}/4.- restablecimiento.do"
	g ryear=`i'
	destring factor_exp, replace
	keep ryear iruc ubigeo ciiu factor_exp
	order ryear iruc ubigeo ciiu factor_exp

tempfile bd_id_`i'
saveold `bd_id_`i'',replace
}

u `bd_id_2016'
append using `bd_id_2017'
append using `bd_id_2018'
tempfile bd_id
save `bd_id',replace


*-------------------------------------------------------------------------
* 5.- Procesando bases
*-------------------------------------------------------------------------
u `bd_id',clear
merge 1:1 ryear iruc using `bd_rva',keep(match) nogen
merge 1:1 ryear iruc using `bd_rl',keep(match) nogen
merge 1:1 ryear iruc using `bd_rk',keep(match) nogen
br
*-------------------------------------------------------------------------
* 6.- Generacion de variables
*-------------------------------------------------------------------------
** Nivel de ventas
egen rventas = rowtotal(vn_m vn_p p_ss)
lab var rventas "Ventas (S/.)"

** Tamaño empresarial
gen rtam = .
replace rtam = 1 if rventas<=150*3950
replace rtam = 2 if rventas>150*3950 & rventas<=1700*3950
replace rtam = 3 if rventas>1700*3950 & rventas<=2300*3950
replace rtam = 4 if rventas>2300*3950
lab define rtam 1 "Microempresa" 2 "Pequeña empresa" 3 "Mediana empresa" 4 "Gran empresarial"
lab values rtam rtam
tab rtam
** Capital
egen K = rowmean(act_tot_ini act_tot_fin)

** Inversión
gen INV = act_tot_fin - act_tot_ini

** Renombramos
rename (rva rl) (Y L)

keep ryear iruc ubigeo ciiu rtam rventas Y K L INV insumos factor_exp
order ryear iruc ubigeo ciiu rtam rventas Y K L INV insumos factor_exp
format rventas Y K L %20.0f
saveold "${clean}\BD_EEA.dta", replace

*-------------------------------------------------------------------------
* 7.- Deflactacion de datos
*-------------------------------------------------------------------------

*reacion de sector
g sector1 =9
merge m:1 ryear sector1 using "${clean}/BD_Deflactores.dta", keep(match) keepusing(d_VA d_FBK_Fijo) nogen

*** Deflactamos
replace Y = 100 * Y / d_VA
replace K = 100 * K / d_FBK_Fijo

*** Logaritmo
gen lnY = ln(Y)
gen lnK = ln(K)
gen lnL = ln(L)
gen lnI	= ln(insumos)
gen lnINV = ln(INV)


compress
cls

******************
*	Estimación   *
******************

*** MCO
reg lnY lnL lnK, vce(robust)
predict ln_PTF_OLS if e(sample), resid
replace ln_PTF_OLS = ln_PTF_OLS + _b[_cons] if e(sample) // PTF en Logaritmo
gen PTF_OLS = exp(ln_PTF_OLS) if e(sample) // PTF en niveles
outreg2 using "${tablas}\PTF.xls", ctitle(MCO) replace label keep(lnK lnL)

*** Efectos Fijos
destring iruc, replace
xtset iruc ryear

xtreg lnY lnL lnK , fe vce(robust)
predict ln_PTF_FE if e(sample), u 
replace ln_PTF_FE = ln_PTF_FE + _b[_cons] if e(sample)
gen PTF_FE = exp(ln_PTF_FE) if e(sample)
outreg2 using "${tablas}\PTF.xls", ctitle(FE) append label keep(lnK lnL)

*** Olley & Pakes (OP)

// Construimos ID de salida
gen firmid = iruc
sort firmid ryear
by firmid: gen count = _N
gen survivor = count == 3
gen has95 = 1 if ryear == 2016
sort firmid has95
by firmid: replace has95 = 1 if has95[_n-1] == 1
replace has95 = 0 if has95 == .
sort firmid ryear
by firmid: gen has_gaps = 1 if ryear[_n-1] != ryear-1 & _n != 1
sort firmid has_gaps
by firmid: replace has_gaps = 1 if has_gaps[_n-1] == 1
replace has_gaps = 0 if has_gaps == .
by firmid: generate exit = survivor == 0 & has95 == 0 & has_gaps != 1 & _n == _N
replace exit = 0 if exit == 1 & ryear == 2016

// Estimación
*findit opreg
opreg lnY, exit(exit) state(lnK) proxy(lnINV) free(lnL) vce(bootstrap, rep(50))
predict ln_PTF_OP if e(sample), tfp 
gen PTF_OP = exp(ln_PTF_OP) if e(sample)
outreg2 using "${tablas}\PTF.xls", ctitle(OP) append label keep(lnK lnL)

*** Levinsohn & Petrin (LP)
levpet lnY, free(lnL) proxy(lnI) capital(lnK) valueadded reps(50)
predict PTF_LP if e(sample), omega
gen ln_PTF_LP = ln(PTF_LP) if e(sample)
outreg2 using "${tablas}\PTF.xls", ctitle(LP) append label keep(lnK lnL)

acfest lnY, free(lnL) proxy(lnINV) state(lnK) robust invest
