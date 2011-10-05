VAFHADT4 ;ALB/RJS - HL7 ADT BREAKOUT OF VAFHADT1 - APRIL 13,1995
 ;;5.3;Registration;**91**;Jun 06, 1996
 ;
 ;This routine was broken out of routine VAFHADT1 and 
 ;contains numerous functions and procedures used by that routine
 ;
INSERT(DFN,EVENT,VAFHDT,PIVOT) ;
 I $$LASTONE(VAFHDT) D BLDMSG^VAFHADT2(DFN,EVENT,VAFHDT,"05","",PIVOT) Q
 D BLDMSG^VAFHADT2(DFN,EVENT,VAFHDT,"04","",PIVOT)
 I $$RECORD(VAFHDT)["ADMISSION" D BOTH(DFN,VAFHDT,PIVOT) Q
 I $$RECORD(VAFHDT)["TRANSFER"&($$RECORD(VAFHDT)["SPECIALTY") D BOTH(DFN,VAFHDT,PIVOT) Q
 I $$RECORD(VAFHDT)["TRANSFER" D TRANSFER(DFN,VAFHDT,PIVOT) Q
 I $$RECORD(VAFHDT)["SPECIALTY" D SPECLTY(DFN,VAFHDT,PIVOT)
 Q
 ;
 ;
DELETE(DFN,EVENT,VAFHDT,PIVOT,EVTYPE) ;
 I $$LASTONE(VAFHDT) D BLDMSG^VAFHADT2(DFN,EVENT,VAFHDT,"05","",PIVOT) Q
 D BLDMSG^VAFHADT2(DFN,EVENT,VAFHDT,"04","",PIVOT)
 I EVTYPE=2.2 D BOTH(DFN,VAFHDT,PIVOT) Q
 I EVTYPE=2.6 D SPECLTY(DFN,VAFHDT,PIVOT) Q
 I EVTYPE=3.2 D BOTH(DFN,VAFHDT,PIVOT) Q 
 I EVTYPE=3.6 D SPECLTY(DFN,VAFHDT,PIVOT) Q 
 Q
 ;
 ;
BOTH(DFN,VAFHDT,PIVOT) ;
 N FINISHED,FOUND1,FOUND2,RECORD
 S (FINISHED,FOUND1,FOUND2)=0
 F  S VAFHDT=$O(HISTORY(VAFHDT)) Q:VAFHDT=""!(FINISHED)  D
 . S IEN=""
 . F  S IEN=$O(HISTORY(VAFHDT,IEN)) Q:IEN=""!(FINISHED)  D
 . . S RECORD=HISTORY(VAFHDT,IEN)
 . . I RECORD["TRANSFER" S FOUND1=1
 . . I RECORD["SPECIALTY" S FOUND2=1
 . . I FOUND1&(FOUND2) S FINISHED=1  Q
 . . I (RECORD["LASTONE") D BLDMSG^VAFHADT2(DFN,"A08",VAFHDT,"05",IEN,PIVOT) S FINISHED=1 Q
 . . D BLDMSG^VAFHADT2(DFN,"A08",VAFHDT,"04","",PIVOT)
 Q
 ;
 ;
TRANSFER(DFN,VAFHDT,PIVOT) ;
 N FINISHED,RECORD S FINISHED=0
 F  S VAFHDT=$O(HISTORY(VAFHDT)) Q:VAFHDT=""!(FINISHED)  D
 . S IEN=""
 . F  S IEN=$O(HISTORY(VAFHDT,IEN)) Q:IEN=""!(FINISHED)  D
 . . S RECORD=HISTORY(VAFHDT,IEN)
 . . I RECORD["TRANSFER" S FINISHED=1 Q
 . . I (RECORD["LASTONE") D BLDMSG^VAFHADT2(DFN,"A08",VAFHDT,"05",IEN,PIVOT) S FINISHED=1 Q
 . . D BLDMSG^VAFHADT2(DFN,"A08",VAFHDT,"04","",PIVOT)
 Q
 ;
 ;
SPECLTY(DFN,VAFHDT,PIVOT) ;
 N FINISHED,RECORD S FINISHED=0
 F  S VAFHDT=$O(HISTORY(VAFHDT)) Q:VAFHDT=""!(FINISHED)  D
 . S IEN=""
 . F  S IEN=$O(HISTORY(VAFHDT,IEN)) Q:IEN=""!(FINISHED)  D
 . . S RECORD=HISTORY(VAFHDT,IEN)
 . . I RECORD["SPECIALTY" S FINISHED=1 Q
 . . I (RECORD["LASTONE") D BLDMSG^VAFHADT2(DFN,"A08",VAFHDT,"05",IEN,PIVOT) S FINISHED=1 Q
 . . D BLDMSG^VAFHADT2(DFN,"A08",VAFHDT,"04","",PIVOT)
 Q
 ;
ENTIRE(PIVOT) ;
 N VAFHDT,IEN,RECORD
 S VAFHDT=""
 F  S VAFHDT=$O(HISTORY(VAFHDT)) Q:VAFHDT=""  D
 . S IEN="",EVCODE="04"
 . F  S IEN=$O(HISTORY(VAFHDT,IEN)) Q:IEN=""  D
 . . S RECORD=HISTORY(VAFHDT,IEN)
 . . I RECORD["LASTONE" S EVCODE="05"
 . . I RECORD["ADMISSION" D BLDMSG^VAFHADT2(DFN,"A01",VAFHDT,"05","",PIVOT) Q
 . . I RECORD["TRANSFER" D BLDMSG^VAFHADT2(DFN,"A02",VAFHDT,EVCODE,"",PIVOT) Q
 . . I RECORD["SPECIALTY" D BLDMSG^VAFHADT2(DFN,"A08",VAFHDT,EVCODE,"",PIVOT) Q
 . . I RECORD["DISCHARGE" D BLDMSG^VAFHADT2(DFN,"A03",VAFHDT,EVCODE,IEN,PIVOT) Q
 Q
 ;
 ;
LASTONE(VAFHDT) ;
 N IEN,RESULT,NEXTDATE S RESULT=0
 S NEXTDATE=$O(HISTORY(VAFHDT))
 I $G(NEXTDATE)="" S RESULT=1 G LASTEND
 S IEN=$O(HISTORY(VAFHDT,""))
 I $G(IEN)'="" D
 . I HISTORY(VAFHDT,IEN)["LASTONE" S RESULT=1
LASTEND ;
 Q RESULT
 ;
 ;
RECORD(VAFHDT) ;
 N IEN
 S IEN=$O(HISTORY(VAFHDT,""))
 Q HISTORY(VAFHDT,IEN)
 ;
 ;
ADMDATE(IEN) ;
 N RESULT
 S RESULT=$P($G(^DGPM(IEN,0)),"^",1)
 Q:$G(RESULT)="" 0
 Q RESULT
HISTORY ;
 N VAFHDT,IEN
 S VAFHDT=""
 F  S VAFHDT=$O(HISTORY(VAFHDT)) Q:VAFHDT=""  D
 . S IEN=""
 . F  S IEN=$O(HISTORY(VAFHDT,IEN)) Q:IEN=""  D
 . . W !,VAFHDT," ---> ",HISTORY(VAFHDT,IEN)
 Q
 ;
ADDING(DFN,EVENT,VAFHDT,PIVOT,PIVCHK) ;
 I PIVCHK'>0 D ENTIRE(PIVOT) Q
 D INSERT(DFN,EVENT,VAFHDT,PIVOT)
 Q
 ;
PIVINIT(DFN,VAFHDATE,ADMSSN) ;
 S PIVCHK=$$PIVCHK^VAFHPIVT(DFN,VAFHDATE,1,ADMSSN_";DGPM(")
 S PIVOT=$$PIVNW^VAFHPIVT(DFN,VAFHDATE,1,ADMSSN_";DGPM(")
 Q
 ;
SETVARS(NODE,DGPMDA) ;
 S TYPE=$P(NODE,"^",2),VAFHDT=$P(NODE,"^",1),ADMSSN=$P(NODE,"^",14),IEN=DGPMDA Q
 ;
MOVETYPE(NODE) ;
 N TYPE
 S TYPE=$P(NODE,"^",18)
 I TYPE>0 Q TYPE
 Q 0