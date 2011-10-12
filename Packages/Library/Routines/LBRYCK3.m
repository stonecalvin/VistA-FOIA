LBRYCK3 ;ISC2/DJM-CHECK-IN ROUTING, INDIVIDUAL COPIES ;[ 05/23/97  12:13 PM ]
 ;;2.5;Library;**2**;Mar 11, 1996
CK D CHECK,SHOW G ASKDT
CHECK K RC
 S LA0=$P(^LBRY(680,LBRYLOC,0),U),LA0=$P(^LBRY(680.5,LA0,0),U)
 S LA1="JOURNAL",LA2="DATE",LA3="V(I)",LA8="COMPLETED",LA5="COPIES"
 S LA6="RECEIVED",LA11="ORDERED",LA9="DISPOSITION",LA0="TITLE: "_LA0
 S LA00="" I $G(^LBRY(680,LBRYLOC,1))'="" S LA00="  "_$P(^(1),U,5)
 S RTD=0 D RTED S:RTD=0 RTD=""
 S AA=^LBRY(682,A(X),1),AA1=$P(AA,U),AA2=$P(AA,U,2),AA3=$P(AA,U,3)
 S AA4=$P(AA,U,4),AA5=$P(AA,U,5) S:AA3'="" AA2=AA2_"("_AA3_")" I AA4=0 S AA4=""
 S Y=AA1 X ^DD("DD") S AA1=Y
 W @IOF,"VA Library Serials Check-in",?60,YDT,!!,LA0,!,LA00
 W !!,?5,LA1,?41,LA5,?50,LA5,?60,LA5,!,?5,LA2,?21,LA3,?41,LA11,?50,LA6,?60,LA8,!
 W ?5 F I=1:1:64 W "-"
 W !,?5,AA1,?18,AA2,?44,AA5,?53,AA4,?63,RTD,!
 Q
RTED S N=0 F  S N=$O(^LBRY(682,A(X),4,N)) Q:N=""!(N?.AP)  S N2=^LBRY(682,A(X),4,N,0) I $P(N2,U,2)<4&($P(N2,U)'="ToC") S RTD=RTD+1
 Q
SHOW S N=0 W !,?6,"C",?58,"LIBRARY",!,?6,"A",?45,"DATE",?58,"SITE"
 W !,?6,"T",?8,"STATUS",?28,"LOCATION",?45,"RECEIVED",?58,"LOCATION"
 W !,?6 F I=1:1:73 W "-"
SHOW1 S N=$O(^LBRY(682,A(X),4,"B",N)) Q:N=""
 S N1=$O(^LBRY(682,A(X),4,"B",N,0)),RR=^LBRY(682,A(X),4,N1,0)
 S RR1=$P(RR,U),RR2=$P(RR,U,2),RR7=$P(RR,U,7),Y=RR7 X ^DD("DD")
 S RR7=Y S:RR1=+RR1 RR1="c"_RR1 D SHOW2
 G SHOW1
SHOW2 S RR2=$S(RR2=1:"ROUTED",RR2=2:"ROUTED (TO RETURN)",RR2=3:"SHELVED",RR2=4:"NOT RECEIVED",1:"TOC NOT RECEIVED")
 S RRX=$P(RR,U,3),RRX0=$G(^LBRY(681,RRX,0)),RRX=$G(^LBRY(681,RRX,1))
 S RR4=$P(RRX,U,4),RRY=$P(RRX,U,2),RR5=""
 S:$D(RRY)&(RRY]"") RR5=$E($P(^LBRY(680.7,RRY,0),U),1,15)
 S RR8=$P(RRX0,U,4),RR8=$S(RR5]"":$E($P(^LBRY(680.6,RR8,0),U),1,22),1:"")
 W !,RR1,?6,RR4,?8,RR2,?28,RR5,?45,RR7,?58,RR8
 Q
ASKDT I AA5-RTD<1 G FINI^LBRYCK4
 S LBX=X
DATE W !!,"DATE RECEIVED: TODAY// " S DTOUT=0 R X:DTIME E  S DTOUT=1 W $C(7) G ^LBRYCK
 G:X="^" ^LBRYCK D:X="?" DP S:X="" X="T" S %DT="E" D ^%DT G:Y<0 DATE S LDATE=Y G ASK^LBRYCK4
DP W !,"Enter the actual date the copy is received in the library." Q