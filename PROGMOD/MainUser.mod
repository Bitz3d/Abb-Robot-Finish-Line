MODULE MainUser
!*************************************
!* This module contains all the user *
!*  programs directly called by the  *
!*      PLC by program number        *
!*************************************

PROC Program_1()
!***********************************************
!* Program:  Complete sequence                 *
!* Location: 3FL5MBG16   65R02                 *
!***********************************************
!*            Update section                   *
!*           ================                  *
!* Date:     17/08/2013                        *
!* Engineer: Rafal Cieslinski / Staudinger     *
!* Changes:  Created                           *
!*                                             *
!***********************************************

WaitDO SYS_do_Home_1,high;
!**************************************
!*   Wait for robot to be in Home 1   *
!**************************************

WaitUntil PLC_di_Job01_Enable = 1 OR PLC_di_ProgSkip = 1;
!***************************************
!*   Step 1: Pick bonnet from 65FX02   *
!*        Waiting for JobEnable        *
!***************************************

IF PLC_di_ProgSkip = 1 THEN
  RETURN;

ELSEIF PLC_di_Job01_Enable = 1 THEN

  CheckVariant;
  
  TEST n_Type_Mem
    CASE 1, 2, 3, 4, 5, 6, 7, 8:
      f5x_01_65fx02_pick;

    DEFAULT:
      WHILE TRUE DO
        Stop;
        !*********************************
        !*   Error: Incorrect car type   *
        !*********************************
      ENDWHILE
  ENDTEST

ELSE
  WHILE TRUE DO
    Stop;
    !***********************************
    !*   Error: Signal from PLC lost   *
    !***********************************
  ENDWHILE
ENDIF

WaitUntil (PLC_di_Job02_Enable + PLC_di_Job04_Enable) = 1 OR PLC_di_ProgSkip = 1;
!**************************************
!*   Step 2: BestFit bonnet to body   *
!*       Waiting for JobEnable        *
!**************************************

IF PLC_di_ProgSkip = 1 THEN
  RETURN;

ELSEIF PLC_di_Job02_Enable = 1 THEN
    
  TEST n_Type_Mem
    CASE 1, 2, 3, 4:
      f56_02_65fx01_fit;

    CASE 5, 6, 7, 8:
      f55_02_65fx01_fit;
      
    DEFAULT:
      WHILE TRUE DO
        Stop;
        !*********************************
        !*   Error: Incorrect car type   *
        !*********************************
      ENDWHILE
  ENDTEST

ELSEIF PLC_di_Job04_Enable = 1 THEN
    
  TEST n_Type_Mem
    CASE 1, 2, 3, 4:
      f56_02_65fx01_allignment_check;

    CASE 5, 6, 7, 8:
      f55_02_65fx01_allignment_check;
      
    DEFAULT:
      WHILE TRUE DO
        Stop;
        !*********************************
        !*   Error: Incorrect car type   *
        !*********************************
      ENDWHILE
  ENDTEST
  
ELSE
  WHILE TRUE DO
    Stop;
    !***********************************
    !*   Error: Signal from PLC lost   *
    !***********************************
  ENDWHILE
ENDIF

RETURN;
ENDPROC !(Program_1)


PROC Program_2()
!***********************************************
!* Program:  Reduced sequence                  *
!* Location: 3FL5MBG16   65R02                 *
!***********************************************
!*            Update section                   *
!*           ================                  *
!* Date:     17/08/2013                        *
!* Engineer: Rafal Cieslinski / Staudinger     *
!* Changes:  Created                           *
!*                                             *
!***********************************************

WaitDO SYS_do_Home_2,high;
!**************************************
!*   Wait for robot to be in Home 2   *
!**************************************

WaitUntil (PLC_di_Job02_Enable + PLC_di_Job04_Enable) = 1 OR PLC_di_ProgSkip = 1;
!**************************************
!*   Step 2: BestFit bonnet to body   *
!*       Waiting for JobEnable        *
!**************************************

CheckVariant;

IF PLC_di_ProgSkip = 1 THEN
  RETURN;

ELSEIF PLC_di_Job02_Enable = 1 THEN
    
  TEST n_Type_Mem
    CASE 1, 2, 3, 4:
      f56_02_65fx01_fit;

    CASE 5, 6, 7, 8:
      f55_02_65fx01_fit;
      
    DEFAULT:
      WHILE TRUE DO
        Stop;
        !*********************************
        !*   Error: Incorrect car type   *
        !*********************************
      ENDWHILE
  ENDTEST

ELSEIF PLC_di_Job04_Enable = 1 THEN
    
  TEST n_Type_Mem
    CASE 1, 2, 3, 4:
      f56_02_65fx01_allignment_check;

    CASE 5, 6, 7, 8:
      f55_02_65fx01_allignment_check;
      
    DEFAULT:
      WHILE TRUE DO
        Stop;
        !*********************************
        !*   Error: Incorrect car type   *
        !*********************************
      ENDWHILE
  ENDTEST
  
ELSE
  WHILE TRUE DO
    Stop;
    !***********************************
    !*   Error: Signal from PLC lost   *
    !***********************************
  ENDWHILE
ENDIF

RETURN;
ENDPROC !(Program_2)


PROC Program_40()
!***********************************************
!* Program:  Gripper calibration               *
!* Location: 3FL5MBG16   65R02                 *
!***********************************************
!*            Update section                   *
!*           ================                  *
!* Date:     04/04/2015                        *
!* Engineer: Rafal Cieslinski / Staudinger     *
!* Changes:  Created                           *
!*                                             *
!***********************************************

WaitDO SYS_do_Home_1,high;
!**************************************
!*   Wait for robot to be in Home 1   *
!**************************************

WaitUntil PLC_di_Job15_Enable = 1 OR PLC_di_ProgSkip = 1;
!**************************************
!*        Calibration gripper         *
!**************************************

IF PLC_di_ProgSkip = 1 THEN
  RETURN;

ELSEIF PLC_di_Job15_Enable = 1  THEN
    
  Calibration_Grp;

ELSE
  WHILE TRUE DO
    Stop;
    !***********************************
    !*   Error: Signal from PLC lost   *
    !***********************************
  ENDWHILE
ENDIF

RETURN;
ENDPROC !(Program_40)


PROC Program_56()
!***********************************************
!* Program:  Service routine - gripper         *
!* Location: 3FL5MBG16   65R02                 *
!***********************************************
!*            Update section                   *
!*           ================                  *
!* Date:     17/08/2013                        *
!* Engineer: Rafal Cieslinski / Staudinger     *
!* Changes:  Created                           *
!*                                             *
!***********************************************

WaitDO SYS_do_Home_1,high;
!**************************************
!*   Wait for robot to be in Home 1   *
!**************************************

Service_Grp1;

RETURN;
ENDPROC !(Program_56)


PROC Program_61()
!***********************************************
!* Program:  Service routine for Tool 1        *
!* Location: 3FL5MBG16   65R02                 *
!***********************************************
!*               Update Section                *
!*              ================               *
!* Date:     14/12/2013                        *
!* Engineer: Rafal Cieslinski / Staudinger     *
!* Changes:  Created                           *
!*                                             *
!***********************************************

!Check robot is in home 1
WaitDO SYS_do_Home_1,high;
!**********************************
!* Wait for robot to be in Home 1 *
!**********************************

!Call to relevant Maintenance program.
Service_Clean;

RETURN;
ENDPROC !(Program_61)


PROC Program_62()
!***********************************************
!* Program:  Brake test                        *
!* Location: 3FL5MBG16   65R02                 *
!***********************************************
!*            Update section                   *
!*           ================                  *
!* Date:     17/08/2013                        *
!* Engineer: Rafal Cieslinski / Staudinger     *
!* Changes:  Created                           *
!*                                             *
!***********************************************

WaitDO SYS_do_Home_1, high;
!**************************************
!*   Wait for robot to be in Home 1   *
!**************************************

! SafeMove Braketest
BrakeTest;

RETURN;
ENDPROC !(Program_62)


ENDMODULE
