FSCQSN ;SLC/STAFF-NOIS Query Search Nonindexed ;8/8/98  21:28
 ;;1.1;NOIS;;Sep 06, 1998
 ;
EX ; from FSCQS
 I CODE["7100.6" D PEX Q
 I LIST=1!(LIST=0) D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^TMP("FSC USELIST",$J,CALL)) Q:CALL<1  D
 ..I $L($P($G(^FSCD("CALL",CALL,NODE)),U,PIECE)) X ACTION
 I LIST="" D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^FSCD("CALL",CALL)) Q:CALL<1  D
 ..I $L($P($G(^FSCD("CALL",CALL,NODE)),U,PIECE)) X ACTION
 Q
NEX ; from FSCQS
 I CODE["7100.6" D PNEX Q
 I LIST=1!(LIST=0) D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^TMP("FSC USELIST",$J,CALL)) Q:CALL<1  D
 ..I '$L($P($G(^FSCD("CALL",CALL,NODE)),U,PIECE)) X ACTION
 I LIST="" D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^FSCD("CALL",CALL)) Q:CALL<1  D
 ..I '$L($P($G(^FSCD("CALL",CALL,NODE)),U,PIECE)) X ACTION
 Q
OTHER ; from FSCQS
 I CODE["7100.6" D POTHER Q
 S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2),CHECK="CVALUE"_COND_$S(VALUE=+VALUE:VALUE,1:""""_$$UP^XLFSTR(VALUE)_"""")
 I LIST=1!(LIST=0) D  Q
 .S CALL=0 F  S CALL=$O(^TMP("FSC USELIST",$J,CALL)) Q:CALL<1  D
 ..S CVALUE=$$UP^XLFSTR($P($G(^FSCD("CALL",CALL,NODE)),U,PIECE)) I $L(CVALUE),@CHECK X ACTION
 I LIST="" D  Q
 .S CALL=0 F  S CALL=$O(^FSCD("CALL",CALL)) Q:CALL<1  D
 ..S CVALUE=$$UP^XLFSTR($P($G(^FSCD("CALL",CALL,NODE)),U,PIECE)) I $L(CVALUE),@CHECK X ACTION
 Q
 ;
PEX ;
 N IEN
 S CODE=$P(CODE,",",2)
 I LIST=1!(LIST=0) D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^TMP("FSC USELIST",$J,CALL)) Q:CALL<1  D
 ..S IEN=+$G(^FSCD("CALL USER","AUC",DUZ,CALL)) I 'IEN Q
 ..I $L($P($G(^FSCD("CALL USER",IEN,NODE)),U,PIECE)) X ACTION
 I LIST="" D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^FSCD("CALL USER","AUC",DUZ,CALL)) Q:CALL<1  D
 ..S IEN=+$G(^FSCD("CALL USER","AUC",DUZ,CALL)) I 'IEN Q
 ..I $L($P($G(^FSCD("CALL USER",IEN,NODE)),U,PIECE)) X ACTION
 Q
PNEX ;
 N IEN
 S CODE=$P(CODE,",",2)
 I LIST=1!(LIST=0) D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^TMP("FSC USELIST",$J,CALL)) Q:CALL<1  D
 ..S IEN=+$G(^FSCD("CALL USER","AUC",DUZ,CALL))
 ..I '$L($P($G(^FSCD("CALL USER",IEN,NODE)),U,PIECE)) X ACTION
 I LIST="" D  Q
 .S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2)
 .S CALL=0 F  S CALL=$O(^FSCD("CALL USER","AUC",DUZ,CALL)) Q:CALL<1  D  ; *** only checking calls in call user file, not all calls
 ..S IEN=+$G(^FSCD("CALL USER","AUC",DUZ,CALL))
 ..I '$L($P($G(^FSCD("CALL USER",IEN,NODE)),U,PIECE)) X ACTION
 Q
POTHER ;
 N IEN
 S CODE=$P(CODE,",",2)
 S NODE=+$P(CODE,";"),PIECE=$P(CODE,";",2),CHECK="CVALUE"_COND_$S(VALUE=+VALUE:VALUE,1:""""_$$UP^XLFSTR(VALUE)_"""")
 I LIST=1!(LIST=0) D  Q
 .S CALL=0 F  S CALL=$O(^TMP("FSC USELIST",$J,CALL)) Q:CALL<1  D
 ..S IEN=+$G(^FSCD("CALL USER","AUC",DUZ,CALL)) I 'IEN Q
 ..S CVALUE=$$UP^XLFSTR($P($G(^FSCD("CALL USER",IEN,NODE)),U,PIECE)) I $L(CVALUE),@CHECK X ACTION
 I LIST="" D  Q
 .S CALL=0 F  S CALL=$O(^FSCD("CALL USER","AUC",DUZ,CALL)) Q:CALL<1  D
 ..S IEN=+$G(^FSCD("CALL USER","AUC",DUZ,CALL)) I 'IEN Q
 ..S CVALUE=$$UP^XLFSTR($P($G(^FSCD("CALL USER",IEN,NODE)),U,PIECE)) I $L(CVALUE),@CHECK X ACTION
 Q