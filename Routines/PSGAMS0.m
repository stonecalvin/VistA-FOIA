PSGAMS0 ;BIR/CML3-PRINT AMIS REPORT ;09 JUL 94 / 10:42 AM
 ;;5.0; INPATIENT MEDICATIONS ;;16 DEC 97
START ;
 D NOW^%DTC S PSGDT=%,PSGPDT=$$ENDTC^PSGMI(PSGDT),CML=IO'=IO(0)!(IOST'["C-"),(NP,LN1,LN2)="",$P(LN1,"-",81)="",$P(LN2,"=",81)="",(TCNT,TCST)=0
 U IO D HDR I '$D(^UTILITY("PSG",$J)) W !!?27,"*** NO AMIS DATA FOUND ***" G DONE
 ;
RUN ;
 S WN="" F  S WN=$O(^UTILITY("PSG",$J,WN)) Q:WN=""  S CST=^(WN) D:$Y+3>IOSL NP G:NP["^" DONE D WRITE
 ;
TOTLS ;
 D:$Y+4>IOSL NP I NP'["^" S TCPU=$S(TCNT:TCST/TCNT,1:0) S:TCST<0&(TCPU>0) TCPU=-TCPU W !,LN2,!!?15,"TOTALS =>",?35,$J(TCNT,9,0),?52,$J(TCST,12,2),?72,$J(TCPU,6,2)
 ;
DONE ;
 W:CML&($Y) @IOF,@IOF K %,%H,%I,CML,CNT,CPU,CST,LN1,LN2,NP,PSGPDT,TCNT,TCPU,TCST Q
 ;
WRITE ;
 S CNT=+CST,CST=$P(CST,"^",2),TCNT=TCNT+CNT,TCST=TCST+CST,CPU=$S(CNT:CST/CNT,1:0) S:CST<0&(CPU>0) CPU=-CPU W !?2,WN,?35,$J(CNT,9,0),?52,$J(CST,12,2),?72,$J(CPU,6,2),! Q
 ;
NP ;
 I 'CML W $C(7) R !,"'^' TO STOP ",NP:DTIME W:'$T $C(7) S:'$T NP="^" Q:NP["^"
 ;
HDR ;
 W:$Y @IOF W !!?30,"UNIT DOSE AMIS REPORT",?63,PSGPDT,!?25,"FROM ",STRT," THROUGH ",STOP,!!?35,"TOTAL UNITS",?56,"TOTAL",?68,"AVERAGE COST",!?10,"WARD",?36,"DISPENSED",?56,"COST",?70,"PER UNIT",!,LN1,! Q