FBCHPSA0 ;AISC/DMK-PSA OUTPUT CONTINUED ;13JUN90
 ;;3.5;FEE BASIS;;JAN 30, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 D HED^FBCHPSA K ^TMP("FBPSA",$J)
EN I FBPSA>0 F FBI=FBBEG-.1:0 S FBI=$O(^FBAAC("AQ",FBPSA,FBI)) Q:FBI'>0!(FBI>FBEND)!(FBAAOUT)  F FBJ=0:0 S FBJ=$O(^FBAAC("AQ",FBPSA,FBI,FBJ)) Q:FBJ'>0!(FBAAOUT)  F FBK=0:0 S FBK=$O(^FBAAC("AQ",FBPSA,FBI,FBJ,FBK)) Q:FBK'>0!(FBAAOUT)  D MORE
 I FBPSA=0 F FBPSA=0:0 S FBPSA=$O(^FBAAC("AQ",FBPSA)) Q:FBPSA'>0!(FBAAOUT)  F FBI=FBBEG-.1:0 S FBI=$O(^FBAAC("AQ",FBPSA,FBI)) Q:FBI'>0!(FBI>FBEND)!(FBAAOUT)  F FBJ=0:0 S FBJ=$O(^FBAAC("AQ",FBPSA,FBI,FBJ)) Q:FBJ'>0  D MORE1
 Q:FBAAOUT
 I $D(^TMP("FBPSA",$J)) D HED1^FBCHPSA F I=0:0 S I=$O(^TMP("FBPSA",$J,I)) Q:I'>0  S FBSTA=$S($D(^DIC(4,I,0)):$P(^(0),"^"),1:"Unknown") W !?2,FBSTA,?44,"$ ",$P(^TMP("FBPSA",$J,I),"^")
 I '$D(^TMP("FBPSA",$J)) D NONE^FBCHPSA1
 D HANG^FBCHPSA
 Q
 ;
PSATOT Q:'$O(^TMP("FBTOT",$J,0))  D HED2
 F I=0:0 S I=$O(^TMP("FBTOT",$J,I)) Q:I'>0  S FBSTA=$S($D(^DIC(4,I,0)):$P(^(0),"^"),1:"Unknown") W !?2,FBSTA,?44,"$ ",^TMP("FBTOT",$J,I)
 Q
HED2 W @IOF,!?13,"TOTALS DOLLAR AMOUNT BY PSA FOR ALL SELECTED PROGRAMS",!?12,$E(Q,1,55),!!,"For Date Range: ",BEGDATE," to ",ENDDATE,!,QQ
 W !?5,"PSA",?40,"TOTAL AMOUNT",!,?4,"-----",?39,"--------------------"
 Q
MORE F FBL=0:0 S FBL=$O(^FBAAC("AQ",FBPSA,FBI,FBJ,FBK,FBL)) Q:FBL'>0!(FBAAOUT)  F FBM=0:0 S FBM=$O(^FBAAC("AQ",FBPSA,FBI,FBJ,FBK,FBL,FBM)) Q:FBM'>0  I $D(^FBAAC(FBJ,1,FBK,1,FBL,1,FBM,0)) S FBY(0)=^(0) D GET
 Q
GET S DFN=FBJ,VAPA("P")="" D 4^VADPT S FBNAME=VADM(1),FBCOUNTY=$P(VAPA(7),"^",2),FBINV=$P(FBY(0),"^",16),FBAMTPD=$P(FBY(0),"^",3),FBPDDT=$P(FBY(0),"^",6),FBPDDT=$$DATX^FBAAUTL(FBPDDT),FBPPSA=$P(FBY(0),"^",12)
 S FBOBL=$S($P(FBY(0),"^",10)="":"Unknown",1:$P(FBY(0),"^",10))
 S FBSTA=$S($D(^DIC(4,FBPPSA,0)):$P(^(0),"^"),1:"Unknown")
 I $Y+4>IOSL D HANG^FBCHPSA Q:FBAAOUT  D HED^FBCHPSA
 W !,$E(FBNAME,1,30)," -",VA("BID"),?42,FBOBL,?57,FBCOUNTY,!,?4,FBINV,?21,FBAMTPD,?39,FBPDDT,?60,FBSTA,!,Q,!
 S:'$D(^TMP("FBPSA",$J,FBPSA)) ^TMP("FBPSA",$J,FBPSA)=0
 S ^TMP("FBPSA",$J,FBPSA)=^TMP("FBPSA",$J,FBPSA)+FBAMTPD
 S:'$D(^TMP("FBTOT",$J,FBPSA)) ^TMP("FBTOT",$J,FBPSA)=0
 S ^TMP("FBTOT",$J,FBPSA)=^TMP("FBTOT",$J,FBPSA)+FBAMTPD
 Q
MORE1 F FBK=0:0 S FBK=$O(^FBAAC("AQ",FBPSA,FBI,FBJ,FBK)) Q:FBK'>0!(FBAAOUT)  F FBL=0:0 S FBL=$O(^FBAAC("AQ",FBPSA,FBI,FBJ,FBK,FBL)) Q:FBL'>0!(FBAAOUT)  F FBM=0:0 S FBM=$O(^FBAAC("AQ",FBPSA,FBI,FBJ,FBK,FBL,FBM)) Q:FBM'>0  D MORE2
 Q
MORE2 I $D(^FBAAC(FBJ,1,FBK,1,FBL,1,FBM,0)) S FBY(0)=^(0) D GET
 Q