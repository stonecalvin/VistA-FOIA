MCOREX ;WISC/TJK-OERR/MEDICINE DATA EXTRACT UTILITY ;2/17/98  14:48
 ;;2.3;Medicine;**17**;09/13/1996
SET S MCK=MCK+1,^TMP("MC",$J,MCC,MCK)=MCM_U_MCHEAD Q
POINT Q:'$D(^MCAR(MCFILE,MCARGDA,MCNODE))
 S MCM=$P($G(^MCAR(MCFILE,MCARGDA,MCNODE)),U,MCPIECE)
 Q:'MCM  S MCM=$P($G(^MCAR(MCFILE1,MCM,0)),U) Q:MCM=""
 D SET
 Q
MPOINT Q:'$D(^MCAR(MCFILE,MCARGDA,MCNODE))
 F I=0:0 S I=$O(^MCAR(MCFILE,MCARGDA,MCNODE,I)) Q:I'?1N.N  D
   .S J=$P(^MCAR(MCFILE,MCARGDA,MCNODE,I,0),U,MCPIECE)
   .Q:'J  S MCM=$P($G(^MCAR(MCFILE1,J,0)),U)
   .Q:MCM=""  D SET
 Q
FREE Q:'$D(^MCAR(MCFILE,MCARGDA,MCNODE))
 S MCM=$P(^MCAR(MCFILE,MCARGDA,MCNODE),U,MCPIECE) D SET Q
MFREE Q:'$D(^MCAR(MCFILE,MCARGDA,MCNODE))
 F I=0:0 S I=$O(^MCAR(MCFILE,MCARGDA,MCNODE,I)) Q:I'?1N.N  D
    .S MCM=$P(^MCAR(MCFILE,MCARGDA,MCNODE,I,0),U,MCPIECE)
    .Q:MCM=""  D SET
 Q
SETS Q:'$D(^MCAR(MCFILE,MCARGDA,MCNODE))
 S J=$P(^MCAR(MCFILE,MCARGDA,MCNODE),U,MCPIECE) Q:J=""
 ;S MCM=$P($G(^DD(MCFILE,MCFILE1,0)),U,3) Q:MCM=""
 S MCM=$$GET1^DID(MCFILE,MCFILE1,"","SPECIFIER") Q:MCM=""
 F K=1:1 S L=$P(MCM,";",K) Q:L=""  I $P(L,":",1)=J S MCM=$P(L,":",2) D SET Q
 Q
MSET Q:'$D(^MCAR(MCFILE,MCARGDA,MCNODE))
 F I=0:0 S I=$O(^MCAR(MCFILE,MCARGDA,MCNODE,I)) Q:I'?1N.N  D
    .S J=$P(^MCAR(MCFILE,MCARGDA,MCNODE,I,0),U,MCPIECE)
    .;Q:J=""  S MCM=$P($G(^DD(MCFILE1,.01,0)),U,3)
    .Q:J=""  S MCM=$$GET1^DID(MCFILE1,.01,"","SPECIFIER")
    .F K=1:1 S L=$P(MCM,";",K) Q:L=""  I $P(K,":",1)=J S MCM=$P(K,":",2) D SET Q
 Q
 ;
WP ;    word-processing field
 S $P(MCHEAD,";",2)="W" ;    indicate to OE/RR that this is WP
 S MCMUP=^DD(MCM,0,"UP")
 S MCMFLD=$O(^DD(MCMUP,"SB",MCM,""))
 ;S MCNODE=+$P(^DD(MCMUP,MCMFLD,0),"^",4)
 S MCNODE=$P($$GET1^DID(MCMUP,MCMFLD,"","GLOBAL SUBSCRIPT LOCATION"),";")
 F I=0:0 S I=$O(^MCAR(MCMUP,MCARGDA,MCNODE,I)) Q:I'?1N.N  D
    .S MCM=^MCAR(MCFILE,MCARGDA,MCNODE,I,0)
    .I MCM'="" D SET
 Q