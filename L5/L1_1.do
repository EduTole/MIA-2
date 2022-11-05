
/*
---------------------------------------------------
Curso: Microeconometria Aplicada II
tema: Datos agregados
Autor: Edinson Tolentino
---------------------------------------------------
*/
cls
clear all
gl main 	"D:\Dropbox\Docencia\UNI\L5\Aplicacion"
gl macro 	"${main}/Agregado"
gl clean 	"${main}/clean"


********************************
*	Manejo de Bases de Datos   *
********************************

*** Inversión Bruta Fija (FBK)
import excel "${macro}\Anuales-20201012-224711.xlsx", clear
destring B, replace force
drop if B==.
rename (A B) (año FBKF)
tempfile b1
save `b1', replace

*** PBI (Y)
import excel "${macro}\Anuales-20201012-225222.xlsx", clear
destring B, replace force
drop if B==.
rename (A B) (año Y)
tempfile b2
save `b2', replace

*** Trabajo (L)
import excel "${macro}\TED_1_JULY20201.xlsx", sheet("TCB_ADJUSTED") cellrange(A5) clear
keep if E=="Persons employed (thousands)"
keep if B=="PER"
xpose, clear // Transponemos la información
drop if v1==.
gen año = 1949 + _n
rename v1 L
tempfile b3
save `b3', replace

*** Capital Humano (H)

// Años de educación: 1950-2010
import excel "${macro}\OUP_long_MF1564_v1.xls", clear
replace A = A[_n-1] if A=="" // Completamos datos
keep if A=="Peru"
keep B L
rename (B L) (año YR_SCH)
destring, replace
drop if año==. | año<1950
tempfile b4_1
save `b4_1', replace

// Años de educación: 2015-2020
import excel "${macro}\OUP_proj_MF1564_v1.xls", clear
replace A = A[_n-1] if A==""
keep if A=="Peru"
keep B L
rename (B L) (año YR_SCH)
destring, replace
drop if año==. | año>2020
tempfile b4_2
save `b4_2', replace

use `b4_1', clear
append using `b4_2'
tempfile b4
save `b4', replace

*** Unión de Bases de Datos
use `b1', clear
forvalues j = 2/4 {
	merge 1:1 año using `b`j'', keep(master match) nogen
}

*** Interpolamos Años de Educación (para completar datos)
*findit ipolate
ipolate YR_SCH año, gen(y2) epolate
replace YR_SCH = y2 if YR_SCH==.
drop y2

*Setear el stata a serie de tiempo
tsset año, yearly

*** Stock de Capital (K)
// Insumos: Tasa de crecimiento del PBI y Ratio FBKF-PBI
gen G_Y = (Y/l.Y)-1
gen Ratio = FBKF/Y

// Parámetros para calcular el Ko
summ G_Y if año>=1950 & año<=1980
local g = r(mean)
local d = 0.05
summ Ratio if año>=1950 & año<=1980
local I = r(mean)

// Construimos K
gen K = `I'*Y/(`d' + `g') if año==1950
replace K = (1 -`d')*l.K + FBKF if año>=1951

*** Capital Humano (H)
local theta = 0.32
local psi = 0.58
gen H = exp((`theta'/(1-`psi'))*YR_SCH^(1-`psi'))

*** Etiquetas
keep año Y L K H
lab var año "Año"
lab var Y "Producto"   
lab var L "Trabajo"
lab var K "Capital"
lab var H "Capital Humano"

compress
saveold "${macro}\BD_Agregado.dta", replace

******************
*	Estimación   *
******************

use "${macro}\BD_Agregado.dta", clear

*** Tomamos Logaritmo
gen lnY = ln(Y)
gen lnK = ln(K)
gen lnL = ln(L*H)

*** PTF en niveles y tasa de crecimiento
local alpha = 0.65
gen lnA = lnY - `alpha'*lnK - (1-`alpha')*lnL
gen G_A = lnA - l.lnA
replace G_A = G_A*100

**********************************
*	Presentación de Resultados   *
**********************************

*** Evoluación de la PTF
#delimit;
line G_A año, 
ylabel(-15(5)7, labsize(small)) xlabel(1950(10)2020, labsize(small))
title("{bf:Evolución de la PTF, 1951-2019}") subtitle("(Variaciones porcentuales)", size(small)) 
ytitle("") xtitle("")
note("Fuente: ENAHO - INEI." "Elaboración: SEUPROS-UNI", size(vsmall))
scheme(s1color);
#delimit cr

*** Contabilidad del crecimiento

// Generamos Tasas de crecimiento
gen G_Y = lnY - l.lnY
gen G_K = (lnK - l.lnK)*0.65
gen G_L = (lnL - l.lnL)*(1-0.65)

foreach var of varlist G_Y G_K G_L {
	replace `var' = `var'*100
}

// Generamos grupos de años
gen g_año = .
replace g_año = 1 if año>=1951 & año<=1960
replace g_año = 2 if año>=1961 & año<=1970
replace g_año = 3 if año>=1971 & año<=1980
replace g_año = 4 if año>=1981 & año<=1990
replace g_año = 5 if año>=1991 & año<=2000
replace g_año = 6 if año>=2001 & año<=2010
replace g_año = 7 if año>=2011 & año<=2020
lab define g_año 1 "1951-1960" 2 "1961-1970" 3 "1971-1980" 4 "1981-1990" 5 "1991-2000" 6 "2001-2010" 7 "2011-2020"
lab values g_año g_año

#delimit;
graph bar (mean) G_Y G_K G_L G_A, sort(G_Y G_K G_L G_A) over(g_año, label(labsize(*0.7))) 
blabel(bar, format(%4.1f) size(vsmall)) 
title("{bf:Contabilidad del crecimiento, 1951-2019}") subtitle("(Puntos porcentuales)", size(small)) 
note("Fuente: ENAHO - INEI." "Elaboración: SEUPROS-UNI", size(vsmall))
legend(on order(1 "PBI" 2 "Capital" 3 "Trabajo" 4 "PTF") size(medium) row(1))
scheme(s1color) yline(0) ylabel("") ;
#delimit cr

*** Tabulado
table g_año, c(mean G_Y mean G_K mean G_L mean G_A)





