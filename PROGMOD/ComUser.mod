%%%
VERSION:1
LANGUAGE:ENGLISH
%%%

MODULE ComUser
!******************************************************************************
!* Module definiert  Variabelen für generellen Ablauf / Kommunikation mit PLC *
!*    Homepositionen / Wobjdata Fahrzeug 0 /Positionen pSyncSwitch,pService   *
!*                                                                            *
!*   Modules defined variables for general process / communication with PLC   *
!*       Home Items / Wobjdata data 0 / positions pSyncSwitch, Pervice        *
!*                                                                            *
!******************************************************************************

! Declaration of const/string for Data nmodul Release
CONST string st_Version_ComUser:="10.2.0 ComUser";

CONST robtarget pService1:=[[-1661.02,-849.54,-57.50],[0.508501,0.489177,0.499951,-0.502176],[-2,-1,1,1],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
CONST robtarget pService2:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
CONST robtarget pService3:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
CONST robtarget pService4:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
CONST robtarget pService5:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
CONST robtarget pService6:=[[-1298.43,-856.99,1691.36],[0.654947,0.632492,-0.411791,0.0377553],[-2,0,1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

PERS jointtarget jpCalibPos1:=[ [ 0, -57.5674, -35.0155, 0.000126942, 50.0001, 69.8649],[9E+09, 9E+09, 9E+09, 9E+09, 9E+09, 9E+09]];
PERS jointtarget jpCalibPos2:=[ [ -101.327, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0]];
PERS jointtarget jpSM1SyncSwitch:=[ [ -101.327, -0.00017097, -3.94134E-05, -4.9503E-05, -5.15174E-05, 6.00231E-05],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
PERS robjoint robjOSM1SyncSwitch:=[-101.327,-0.00017097,-3.94134E-05,-4.9503E-05,-5.15174E-05,6.00231E-05];
PERS extjoint extjOSM1SyncSwitch:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];
PERS bool b_TwoSyncPos:=TRUE;
PERS bool b_ColOption:=TRUE;

! Homeposition wird vom User benutzt/Home positions is used by the user
PERS jointtarget jpHome1:=[[-159.378,19.3459,31.8977,78.6983,44.1548,149.683],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
PERS jointtarget jpHome2:=[[72.0652,-29.6629,-15.5445,-0.00347758,68.608,181.338],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
PERS jointtarget jpHome3:=[[0,0,0,0,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
PERS jointtarget jpHome4:=[[0,0,0,0,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];
PERS jointtarget jpHome5:=[[0,0,0,0,2,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

! Homeposition Original
PERS robjoint robjOHome1:=[-159.378,19.3459,31.8977,78.6983,44.1548,149.683];
PERS extjoint extjOHome1:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];
PERS robjoint robjOHome2:=[72.0652,-29.6629,-15.5445,-0.00347758,68.608,181.338];
PERS extjoint extjOHome2:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];
PERS robjoint robjOHome3:=[0,0,0,0,2,0];
PERS extjoint extjOHome3:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];
PERS robjoint robjOHome4:=[0,0,0,0,2,0];
PERS extjoint extjOHome4:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];
PERS robjoint robjOHome5:=[0,0,0,0,2,0];
PERS extjoint extjOHome5:=[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09];

! string wird nur in der jeweiligen Landessprache befüllt/Home position descriptions
PERS string st_Home_label{5}:=["with empty gripper","with part in gripper","description/Beschreibung","description/Beschreibung","description/Beschreibung"];

! Merker für Benutzte Home/Marker for homes that are used
PERS bool b_HomeInUse{5}:=[TRUE,TRUE,FALSE,FALSE,FALSE];

! Merker für Aktivierte bzw. Ueberwachte Home/Marker for homes that are active
PERS bool b_HomeAkt{5}:=[TRUE,TRUE,FALSE,FALSE,FALSE];

PERS Num n_Job_Mem:=0;      !User defined JobEnable memory
PERS Num n_Type_Mem:=2;     !User defined Typebits memory
PERS Num n_Variant_Mem:=0;  !User defined variant memory
PERS num n_Userbits_Mem:=0; !User defined Userbits memory

 
PROC Main()
!*********************************
!*    Aufruf Automatikbetrieb    *
!*      Automatic  Operation     *
!*********************************
!*      Press> Play to Start     *
!*********************************
InitAutoMode;

ENDPROC !(Main)













PROC InitProduktion()
!***********************************************
!* Program:  Routine for user defined signals, *
!*           variables, routine calls that     *
!*           have to be set to certain         *
!*           state/executed every cycle        *
!* Location: All                               *
!***********************************************
!*           Update Section                    *
!*          ================                   *
!* Date:     16/10/2012                        *
!* Engineer: LRafal Cieslinski / Staudinger    *
!* Changes:  Created                           *
!*                                             *
!***********************************************

SetGroupOP PLC_do_Typbit_01, 16,0;
SetGroupOP PLC_do_Typbit_17, 16,0;
!********************************
!*   Reset all Typbit signals   *
!********************************

SetGroupOP PLC_do_User_01, 16, 0;
SetGroupOP PLC_do_User_17, 16, 0;
!***************************
!*   Reset all User bits   *
!***************************

SetGroupOP PLC_do_Job01_Started, 16, 0;
SetGroupOP PLC_do_Job17_Started, 16, 0;
!*************************************
!*   Reset all Job started signals   *
!*************************************

SetGroupOP PLC_do_Job01_Ready, 16,0;
SetGroupOP PLC_do_Job17_Ready, 16,0;
!***********************************
!*   Reset all Job ready signals   *
!***********************************

ConfL\On;
ConfJ\On;
!********************************
!*   Configuration control on   *
!********************************

IF OpMode()<>OP_AUTO CollClearAll;
!*********************************
!*   Clear all collision zones   *
!*********************************

Reset PLC_do_BF_Meas_Err; 
!*********************************
!*   Clear all BestFit Error     *
!*********************************

ENDPROC !(InitProduktion)


!*******************************************************************************




PROC CheckVariant()
!***********************************************
!* Program:  Get type variant                  *
!* Location: All                               *
!***********************************************
!*               Update Section                *
!*              ================               *
!* Date:     17/08/2013                        *
!* Engineer: Rafal Cieslinski / Staudinger     *
!* Changes:  Created                           *
!*                                             *
!***********************************************

WaitUntil (PLC_di_Typbit_16 + PLC_di_Typbit_17 + PLC_di_Typbit_18 +
           PLC_di_Typbit_19 + PLC_di_Typbit_20 + PLC_di_Typbit_21 +
           PLC_di_Typbit_22 + PLC_di_Typbit_23 + PLC_di_Typbit_24 +
           PLC_di_Typbit_25 + PLC_di_Typbit_26 + PLC_di_Typbit_27) = 1;
!***************************************
!*      Waiting for car type F56       *
!*            or F55 or F54            *
!***************************************

n_Type_Mem:=GetGroupIP_Bit(PLC_di_Typbit_16, 16);
!*************************************
!*   Store type code for later use   *
!*************************************

TEST n_Type_Mem
   CASE 1:
      !F56 Cooper EC   
      SetDO PLC_do_Typbit_16, 1;
      n_Inos_Type := 3;      
	  
   CASE 2:
      !F56 Cooper S EC   
      SetDO PLC_do_Typbit_17, 1;
      n_Inos_Type := 4;
      
   CASE 3:
      !F56 Cooper US
      SetDO PLC_do_Typbit_18, 1;
      n_Inos_Type := 5;
      
   CASE 4:
      !F56 Cooper S US   
      SetDO PLC_do_Typbit_19, 1;
      n_Inos_Type := 6;
      
   CASE 5:
      !F55 Cooper EC   
      SetDO PLC_do_Typbit_20, 1;
      n_Inos_Type := 1;
      
   CASE 6:
      !F55 Cooper S EC   
      SetDO PLC_do_Typbit_21, 1;
      n_Inos_Type := 2;
      
   CASE 7:
      !F55 Cooper US   
      SetDO PLC_do_Typbit_22, 1;
      n_Inos_Type := 1;
      
   CASE 8:
      !F55 Cooper S US   
      SetDO PLC_do_Typbit_23, 1;    
      n_Inos_Type := 2;
      
   CASE 9:
      !F54 Cooper EC   
      SetDO PLC_do_Typbit_24, 1;
      n_Inos_Type := 3;
      
   CASE 10:
      !F54 Cooper S EC   
      SetDO PLC_do_Typbit_25, 1;
      n_Inos_Type := 3;      

   CASE 11:
      !F54 Cooper US   
      SetDO PLC_do_Typbit_26, 1;
      n_Inos_Type := 3;
            
   CASE 12:
      !F54 Cooper S US   
      SetDO PLC_do_Typbit_27, 1;          
      n_Inos_Type := 3;
        
   DEFAULT:
      WHILE TRUE DO
      Stop;
      !*********************************
      !*   Error: Incorrect car type   *
      !*********************************
      ENDWHILE
ENDTEST
!**********************************
!*   Echo type code back to PLC   *
!*       and type for INOS        *
!**********************************


ENDPROC !(CheckVariant)


!*******************************************************************************


PROC InitBeforHome(num n_Home)
!---------------------------------------------------------------------------------
!- function/Funktion: Procedure InitBeforHome                                    -
!- Prozedur zum Initialisieren von Ein-, Ausgaengen, Variabelen für den User     -
!- Procedur wird vor anfahren der Home Position  Aufgerufen                      -
!-                                                                               -
!- Routine for user defined Signals/Variables/Routine calls that have to be set  -
!- to a certain state/executed before the home initialisation is executed.       -
!-                                                                               -
!- state/Stand: xx.xx.xx                                                         -
!-                                                                               -
!- author/Ersteller: ...                                                         -
!---------------------------------------------------------------------------------

CheckValue n_Home,1,5,0,"InitBeforHome";

TEST n_Home

CASE 1:
    GrpPartChk low, GR01_B01PP\Part2:=GR01_B02PP\Part3:=GR01_B03PP\Part4:=GR01_B04PP;
    GrpPartChk low, GR01_B05PP\Part2:=GR01_B06PP;    
	GrpSet Opn, Grp_11\Grp2:=Grp_12\Grp3:=Grp_13\Grp4:=Grp_14;
    !
CASE 2:
	GrpPartChk high, GR01_B01PP\Part2:=GR01_B02PP;
    GrpPartChk low, GR01_B05PP\Part2:=GR01_B06PP;    
	GrpSet Cls, Grp_11\Grp2:=Grp_12;
    GrpSet Opn, Grp_13;    
	!
CASE 3:
	!InitBeforHome_3 user code here
	!
CASE 4:
	!InitBeforHome_4 user code here
	!
CASE 5:
	!InitBeforHome_5 user code here
	!
ENDTEST  
ENDPROC !(InitBeforHome)


!*******************************************************************************


PROC InitInHome(num n_Home)
!---------------------------------------------------------------------------------
!- function/Funktion: Procedure InitInHome                                       -
!- Prozedur zum Initialisieren von Ein-, Ausgaengen, Variabelen für den User     -
!- Procedur wird nach erreichen der Home Position  Aufgerufen                    -
!-                                                                               -
!- Routine for user defined Signals/Variables/Routine calls that have to be set  -
!- to a certain state/executed before the home initialisation is executed.       -
!-                                                                               -
!- state/Stand: xx.xx.xx                                                         -
!-                                                                               -
!- author/Ersteller: ...                                                         -
!---------------------------------------------------------------------------------

CheckValue n_Home,1,5,0,"InitInHome";

TEST n_Home
CASE 1:
	!InitInHome_1 user code here
	!
CASE 2:
	!InitInHome_2 user code here
    !
CASE 3:
	!InitInHome_3 user code here
	!
CASE 4:
	!InitInHome_4 user code here
	!
CASE 5:
	!InitInHome_5 user code here
	!
ENDTEST  
ENDPROC !(InitInHome)


!*******************************************************************************


PROC ResetUser(\switch nodisplay)
!*********************************
!* User Reset Event Instructions *
!*********************************

!Enter your user code here

ENDPROC !(ResetUser)


!*******************************************************************************



PROC RestartUser(\switch nodisplay)
!***********************************
!* User ReStart Event Instructions *
!***********************************

!Enter your user code here


ENDPROC !(RestartUser)


!*******************************************************************************


PROC StartUser(\switch nodisplay)
!*********************************
!* User Start Event Instructions *
!*********************************

!Enter your user code here


ENDPROC !(StartUser)


!*******************************************************************************


PROC StopUser(\switch nodisplay)
!********************************
!* User Stop Event Instructions *
!********************************

!Enter your user code here


ENDPROC !(StopUser)


!*******************************************************************************


PROC PowerOnUser(\switch nodisplay)
!***********************************
!* User PowerOn Event Instructions *
!***********************************

!Enter your user code here


ENDPROC !(PowerOnUser)


!*******************************************************************************


PROC x_CalibrationPos ()
!--------------------------------------------------------------
! function/Funktion: Procedure Calibrations Position / Calib Pos
!
! state/Stand: xx.xx.xx
!
! author/Ersteller: ...
!--------------------------------------------------------------
! Programmiere  bei bedarf einen Weg zur CalibPos /
! Program the need for a way to CalibPos

CheckManualTestMode;

t_Home := CTool();    	
MoveAbsJ jpCalibA1_A6,v200,fine,t_Home; 

Stop;

ENDPROC !(CalibrationPos)


!*******************************************************************************


PROC Def_Indirect_wobj ()
!***************************************
!* User Rouine to define a work object *
!"     using the indirect method       *
!***************************************

!*****************************************************
!** Configure the tool you are using to measure and **
!**   the work object and configure the work object **
!**           you are looking to define.            **
!*****************************************************

CheckManualTestMode;

Indirect_WOBJ tool0, wobj0;

Stop;

ENDPROC !(Def_Indirect_wobj)

PROC ManSyncIntPos ()
!****************************************
!* User Routine to contain intermediate *
!"    positions for 'ManSyncService'    *
!****************************************

CheckManualTestMode;

t_Home := CTool();
t_Home.robhold:=TRUE;
        
IF n_ManSyncCMD=0 THEN
    IF b_TwoSyncPos<>TRUE THEN
        n_ManSyncCMD:=10 ;
    ELSE
        n_ManSyncCMD:=20 ;
    ENDIF
ENDIF

IF n_ManSyncCMD=1 OR n_ManSyncCMD=10 THEN

    WaitDO SYS_do_Home_1,high;
    !*************************************
    !* Wait for robot in Home Position 1 *
    !*************************************

    !** Program Moves from 'HomePos1' to 'jpCalibA1_A6'**
    MoveAbsJ jpHome1, v200, fine, t_Home;
    

    MoveAbsJ jpCalibA1_A6,v200,fine,t_Home;
ELSEIF n_ManSyncCMD=2 OR n_ManSyncCMD=20 THEN
    
    WaitDO SYS_do_Home_1,high;
    !*************************************
    !* Wait for robot in Home Position 1 *
    !*************************************

    !** Program Moves from 'HomePos1' to 'jpCalibPos1' **
    MoveAbsJ jpHome1, v200, fine, t_Home;
 
    MoveAbsJ jpCalibPos1,v200,fine,t_Home;
ENDIF

IF n_ManSyncCMD=3 OR n_ManSyncCMD=20 THEN
    !** Program Moves from 'jpCalibPos1' to 'jpCalibPos2' **
    MoveAbsJ jpCalibPos1,v200,fine,t_Home;
  
    MoveAbsJ jpCalibPos2,v200,fine,t_Home;
ENDIF

IF n_ManSyncCMD=4 OR n_ManSyncCMD=10 OR n_ManSyncCMD=20 THEN
    !** Program Moves from 'jpSM1SyncSwitch' to 'HomePos1' **
    MoveAbsJ jpSM1SyncSwitch, v200, fine, t_Home;
   
    MoveAbsJ jpHome1, v200, fine, t_Home;
ENDIF

n_ManSyncCMD:=0;
ENDPROC !(ManSyncIntPos)


ENDMODULE
