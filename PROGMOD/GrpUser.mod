MODULE GrpUser

! 2010.03.24  / ABB Robert Goebelt 
CONST string st_Version_GrpUser:="5.0.1 GrpUser";


!predifined data section -do not delete

PERS num n_GrpLang:=1;

!user section

TASK PERS loaddata ld_XX:=[0,[0,0,0],[1,0,0,0],0,0,0];

TASK PERS tooldata t_XX:=[TRUE,[[0,0,0],[1,0,0,0]],[0,[0,0,0],[1,0,0,0],0,0,0]];

CONST grp_pos Aus:=[1];
CONST grp_pos Ein:=[2];
CONST grp_pos Auf:=[1];
CONST grp_pos Zu:=[2];
CONST grp_pos Off:=[1];
CONST grp_pos On:=[2];
CONST grp_pos Ret:=[1];
CONST grp_pos Adv:=[2];
CONST grp_pos Opn:=[1];
CONST grp_pos Cls:=[2];

ENDMODULE
