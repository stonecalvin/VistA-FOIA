NURCEVE4 ;HIRMFO/RM,RTK-EDE LINK TO GMRG ;8/23/93
 ;;4.0;NURSING SERVICE;;Apr 25, 1997
EN1(DFN,GMRGPDA,GMRGRT,GMRGTERM) ; ENTRY TO SETUP ALL VARIABLES AND LINK TO GMRG SOFTWARE
 Q:'+GMRGTERM
 S GMRGOUT=0 L +^GMR(124.3,GMRGPDA,0):1 I '$T W !,$C(7),"ANOTHER TERMINAL IS EDITING THIS ENTRY!!" L -^GMR(124.3,GMRGPDA,0) Q
 K GMRGTPLT
 D DEM^VADPT,INP^VADPT S GMRGVNAM=VADM(1),GMRGVSSN=$P(VADM(2),U,2),GMRGVDOB=$P(VADM(3),U,2),GMRGVAGE=VADM(4),GMRGVAMV=VAIN(1),GMRGVPRV=$P(VAIN(2),U,2),GMRGVWRD=$P(VAIN(4),U,2),GMRGVRBD=VAIN(5),GMRGVADT=$P(VAIN(7),U,2),GMRGVDX=VAIN(9)
 K ^TMP($J) S GMRGTOP(0)=+GMRGRT,(GMRGNORD,GMRGUP)=0,(GMRGTOP,GMRGLVL,GMRGSLVL,GMRGTLVL)=1,GMRGLVL(1)=1,GMRGLVL(1,1)=1,GMRGTERM(0)=$S($D(^GMRD(124.2,+GMRGTERM,0)):^(0),1:""),GMRGSCRP=0
 S GMRGSITE=$S($P(GMRGTERM(0),"^",3)="":"",1:$O(^GMRD(124.1,1,1,"B",$P(GMRGTERM(0),"^",3),0))),GMRGSITE("P")=$S($D(^GMRD(124.1,1,1,+GMRGSITE,"P")):^("P"),1:""),GMRGSITE(0)=$S($D(^GMRD(124.1,1,1,+GMRGSITE,0)):^(0),1:"")
 S GMRGPRC=+GMRGTERM_"^^0",GMRGPRC(0)=$P(GMRGTERM,U,2)_U_$P(GMRGTERM,U,3)_U_$P($G(^GMR(124.3,GMRGPDA,1,+$P(GMRGTERM,U,3),0)),U,2)
 S ^TMP($J,"GMRGLVL",1,1,1)=GMRGPRC,^TMP($J,"GMRGLVL",1,1,1,0)=GMRGPRC(0),VAR=$O(^GMR(124.3,GMRGPDA,1,"B",+NURCX,0)),NURSPROB=1,NURSPROB(NURSPROB)=$P(NURCX,U,1,2)_"^"_VAR
 I $P(GMRGTERM,"^",3)="" S GMRGSTAT="^^"
 E  S GMRGST=$P(GMRGTERM,"^",3),GMRGST(1)=GMRGPDA D STAT^GMRGRUT0
 I '$P(GMRGSTAT,"^",3) D ADSEL^GMRGEDB S $P(GMRGTERM,"^",3)=$P(GMRGPRC(0),"^",2)
 S IOP="HOME" D ^%ZIS S X="IORVON;IORVOFF" D ENDR^%ZISS S GMRGIO("RVOF")=IORVOFF,GMRGIO("RVON")=IORVON,GMRGIO("S")=$L(GMRGIO("RVOF"))&$L(GMRGIO("RVON")) K IORVOFF,IORVON
 S (GMRGLIN("-"),GMRGLIN("*"))="",$P(GMRGLIN("-"),"-",IOM+1)="",$P(GMRGLIN("*"),"*",IOM+1)=""
 F  D EN1^GMRGED1 D QP^GMRGED2 S:'GMRGUP GMRGUP=GMRGNORD#2 I GMRGOUT!GMRGUP D Q3^GMRGED0 Q
 K GMRG,GMRGSCRP,GMRGSTAT,GMRGUP
 Q