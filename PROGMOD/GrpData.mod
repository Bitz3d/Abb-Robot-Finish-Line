MODULE GrpData

!***********************************************************
!* Modul:    Gripperdata for 65R02                         *
!* Location: 3FL5MBG16       65R02                         *
!***********************************************************
!*           Update Section                                *
!*          ================                               *
!* Date:     11/09/2012                                    *
!* Engineer: Rafal Cieslinski /Staudinger                  *
!* Changes:  create                                        *
!*                                                         *
!* gripper 1 function 1 = vacuum                           *
!* gripper 1 function 2 = clamp retract/advance            *
!* gripper 1 function 3 = clamp retract/advance            *
!* gripper 1 function 4 = cylinder retract/advance         *
!*                                                         *
!***********************************************************

! gripper 1 part present
CONST grp_part GR01_B01PP:=["",1,"-B01PP",1,"-B01PP","GR01_AF1_di_24"];
CONST grp_part GR01_B02PP:=["",1,"-B02PP",2,"-B02PP","GR01_AF1_di_25"];
CONST grp_part GR01_B03PP:=["",1,"Typ_F55_F56",3,"-B03PP","GR01_AF1_di_26"];
CONST grp_part GR01_B04PP:=["",1,"Typ_F55_F56_Coopers",4,"-B04PP","GR01_AF1_di_27"]; 
CONST grp_part GR01_B05PP:=["",1,"-B05PP",5,"-B05PP","GR01_AF1_di_28"];
CONST grp_part GR01_B06PP:=["",1,"-B06PP",6,"-B06PP","GR01_AF1_di_29"];

! gripper 1 actuator 1
CONST grp_config Grp_11:=["",1,"Vacuum_11",11,"-Y11B","GR01_AF1_do_01","GR01_AF1_do_00",FALSE,0,0,"","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",3,"-S10P_PreasureSw","GR01_AF1_di_00","-Y11C_24VOn","GR01_AF1_do_02","-S11P_VacuumSW","GR01_AF1_di_22"];

! gripper 1 actuator 2
CONST grp_config Grp_12:=["",1,"Clamp_12_HlodPart",12,"-Y12R","GR01_AF1_do_09","GR01_AF1_do_08",FALSE,0,0,"ZG12-Z1","-B12R1","-B12A1","GR01_AF1_di_02","GR01_AF1_di_03","ZG12-Z2","-B12R2","-B12A2","GR01_AF1_di_04","GR01_AF1_di_05","ZG12-Z3","-B12R3","-B12A3","GR01_AF1_di_06","GR01_AF1_di_07","ZG12-Z4","-B12R4","-B12A4","GR01_AF1_di_08","GR01_AF1_di_09","","","","","","","","","","","","","","","","","","","","",3,"","","","","",""];

! gripper 1 actuator 3
CONST grp_config Grp_13:=["",1,"Clamp_13_OpenBonet",13,"-Y13R","GR01_AF1_do_11","GR01_AF1_do_10",FALSE,0,0,"ZG13-Z1","-B13R1","-B13A1","GR01_AF1_di_10","GR01_AF1_di_11","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",3,"","","","","",""];

! gripper 1 actuator 4
CONST grp_config Grp_14:=["",1,"Cylinder_14_Center_Tabs",14,"-Y14R","GR01_AF1_do_13","GR01_AF1_do_12",FALSE,0,0,"ZG14-Z1","-B14R1","-B14A1","GR01_AF1_di_12","GR01_AF1_di_13","ZG14-Z2","-B14R2","-B14A2","GR01_AF1_di_14","GR01_AF1_di_15","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",3,"","","","","",""];

ENDMODULE
