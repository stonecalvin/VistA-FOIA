FSCTASKA ;SLC/STAFF-NOIS Task Age ;5/4/98  16:54
 ;;1.1;NOIS;;Sep 06, 1998
 ;
AGE ; from option
 ; queued to run after midnite
 I $D(ZTQUEUED) S ZTREQ="@"
 N CALL,DAYSC,DAYSX,END,OK,START,TODAY,TOMORROW,UPDATE
 S TODAY=DT,TOMORROW=$$FMADD^XLFDT(TODAY,1)
 I '$D(^XTMP("FSC UPDATE",0)) K ^XTMP("FSC UPDATE") S ^XTMP("FSC UPDATE",0)=$$FMADD^XLFDT(TODAY,7)_U_TODAY
 S START=$$NOW^XLFDT,^XTMP("FSC UPDATE",-START)=$$FMTE^XLFDT(START)
 S UPDATE=$S($E(START,9,10)>11:TOMORROW,1:TODAY)
 S DAYSC=$P(^FSC("PARAM",1,0),U,6),DAYSX=$P(^(0),U,5)
 S CALL=0 F  S CALL=$O(^FSCD("CALL",CALL)) Q:CALL<1  D
 .D DEL(CALL,DAYSX,DAYSC,.OK) I 'OK Q
 .D UPDATE(CALL,UPDATE)
 .D AFFIL^FSCAFFIL(CALL)
 S ^XTMP("FSCRPC",0)=$$FMADD^XLFDT(TODAY,7)_U_TODAY
 K ^XTMP("FSC LIST DEF") S ^XTMP("FSC LIST DEF",0)=$$FMADD^XLFDT(TODAY,7)_U_TODAY
 S ^XTMP("FSC UPDATE",-START,1)=$$NOW^XLFDT
 D UPDATE^FSCLP()
 S ^XTMP("FSC UPDATE",-START,2)=$$NOW^XLFDT
 D NOTIFY^FSCTASKN
 D MSG
 D CHKALERT^FSCTASKN
 D DELIVERY^FSCTASKN(UPDATE)
 D MRE^FSCMRK,MRA^FSCMRK,MRU^FSCMRK
 D ALL^FSCXPOST
 S END=$$NOW^XLFDT,$P(^XTMP("FSC UPDATE",-START),U,2,3)=$$FMTE^XLFDT(END)_U_$$FMDIFF^XLFDT(END,START,3)
 Q
 ;
DEL(CALL,CANCEL,CLOSE,OK) ;
 S OK=1
 I CANCEL,$P(^FSCD("CALL",CALL,0),U,2)=99,$P(^(0),U,19)>CANCEL D DELETE^FSCUCD(CALL) S OK=0 Q
 ; ***I CLOSE,$P(^FSCD("CALL",CALL,0),U,2)=2,$P(^(0),U,19)>CLOSE,$$MOD($P(^(0),U,8)) D DELETE^FSCUCD(CALL) S OK=0 Q
 Q
 ;
MOD(MOD) ; $$(module) ->  "" or 1 (when old and inactive version)
 N INACTIVE,OLD,ZERO
 S ZERO=$G(^FSC("MOD",+MOD,0)),INACTIVE=$P(ZERO,U,2),OLD=$S($P(ZERO,U,3)=3:1,1:"")
 I INACTIVE,OLD Q 1
 Q ""
 ;
UPDATE(CALL,DATE) ; from FSCTASKU
 N DA,DAYS,DIE,DISC,DR,LASTSTAT,LASTEDIT,LTYPE,MOD,ODISC,OLD,OLTYPE,OPACK,OPACKG,OSISC,OSPISC,OSYS,OVISN,PACK,PACKG,PRIMARY,SISC,SITE,SPEC,SPISC,SYS,VISN
 I '$G(DATE) S DATE=DT
 S DA=CALL,DIE="^FSCD(""CALL"",",DR=""
 S SITE=+$P(^FSCD("CALL",CALL,0),U,5),MOD=+$P(^(0),U,8),SPEC=+$P(^(0),U,9),OSISC=+$P(^(0),U,16),ODISC=+$P(^(0),U,20)
 S LASTSTAT=$P(^FSCD("CALL",CALL,120),U,2)\1,LASTEDIT=$P(^(120),U,4)\1,OLD=$P(^(120),U)\1,OLTYPE=+$P(^(120),U,12),OPACK=+$P(^(120),U,9),OPACKG=+$P(^(120),U,13),OSPISC=+$P(^(120),U,10),OSYS=+$P(^(120),U,19),OVISN=+$P(^(120),U,14)
 S PRIMARY=$P(^FSCD("CALL",CALL,120),U,24) I 'PRIMARY S DR=DR_"101///`"_CALL_";102///@;"
 I LASTSTAT S DAYS=$$FMDIFF^XLFDT(DATE,LASTSTAT,1),DR=DR_"4.4///"_DAYS_";"
 I LASTEDIT S DAYS=$$FMDIFF^XLFDT(DATE,LASTEDIT,1),DR=DR_"4.3///"_DAYS_";"
 I OLD S DAYS=$$FMDIFF^XLFDT(DATE,OLD,1),DR=DR_"4.2///"_DAYS_";"
 I 'SITE S DR=DR_"2.3///@;2.7///@;2.8///@;"
 I SITE S SISC=+$P($G(^FSC("SITE",SITE,0)),U,11),LTYPE=+$P($G(^(0)),U,13),VISN=+$P($G(^(0)),U,12),SYS=+$P($G(^(0)),U,16) D
 .I SISC,SISC'=OSISC S DR=DR_"2.3///`"_SISC_";"
 .I LTYPE,LTYPE'=OLTYPE S DR=DR_"2.7///`"_LTYPE_";"
 .I VISN,VISN'=OVISN S DR=DR_"2.8///`"_VISN_";"
 .I 'VISN,OVISN S DR=DR_"2.8///@;"
 .I SYS,SYS'=OSYS S DR=DR_"2.9///`"_SYS_";"
 .I 'SYS,OSYS S DR=DR_"2.9///@;"
 I 'SPEC S DR=DR_"2.55///@;"
 I SPEC S SPISC=+$P($G(^FSC("SPEC",SPEC,0)),U,16) I SPISC,SPISC'=OSPISC S DR=DR_"2.55///`"_SPISC_";"
 I 'MOD S DR=DR_"2.4///@;3.1///@;3.3///@;"
 I MOD S DISC=+$P($G(^FSC("MOD",MOD,0)),U,5),PACK=+$P($G(^(0)),U,8) D
 .I DISC,DISC'=ODISC S DR=DR_"2.4///`"_DISC_";"
 .I 'DISC,ODISC S DR=DR_"2.4///@;"
 .I PACK D
 ..I PACK'=OPACK S DR=DR_"3.1///`"_PACK_";"
 ..S PACKG=+$P($G(^FSC("PACK",PACK,0)),U,2)
 ..I 'PACKG S DR=DR_"3.3///@;" Q
 ..I PACKG'=OPACKG S DR=DR_"3.3///`"_PACKG_";"
 I '$L(DR) Q
 L +^FSCD("CALL",CALL):20 I '$T Q
 D ^DIE
 L -^FSCD("CALL",CALL)
 Q
 ;
MSG ;
 I $P(^FSC("PARAM",1,0),U,7),$P(^(0),U,7)>DT Q
 N DA,DIE,DR
 S DIE="^FSC(""PARAM"",",DA=1,DR="100///@;101///@" D ^DIE
 Q