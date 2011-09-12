GMRVED5 ;HIRMFO/YH-VITALS MEASUREMENTS APPLICATION PROGRAM INTERFACE EDIT TMP ;1/17/97
 ;;4.0;Vitals/Measurements;;Apr 25, 1997
EN2(DFN,GMRVDATE) ;V/M CORRECTION FOR A GIVEN DATE/TIME AND A GIVEN DFN
 G:DFN'>0!(GMRVDATE'>0) Q2 S GMROUT=0 D DATACK^GMRVEE0 I GMROUT W !,$C(7),"NO DATA FOR THIS DATE",! G Q2
 D EN3^GMRVEE0
Q2 K DFN,GMRVDATE,GMRVDT,GMRVITY,GMROUT Q
EN3(DFN,GMRVIDT) ;V/M DISPLAY FOR A GIVEN PATIENT AND A GIVEN TIME
 ;INPUT VARIABLES:
 ;   DFN = PATIENT FILE POINTER
 ;   GMRVIDT = DATE/TIME OF VITAL MEASUREMENTS FOR A PATIENT IN THE VA FILEMAN'S CONVENTIONAL INTERNAL FORMAT
 Q:DFN'>0!(GMRVIDT'>0)
 S GMROUT=0,GMRSTR="T;P;R;BP;HT;WT;" D DSPOV^GMRVED4
 I $E(GMRSTR(0),1,20)[$E(GMRSTR,1,20) W !,"No Vital Measurement data for this patient at this date/time",!
 K GDA,GDATA,GCT,GDT,GLAST,GMROUT,GMROV,GMRP,GMRSTR,GMRTYPE,GMRVIDT,GMRX,GTYPE Q
EN4(DFN,GMRVHLOC,GMRVIDT) ;ENTER/EDIT SINGLE PATIENT VITAL/MEASUREMENT
 ;INPUT VARIABLES
 ;DFN - PATIENT FILE POINTER
 ;GMRVHLOC - HOSPITAL LOCATION (44) POINTER
 ;GMRVIDT - VA FILEMAN'S CONVENTIONAL INTERNAL DATE/TIME FORMAT
 S GMROUT=0,GMRENTY=10,GMRSTR="T;P;R;BP;HT;WT;",GMREDB="P1" D EN3^GMRVED0
 K GMRVIEN,GMRSTR,GMROUT Q