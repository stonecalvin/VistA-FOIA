NURSAPFU ;HIRMFO/RM/MD,FT-SITE PARAMETER FILE UPDATE ;4/18/96  15:14
 ;;4.0;NURSING SERVICE;;Apr 25, 1997
 ; THIS ROUTINE CALLED BY OPTION NURSFL-SITE
 Q:'$D(^DIC(213.9,1,"OFF"))  Q:$P(^DIC(213.9,1,"OFF"),"^",1)=1
 I '$D(^DIC(213.9,1)) D ADDNEW
 S DA=1,DR="2;8;7.1;7.2;7.3;11;12;S:'(DUZ(0)[""@"") Y=""@1"";3;4;@1",DIE="^DIC(213.9," D ^DIE K DIE
 D ^NURSKILL
 Q
ADDNEW ; ADD NEW PARAMETERS FOR THIS SITE
 S $P(^DIC(213.9,1,0),"^",1)="ONE",^DIC(213.9,1,"OFF")=0,DIK="^DIC(213.9," D IXALL^DIK
 Q