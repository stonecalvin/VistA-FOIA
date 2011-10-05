TIULQ2 ; SLC/JER - Record Extract For Upload Event Display
 ;;1.0;TEXT INTEGRATION UTILITIES;;Jun 20, 1997
EXTRACT(TIUDA,TIUROOT,TIUERR,DR,TIULINE,TIUTEXT) ; Gets record & addenda
 N DA,DIC,DIQ,TIULQ,X,Y
 S TIUROOT=$G(TIUROOT,"^TMP(""TIULQ"",$J)")
 S DA=TIUDA,DIC=8925,DIQ="TIULQ",DIQ(0)="IE"
 I $G(DR)']"" S DR=".01:.1;1201:1701"
 D EN^DIQ1
 I '$D(TIULQ) S TIUERR="1^ Record Extract Failed"
 M @TIUROOT@(TIUDA)=TIULQ(8925,TIUDA)
 D PROBLEMS(DA,+$G(TIULINE))
 I +$G(TIUTEXT) D TEXT(TIUDA,+$G(TIULINE),TIUDA)
 Q
PROBLEMS(TIUDA,TIUJ) ; Get associated problems
 N TIUI,TIUP,TIUPROB,TIUC,TIUX,DR,DIC,DIQ S TIUI=0
 F  S TIUI=$O(^TIU(8925.9,"B",+TIUDA,TIUI)) Q:+TIUI'>0  D
 . S DA=TIUI,DR=".02;.05",DIC="^TIU(8925.9,",DIQ="TIUPROB"
 . D EN^DIQ1 Q:$D(TIUPROB)'>9
 . S TIUC=+$G(TIUC)+1
 . S TIUP=$$MIXED^TIULS($G(TIUPROB(8925.9,TIUI,.05)))
 . S TIUX=$$SETSTR^VALM1($J(TIUC,2)_".",$G(TIUX),1,3)
 . S TIUX=$$SETSTR^VALM1(TIUP,$G(TIUX),5,35)
 . S TIUP=$G(TIUPROB(8925.9,TIUI,.02))
 . S TIUX=$$SETSTR^VALM1(TIUP,$G(TIUX),40,6)
 . S @TIUROOT@(TIUDA,"PROBLEM",(TIUJ+TIUC),0)=TIUX
 Q
TEXT(TIUDA,TIUJ,TIUDAD) ; Get each component
 N TIUKID,TIUDADT,TIUI S TIUI=0
 F  S TIUI=$O(^TIU(8925,+TIUDA,"TEXT",TIUI)) Q:+TIUI'>0  D
 . S TIUJ=+$G(TIUJ)+1
 . S @TIUROOT@(TIUDAD,"TEXT",TIUJ,0)=$G(^TIU(8925,+TIUDA,"TEXT",TIUI,0))
 S @TIUROOT@(TIUDAD,"TEXT",0)="^^"_TIUJ_U_TIUJ_U_DT_"^^"
 ; Iterate through children, and get their text fields
 S TIUKID=0
 F  S TIUKID=$O(^TIU(8925,"DAD",+TIUDA,TIUKID)) Q:+TIUKID'>0  D
 . I +$$ISADDNDM^TIULC1(TIUKID) D
 . . N TIUADRT
 . . I TIUROOT[")" S TIUADRT=$P(TIUROOT,")")_","_TIUDAD_",""ZADD"")"
 . . E  S TIUADRT=TIUROOT_"("_TIUDAD_",""ZADD"")"
 . . D EXTRACT(TIUKID,TIUADRT,.TIUERR,DR,.TIUJ) I 1
 . E  D TEXT(TIUKID,.TIUJ,TIUDAD)
 Q