YSXRAZ6 ; COMPILED XREF FOR FILE #627.92 ; 10/15/04
 ; 
 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^DIC(627.9,DA(1),1,DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^DIC(627.9,DA(1),1,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^DIC(627.9,DA(1),1,"B",$E(X,1,30),DA)=""
 G:'$D(DIKLM) A Q:$D(DISET)
END Q