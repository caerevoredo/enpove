clear all

cd "C:"

u enpove2022_v_100, clear

merge 1:m conglomerado vivienda nhogar using enpove2022_v_200
keep if _merge==3
drop _merge

**salud
merge 1:1 conglomerado vivienda nhogar p200_n using enpove2022_v_400
rename _merge _m400

*educación
merge 1:1 conglomerado vivienda nhogar p200_n using enpove2022_v_500
rename _merge _m500

*empleo e ingresos
merge 1:1 conglomerado vivienda nhogar p200_n using enpove2022_v_600
rename _merge _m600

count

*****

tab p204 [iw=factorfinal] if p208==1
tab p206 p204 [iw=factorfinal] if p208==1, col nofreq

tab p206 ciudad [iw=factorfinal] if p208==1, col nofreq

*edad
replace p205_a=0 if p205_a==.
recode p205_a (0/4=1 "0 a 4") (5/9=2 "5 a 9") (10/14=3 "10 a 14") (15/19=4 "15 a 19") (20/24=5 "20 a 24") (25/29=6 "25 a 29") (30/34=7 "30 a 34") (35/39=8 "35 a 39") (40/44=9 "40 a 44") (45/49=10 "45 a 49") (50/54=11 "50 a 54") (55/59=12 "30 a 34") (else=13 "60 a más"), g(g_edad)

tab g_edad p204 [iw=factorfinal] if p208==1, col nofreq

tab g_edad p204 [iw=factorfinal] if p208==1 & ciudad=="Trujillo", col nofreq

tab p204 [iw=factorfinal] if p208==1 & p203==1

**hogar
tab p104 [iw=factorfinal] if p200_n==1 & p203==1

recode p105 (1=1 "1") (2=2 "2") (3=3 "3") (else=4 "4 a 8"), g(n_hab)
tab n_hab [iw=factorfinal] if p200_n==1 & p203==1

*
tab p107 [iw=factorfinal] if p200_n==1 & p203==1


*energía
tab p108_3 [iw=factorfinal] if p200_n==1 & p203==1

tab p108_4 [iw=factorfinal] if p200_n==1 & p203==1

tab p402 [iw=factorfinal] if p203==1 & presfin==1

fre p402


**situaciones que requieren atención en salud en las últimas 4 semanas
g sit_sal=0
replace sit_sal=1 if p405_1==1 | p405_2==1 | p405_3==1 | p405_4==1 | p405_5==1 | p405_6==1
replace sit_sal=. if p405_1==. | p405_2==. | p405_3==. | p405_4==. | p405_5==. | p405_6==.

drop sit_sal
tab sit_sal

**No buscó atención
tab p406_8 [iw=factorfinal] if _m400==3 

tab p407_1 [iw=factorfinal] if _m400==3 & p405_7==0


**Empleo e ingresos

g pea_o=1 if p205_a>=14 & (p611_cod>"0" | p611_cod<"9999")
replace pea_o=0 if p205_a>=14

tab pea_o [iw=factorfinal] if _m500==3, m

*p204: miembro del hogar, 1:si, 2:no
*p205: se encuentra ausente hogar 30 días ""
*p206: está presente en el hogar ""

(p204==1 & p205==2 | p204==2 & p206==1)

	**ocupación en 5 grandes grupos
		gen div = trunc( p611_cod/100)
	recode div (1/3 =1) (5/9 =2) (10/33 =3) (35 =4) (36/39 =5) (41/43 =6) (45/47 =7) (49/53 =8)/*
	*/(55/56 =9) (58/63 =10) (64/66 =11) (68 =12) (69/75 =13) (77/82 =14) (84 =15) (85 =16)/*
	*/(86/88 =17) (90/93 =18) (94/96 =19) (97/98 =20) (99 =21), gen(secc)
	*CINCO CATEGORIAS
	recode secc (1/2=.) (3=4) (4=8) (5=8) (6=5) (7=6) (8=7) (10=7) (9=8) (11/21=8), gen(nrama1)
	replace nrama1 = 1 if  (div == 1 | div == 2) & nrama1 == .
	replace nrama1 = 2 if  div == 3 & nrama1 == .
	replace nrama1 = 3 if  (div == 5 | div == 6 | div == 7 | div == 8 |div == 9) & nrama1 == .
	lab define nrama1 1"Agropecuario" 2"Pesca" 3"Mineria" 4"Manufactura" 5"Construcción" 6"Comercio" 7"Transp y Comunic" 8"Servicios"
	label val nrama1 nrama1
	lab var nrama1 "Nivel por grupos de actividad Principal"

	tab p207 nrama1 [iw=fac500a] if pea_o==1 & (p204==1 & p205==2 | p204==2 & p206==1)
     
	 
	 
	**Años de educación
	
