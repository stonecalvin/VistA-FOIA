ORCONV0 ; SLC/MKB - Convert protocols/menus to Dialogs cont ;9/15/97  15:41
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**14**;Dec 17, 1997
OR ; -- ORZ protocols
 N ORGWP,ORGT,ORGX S ORGX=$G(^ORD(101,PITEM,20))
 S:$O(^ORD(101,PITEM,101.0431,0))!(ORGX["^ORGWP") ORGWP=1
 S:ORGX["^ORGT" ORGT=1
DLG ; -- dialog type protocols
 N X,XQORM,ORPOS,XUTL,PTERM,PRMT,DA,NODE,MODE,ORDG,PKG,DTEXT,DFLT,OI,TXT,LBL,PARAM,ORSEQ
 S DITEM=$$DIALOG^ORCONVRT(PITEM) G:'DITEM DLG^ORCONVRT
 S PKG=+$O(^DIC(9.4,"C","OR",0))
 S ORDG=$S($D(^ORD(101,"AD",+$O(^ORD(101,"B","OR GUA ACTV DISPLAY GROUP",0)),PITEM)):"ACT",$G(ORGWP)!$G(ORGT):"OTHER",1:"NURS"),ORDG=+$O(^ORD(100.98,"B",ORDG,0))_U_ORDG ; generic order
 S X=^ORD(101.41,DITEM,0),DTEXT=$P(X,U,2)
 S X=X_"^^D^"_+ORDG_U_$S('+$G(^ORD(101,PITEM,101.01)):2,1:0)_U_PKG_"^1^0"
 S:PKG ^ORD(101.41,"APKG",PKG,DITEM)=""
D0 S ^ORD(101.41,DITEM,0)=X I $G(ORGWP)!$G(ORGT) D  G D2
 . S PRMT=$S($G(ORGWP):"OR GTX WORD PROCESSING 1",1:"OR GTX FREE TEXT"),PRMT=$O(^ORD(101.41,"AB",PRMT,0))
 . S DA=$$NEXT^ORCONVRT(DITEM),^ORD(101.41,DITEM,10,DA,0)="1^"_PRMT_"^^Order: ^^1",^(2)=1
 . S ^ORD(101.41,DITEM,10,"B",1,DA)="",^ORD(101.41,"AD",PRMT,DITEM,DA)="",^ORD(101.41,DITEM,10,"D",PRMT,DA)="",^ORD(101.41,DITEM,10,"ATXT",1,DA)=""
 . I $G(ORGWP) M ^ORD(101.41,DITEM,10,DA,8)=^ORD(101,PITEM,101.0431)
 S XQORM=PITEM_";ORD(101," D XREF^XQORM S ORSEQ=1
D1 S ORPOS=0 F  S ORPOS=$O(^XUTL("XQORM",XQORM,ORPOS)) Q:ORPOS'>0  D
 . S XUTL=$G(^XUTL("XQORM",XQORM,ORPOS,0)),PTERM=+$P(XUTL,U,2) Q:'PTERM
 . I $P($G(^ORD(101,PTERM,0)),U,4)="A" S NODE=$G(^(20)) D  Q
 . . S X=$F(NODE,"ORTO=") Q:'X
 . . S NODE=$E(NODE,X,999),X=$P(NODE,"""",4) Q:'$L(X)
 . . S ORDG=+$O(^ORD(100.98,"B",X,0))
 . I $P($G(^ORD(101,PTERM,0)),U,4)'="T" S ^ORD(100.99,1,101.41,PITEM,0)=PITEM_"^Incomplete dialog entry - unrecognizable item(s) in protocol." Q
 . ; ** Modifying action -> Ask on Condition
 . S PRMT=$$PROMPT(PTERM) G:'PRMT PROMPT^ORCONVRT
 . I $O(^ORD(101.41,DITEM,10,"D",+PRMT,0)) D DUPL^ORCONVRT Q  ;duplicate
 . S NODE=$G(^ORD(101,PITEM,10,+XUTL,1)),MODE=$P(NODE,U,4)
 . S TXT=$S($L($P(NODE,U)):$P(NODE,U)_": ",1:$P(PRMT,U,2)),ORSEQ=ORSEQ+1
 . S DA=$$NEXT^ORCONVRT(DITEM,+XUTL),^ORD(101.41,DITEM,10,DA,0)=ORSEQ_U_+PRMT_U_U_TXT_U_U_(MODE["R")_U_U_(MODE["E")
 . S ^ORD(101.41,DITEM,10,DA,2)=ORSEQ_"^^^"_$S(MODE["S":"",1:TXT)_"^^"_$S(MODE["\":1,1:""),^ORD(101.41,DITEM,10,"ATXT",ORSEQ,DA)=""
 . S:$L($P(NODE,U,3)) ^ORD(101.41,DITEM,10,DA,1)=$P(NODE,U,3) ; help msg
 . S DFLT=$P(NODE,U,2) S:$L(DFLT) ^ORD(101.41,DITEM,10,DA,7)="S Y="""_$$INTERNAL(DFLT,+PRMT)_""""
 . I $O(^ORD(101,PTERM,101.0431,0)) M ^ORD(101.41,DITEM,10,DA,8)=^ORD(101,PTERM,101.0431) ; default WP text
 . S ^ORD(101.41,DITEM,10,"B",ORSEQ,DA)="",^ORD(101.41,"AD",+PRMT,DITEM,DA)="",^ORD(101.41,DITEM,10,"D",+PRMT,DA)=""
D2 ; Add Start & Stop Dates
 S DA=$$NEXT^ORCONVRT(DITEM),ORPOS=$O(^ORD(101.41,DITEM,10,"B","?"),-1)+1
 S PRMT=$O(^ORD(101.41,"AB","OR GTX START DATE/TIME",0))
 S ^ORD(101.41,DITEM,10,DA,0)=ORPOS_U_PRMT_"^^^^1^^1^RC",^(1)="Enter the date/time to begin this order",^(6)="D FTDHELP^ORCD",^(7)="S Y=""NOW"""
 S ^ORD(101.41,DITEM,10,"B",ORPOS,DA)="",^ORD(101.41,DITEM,10,"D",PRMT,DA)="",^ORD(101.41,"AD",PRMT,DITEM,DA)=""
 S DA=$$NEXT^ORCONVRT(DITEM),ORPOS=$O(^ORD(101.41,DITEM,10,"B","?"),-1)+1
 S PRMT=$O(^ORD(101.41,"AB","OR GTX STOP DATE/TIME",0)),PARAM=$G(^ORD(100.99,1,2))
 S ^ORD(101.41,DITEM,10,DA,0)=ORPOS_U_PRMT_"^^^^^^"_$S('$P(PARAM,U,9):1,1:"")_"^RC",^(1)="Enter the date/time to end this order",^(6)="D FTDHELP^ORCD"
 S ^ORD(101.41,DITEM,10,DA,5)="I $$FTDCOMP^ORCD(""START DATE/TIME"",""STOP DATE/TIME"","">"") K DONE W $C(7),!,""   Cannot end before start date/time!"",!"
 S ^ORD(101.41,DITEM,10,"B",ORPOS,DA)="",^ORD(101.41,DITEM,10,"D",PRMT,DA)="",^ORD(101.41,"AD",PRMT,DITEM,DA)=""
 S NODE=$G(^ORD(101,PITEM,20)),X=$F(NODE,"ORGSTOP=") I X S ^ORD(101.41,DITEM,10,DA,7)="S Y="""_$$VALUE^ORCONVRT(NODE,X)_"""",$P(^(0),U,8)=1 G D3
 I $P(PARAM,U,9),$P(PARAM,U,10) S ^ORD(101.41,DITEM,10,DA,7)="S Y=""T+"_$P(PARAM,U,10)_""""
D3 ; Create orderable item from Item Text
 Q:$G(ORGWP)  Q:$G(ORGT)  ; text only orders - no OI to create
 S OI=$$PTR^ORCD("OR GTX ORDERABLE ITEM"),DA=$$NEXT^ORCONVRT(DITEM)
 S ^ORD(101.41,DITEM,10,DA,0)="1^"_OI_"^^Order: ^^1^^1",^(2)=1
 S ^ORD(101.41,DITEM,10,"B",1,DA)="",^ORD(101.41,"AD",OI,DITEM,DA)="",^ORD(101.41,DITEM,10,"D",OI,DA)="",^ORD(101.41,DITEM,10,"ATXT",1,DA)=""
 S X=$G(^ORD(101,PITEM,15)),LBL=$F(X,"ORGLABEL=")
 I LBL S X=$P($E(X,LBL,$L(X)),"""",2) S:$L(X) DTEXT=X
 S ^ORD(101.41,DITEM,10,DA,7)="S Y="_$$ORDITM(DTEXT,ORDG)
 Q
 ;
PROMPT(PIFN) ; -- Returns ifn of [new] prompt in Dialog file
 N DIFN,NODE,X0 S DIFN=$$DIALOG^ORCONVRT(PIFN) Q:'DIFN
 S NODE=$G(^ORD(101,PIFN,101.04))
 S $P(^ORD(101.41,DIFN,0),U,4)="P",^(1)=$P(NODE,U)_U_$P(NODE,U,5),X0=$G(^(0))
 Q DIFN_U_$P(X0,U,2)
 ;
INTERNAL(VALUE,IFN) ; -- Return internal form of VALUE for prmt IFN
 N DATATYPE,DOMAIN,X,Y,ROOT S Y=""
 S X=$G(^ORD(101.41,IFN,1)),DATATYPE=$P(X,U),DOMAIN=$P(X,U,2)
 I "DFRNW"[DATATYPE S Y=VALUE
 I DATATYPE="Y" S Y=$S("YESyes"[VALUE:1,1:0)
 I DATATYPE="P" D
 . I +VALUE=VALUE S Y=VALUE Q
 . Q:'$L(DOMAIN)  S ROOT=$S(+DOMAIN:$G(^DIC(+DOMAIN,0,"GL")),1:U_DOMAIN)
 . S Y=$O(@(ROOT_"""B"","""_$E(VALUE,1,30)_""",0)"))
 I DATATYPE="S" D
 . N I F I=1:1:$L(DOMAIN,";") S X=$P(DOMAIN,";",I) I X[(":"_VALUE) S Y=$P(X,":") Q
 Q Y
 ;
ORDITM(X,ORDG) ; -- Find/Add orderable item X
 N I,Y,D,DIC,DLAYGO,DA,DR,DIE,ID Q:'$L($G(X)) -1
 F I=$L(X):-1:1 I $E(X,I)?1A S X=$E(X,1,I) Q  ;Strip trailing sp, punct
 S:'$G(ORDG) ORDG=$O(^ORD(100.98,"B","NURS",0))_U_"NURS"
 S D="S."_$P(ORDG,U,2),Y=$O(^ORD(101.43,D,$$UP^XLFSTR(X),0)) Q:Y Y ; found
 S DIC="^ORD(101.43,",DLAYGO=101.43,DIC(0)="LX" D IX^DIC S DA=+Y
 I DA>0 S DIE=DIC,ID=DA_";99ORD",DR="2///^S X=ID;5////"_+ORDG D ^DIE
 Q DA
 ;
SET ; -- extended action type protocols
 N X,PKG,XQORM,ORSEQ,ORP,DA,XUTL
 S DITEM=$$DIALOG^ORCONVRT(PITEM) G:'DITEM DLG^ORCONVRT
 S PKG=+$O(^DIC(9.4,"C","OR",0)),X=$G(^ORD(101.41,DITEM,0))
 S X=X_"^^O^^"_$S('$G(^ORD(101,PITEM,101.01)):2,1:0)_U_PKG
 S ^ORD(101.41,DITEM,0)=X,^(5)="^^^^^0^1"
 S:PKG ^ORD(101.41,"APKG",PKG,DITEM)=""
 S XQORM=PITEM_";ORD(101," D XREF^XQORM
 S ORSEQ=0 F  S ORSEQ=$O(^XUTL("XQORM",XQORM,ORSEQ)) Q:ORSEQ'>0  S XUTL=$G(^(ORSEQ,0)) D
 . Q:'$P(XUTL,U,2)  S ORP=$$ITEM^ORCONVRT($P(XUTL,U,2)) Q:'ORP
 . S DA=$$NEXT^ORCONVRT(DITEM),^ORD(101.41,DITEM,10,DA,0)=ORSEQ_U_ORP
 . S ^ORD(101.41,DITEM,10,"B",ORSEQ,DA)="",^ORD(101.41,DITEM,10,"D",ORP,DA)="",^ORD(101.41,"AD",ORP,DITEM,DA)=""
 Q