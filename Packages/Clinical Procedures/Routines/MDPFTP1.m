MDPFTP1 ;HOIFO/NCA - PFT REPORT-DEMO INFO ;3/15/04  11:55
 ;;1.0;CLINICAL PROCEDURES;**2**;Apr 01, 2004
 ; Reference IA #10061 for VADPT call.
 ;              #10040 for HOSPITAL LOCATION FILE #44.
 ;              #10060 for NEW PERSON file #200.
 ;              #3175 for measurement API XLFMSMT
 ; ------------------------
 ; SSN = Enternal Format of the patients SSN with the first letter
 ; of the last name tacked on the end
 ; ------------------------
GET(MDGRS,MDF,MDR,MDPNAM,MDLNE,MDH) ; Return the PFT report in MDGRS
 Q:'$G(MDR)  N DFN
 S MCPFT0=$G(^MCAR(700,+MDR,0)),DFN=$P(MCPFT0,U,2) Q:MCPFT0=""
 D DEM^VADPT S MCARGNM=VADM(1),SSN=VA("PID")
 S X1=$E($P(MCPFT0,U),1,7),X2=$P(VADM(3),U)
 ; ---------------------
 ; AGE = the patients age at the date of the procedure
 ; ---------------------
 S AGE=$E(X1,1,3)-$E(X2,1,3)-($E(X1,4,7)<$E(X2,4,7))
 S RACE=$P(VADM(8),U,2),CLIN="" S:$P(MCPFT0,U,10) CLIN=$P(MCPFT0,U,10) I CLIN,$D(^SC(CLIN,0)) S CLIN=$P(^(0),U)
 N MCHOLD S MCHOLD=RACE,RACE=$$ETHN(MCHOLD,.VADM)
 S DATE=$P(MCPFT0,U),DATE=+$E(DATE,4,5)_"/"_+$E(DATE,6,7)_"/"_$E(DATE,2,3)_$S($P(DATE,".",2):"@"_+$E(DATE,9,10)_":"_$S($L($E(DATE,11,12))=2:$E(DATE,11,12),$L($E(DATE,11,12))=1:$E(DATE,11)_"0",1:"00"),1:"")
 N HTCM,HTIN,WTKG,WTLB
 S (HTIN,HT1)=$P(MCPFT0,U,4),(HTCM,HT)=$P($$LENGTH^XLFMSMT(HTIN,"IN","CM")," ")
 S (WTLB,WT1)=$P(MCPFT0,U,5),(WTKG,WT)=$P($$WEIGHT^XLFMSMT(WTLB,"LB","KG")," ")
 I HT'>0 S (HTCM,HT)=$P(MCPFT0,U,3),(HTIN,HT1)=$P($$LENGTH^XLFMSMT(HTCM,"CM","IN")," ")
 I WT'>0 S (WTKG,WT)=$P(MCPFT0,U,6),(WTLB,WT1)=$P($$WEIGHT^XLFMSMT(WTKG,"KG","LB")," ")
 S $P(MCDOT,".",81)=""
 S (MC17,MCEFF,MCSEX)="" S:$D(^MCAR(700,+MDR,17)) MC17=^(17),MCEFF=$P(MC17,U,6),MCEFF=$S(MCEFF="G":"GOOD",MCEFF="E":"EXCELLENT",MCEFF="P":"POOR",1:"")
 S MCSEX=$P(VADM(5),U),X=$P(VADM(3),"^",2) S MCARDOB=$S(X'="":X,1:""),X=$P(MCPFT0,U) D DTIME^MCARP S (MCARGDT,MCARGDT2)=X
 D INP^VADPT S MCARWARD=$S(VAIN(4)'="":$P(VAIN(4),U,2),1:"NOT INPATIENT"),MCARRB=VAIN(5) D NOW^%DTC S X=% D DTIME^MCARP S MCARDTM=X
 D HEAD^MDPS2
 S SS="SEX: "_MCSEX_"  AGE: "_AGE_$J(" ",10)_+$J(HT1,0,2)_" in/"_+$J(WT1,0,1)_" lb"
 S SS=SS_$J(" ",60-$L(SS))_"AMBIENT: "_$P(MCPFT0,U,12)_"C/"_$P(MCPFT0,U,7)_"T" K HT1,WT1 D SETNODE(MDGRS,SS) S SS=""
 S SS="RACE: "_RACE S TECH=$P(MCPFT0,U,13) I TECH,$$GET1^DIQ(200,TECH_",",.01)'="" S TECH=$$GET1^DIQ(200,TECH_",",.01)
 I $L(RACE)>60 D SETNODE(MDGRS,SS) S SS=""
 S SS=SS_$J(" ",60-$L(SS))_"TECH: "_$E(TECH,1,14) D SETNODE(MDGRS,SS) S SS=""
 S SS=$S($P(MCPFT0,U,8)="Y":"SMOKER",$P(MCPFT0,U,8)="N":"NON-SMOKER",1:"")
 S SS=SS_$J(" ",30-$L(SS))_$S($P(MCPFT0,U,9)="Y":"CURRENT BRONCHODILATOR USE",1:"")
 S SS=SS_$J(" ",60-$L(SS))_"EFFORT: "_MCEFF D SETNODE(MDGRS,SS)
 K ^UTILITY("DIQ1",$J) D SETNODE^MDPFTP1(MDGRS," "),SETNODE^MDPFTP1(MDGRS,"CONSULT DX: ") S DR(700.01)=.01,DIQ(0)="E",DIC="^MCAR(700,"
 F K=0:0 S K=$O(^MCAR(700,MDR,1,K)) Q:K'?1N.N  S DA=MDR,DA(700.01)=K,DR=11,DIQ(0)="E" D EN^DIQ1 I $D(^UTILITY("DIQ1",$J,700.01,K,.01,"E"))#2 D SETNODE(MDGRS,$J(" ",15)_$G(^("E")))
 K ^UTILITY("DIQ1",$J),DIQ D SETNODE(MDGRS,MCDOT) D PRED
 S RDATE=9999999.9999-$P(MCPFT0,U)
 D:$D(MCRCN) SETNODE(MDGRS,MCRCN)
 D ^MDPFTP2,FOOTER^MDPS2
EXIT ; End of PFT Report process
 K ^UTILITY($J),MCOUT,ACT,AGE,CK,CLIN,D0,D1,DA,DATE,CI95
 K HB,PH,PACO2,PAO2,O2HB,COHB,FIO2,MHB,PAAO2,QSQT,CAO2,CVO2
 K DIC,DIW,DIWL,DIWR,DIWT,DLCOSB,DN,MCDOT,DR,FEV1,FRC,FVC,MC17
 K HT,I,J,K,MCARGNM,MCFF,MCK,MCN,MCPI,MCREC,MCREC1,MCVCN
 K MCREC2,MCTLCN,MCVN,MCX,MEAS,FEF2575,ND,ND1,P1,P2,PC,PD1,PD11,MCEFF
 K PD2,PD21,PF,MCPFT0,PG,PRED,MCPV,RACE,RDATE,RDATE1,RDATE2,RV,MCSEX
 K SSN,TAB,TECH,TLC,TYPE,UNIT,UNITS,VC,WT,X,Z,VA,MCRCN
 K MCMVVN,MVV,PMVV,MCSP,MCP1S0,MCP1S1,MCP1S2,MCP2S0,MCP2S1,MCP2S2
 K CDLCOSB,MCIAO1,MCIAO2,MCIDA,MCIDL,MCIDP,MCIFA,MCIFE
 K MCIFL,MCIFV,MCIPTL,MCIRV,MCITL,MCMAIN,MCP1,MCP2,MCRC,MCRCR
 K MCTYPEP,MCY,MCRC1,MCRC2,MCRC3,MCRC4,MCSTAT,MCFOOTER,MCOUNT
 K MCARRB,MCARDOB,MCARWARD,MCARDTM,MCARHDR,MCARZ,MCARGDT,MCARGDT2,MCDL,MCLNG
 D KVAR^VADPT
 Q
PRED S (DLCOSB,FEV1,FRC,FVC,FEF2575,PF,RV,TLC,VC,MVV,CTLC,CVC,CFRC,CRV,CFVC,CFEV1,CPF,CFEF2575,CMVV,CDLCOSB,ACT,COHB)=""
 S MCPV=$$MCPV(+MDR)
 I ('HT)!('WT)!('AGE)!(MCPV=0) Q
 D PREDS,MCRACE Q
MCRACE S MCRCR="",MCRC=$G(^MCAR(700.1,MCPV,"RC")) Q:MCRC=""
 S MCRCR=$G(^MCAR(700,+MDR,17)) Q:MCRCR=""  Q:$P(MCRCR,U,5)'="Y"
 N MCRAC,MCMRAC S MCMRAC=0
 S:RACE["ASIAN" MCMRAC=MCMRAC+1
 S:RACE["BLACK" MCMRAC=MCMRAC+1
 I MCMRAC>1 S MCRAC=$P(MCRCR,U,7),MCRAC=$S(MCRAC="A":"O",1:MCRAC)
 S MCRCR=$S(RACE["BLACK":"B",RACE["ASIAN":"O",1:"") Q:MCRCR=""
 I MCMRAC>1 S MCRCR=MCRAC Q:MCRCR=""
 F I=1:1:6 I $P(MCRC,U,I) S J=$P(MCRC,U,I) D:J
 .Q:'$D(^MCAR(700.2,J,0))  S J=$P(^(0),U,1)
 .S @("MCRC"_I)="S PRED="_J
 K J G ORIENTAL:MCRCR="O" K MCRC2,MCRC6
 I '$D(MCRC1),'$D(MCRC3),'$D(MCRC4),'$D(MCRC5) Q
 S:$D(MCRC1) MCRCN="TLC,VC,FVC,FEV1" S:$D(MCRC3) MCRCN=MCRCN_",FRC,RV" S:$D(MCRC4) MCRCN=MCRCN_",FEF25-75" S:$D(MCRC5) MCRCN=MCRCN_",MVV" S:$E(MCRCN,1)="," MCRCN=$E(MCRCN,2,35)
 G NOTE
SETNODE(NODE,VALUE) ;Set the node with the string
 S MDLNE=MDLNE+1,@NODE@(MDLNE,0)=VALUE
 Q
ORIENTAL I '$D(MCRC2),'$D(MCRC6) K MCRC1,MCRC3,MCRC4,MCRC5 Q
 S:$D(MCRC2) MCRC1=MCRC2 S:$D(MCRC6) MCRC5=MCRC6 K MCRC3,MCRC4,MCRC6 S MCRCN="TLC,VC,FVC,FEV1,MVV"
NOTE S MCRCN="NOTE: Race Correction on predicted values: "_MCRCN
 I $G(MCMRAC)>1 S MCRCN=MCRCN_$S(MCRCR="O":" - ASIAN",1:" - BLACK")
 Q
CONFID(MCPV,VALUE) ;
 Q $P(^MCAR(700.2,^MCAR(700.1,MCPV,VALUE),0),U,5)
PREDV(MCPV,VALUE)       ;
 N EXPRESS,FORMULA,IEN,RESULT
 S IEN=+$P($G(^MCAR(700.1,MCPV,VALUE)),U)
 S FORMULA=$P($G(^MCAR(700.2,IEN,0)),U)
 S RESULT=""
 I FORMULA]"" S EXPRESS="S RESULT="_FORMULA X EXPRESS
 Q $S(RESULT]"":RESULT,1:"")
MCPV(MCDA) ; Get the Predicted Value entry
 Q $S($D(^MCAR(700,MCDA,"PV")):^("PV"),1:0)
PREDS S BSA=+$$BSA(HT,WT),I="DLCOSB",DLCOSB=$$PREDV(MCPV,"DLCOSB"),CDLCOSB=$$CONFID(MCPV,"DLCOSB")
 S FEV1=$$PREDV(MCPV,"FEV1"),CFEV1=$$CONFID(MCPV,"FEV1")
 S FRC=$$PREDV(MCPV,"FRC"),CFRC=$$CONFID(MCPV,"FRC")
 S FVC=$$PREDV(MCPV,"FVC"),CFVC=$$CONFID(MCPV,"FVC")
 S FEF2575=$$PREDV(MCPV,"FEF2575"),CFEF2575=$$CONFID(MCPV,"FEF2575")
 S PF=$$PREDV(MCPV,"PF"),CPF=$$CONFID(MCPV,"PF")
 S RV=$$PREDV(MCPV,"RV"),CRV=$$CONFID(MCPV,"RV")
 S TLC=$$PREDV(MCPV,"TLC"),CTLC=$$CONFID(MCPV,"TLC")
 S VC=$$PREDV(MCPV,"VC"),CVC=$$CONFID(MCPV,"VC")
 S MVV=$$PREDV(MCPV,"MVV"),CMVV=$$CONFID(MCPV,"MVV")
 Q
BSA(HT,WT) ; Compute BSA
 D COMPUTE^MCARBSA
 Q X
ETHN(MCRSTR,MCETH) ; Get the Race and Ethnicity arrays and concat with Race
 N MCCTR,MCSTR,MCLP,MCX,Y
 S MCCTR=+$G(MCETH(12)),MCSTR=""
 I MCCTR F MCLP=1:1:MCCTR S MDX=$G(MCETH(12,MCLP)) S:$P(MDX,"^",2)'="" MCSTR=MCSTR_$S(MCSTR="":"",1:", ")_$P(MDX,"^",2)
 S Y=$S(MCSTR'="":MCSTR,1:MCRSTR)
 Q Y