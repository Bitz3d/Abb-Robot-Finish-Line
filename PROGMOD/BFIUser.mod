MODULE BFIUser(NOSTEPIN)

! File version number
CONST string st_Version_BF_USER:="1.2.1BFIuser";

! IP address & port of Best Fit station
CONST string st_BestFit_IP:="10.205.34.57";
CONST num n_BestFit_PORT:=1006;
	
! Variable in order to handle differences between HPFit (Oxford version) and gGuide (Regensburg version).
CONST bool b_HPFit:=TRUE;

! Enable/disable debug user logging messages during normal operation (error logging messages are always enabled)
CONST bool b_EnableDebugLog:=FALSE;

! Tool that will be used by Best Fit system
TASK PERS tooldata t_inosTool:=[TRUE,[[26.5774,98.0613,502.695],[0.00656,-0.61393,0.78928,0.00936]],[311.4,[-15.6,-0.4,261.4],[1,0,0,0],130.469,118.237,123.004]];

! Work object that will be used by Best Fit system
TASK PERS wobjdata wobj_inosWobj:= [FALSE,TRUE,"",[[603,2050.01,-515],[0,0,0,1]],[[0.067,1.318,1.054],[0.999999,0.000898756,8.81684E-05,0.00100349]]];

! Wait time between correction steps
VAR num n_delay:=0.0;

! Intermediate relative position in reference to the final robot position, used for hysterisis compensation (in TCP coordinates)
CONST pose pose_HystComp:=[[0,0,0],[1,0,0,0]];

! Custom speed data for correction movements
CONST speeddata vFitSpeed:=[10,1,10,10];

! Created custom speed data for training movements
CONST speeddata vTrainSpeed:=[30,1,30,30];

! Persistent variable {per process} for maximum allowed robot movements (values are saved if modified)
TASK PERS frame fr_MaxMove{10}:=[[50,50,50,5,5,5],[5,5,5,0.5,0.5,0.5],[50,50,50,5,5,5],[5,5,5,0.7,0.7,0.7],[5,5,5,0.7,0.7,0.7],[5,5,5,0.5,0.6,0.5],[50,50,50,5,5,5],[50,50,50,5,5,5],[50,50,50,5,5,5],[50,50,50,5,5,5]];

! Persistent variable {per process} for average robot movements (values are saved if modified)
TASK PERS frame fr_AverageTCPCorr{10,10}:=
[[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0.168,-0.399,1.192,0.104,0,0.069],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0.736,-0.042,0.76,0.136,0,0.096],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[-0.729,-1.331,1.444,0,0.138,0.111],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[-0.948,-0.539,1.421,0.017,0.079,0.108],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[-0.653,-0.816,1.028,0.053,0.069,0.173],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[-0.845,-0.962,1.157,0.061,0.074,0.171],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]];

! Persistent variable {per process} for average robot movements (values are saved if modified)
TASK PERS frame fr_AverageWorkCorr{10,10}:=
[[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0.166,0.993,1.203,0.103,0,0.07],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0.722,1.839,0.771,0.134,0,0.097],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[-2.152,-0.177,0.59,-0.002,0.138,0.11],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[-1.752,0.696,0.951,0.014,0.079,0.108],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[-1.367,1.335,0.628,0.049,0.069,0.174],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[-1.61,1.221,0.728,0.057,0.074,0.172],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]],
[[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]];


! This routine can be edited by the robot programmer in order to initalize the tool and work object that will be used by the best-fit routines
PROC BF_initialize(tooldata t_toolBFIin, wobjdata wobj_baseBFIin, INOUT wobjdata wobj_baseBFIout)
 
! Disconnect from Best-Fit PC
BF_IOEXIT;

! Create connection with Best-Fit PC
IF (PLC_di_BF_OutOfOrder = 0) THEN
    b_connected:=BF_IOINIT(3, st_BestFit_IP, n_BestFit_PORT);
ENDIF

! Reset wobj
wobj_inosWobj:=wobj_baseBFIin;
wobj_baseBFIout:=wobj_inosWobj;
t_inosTool:=t_toolBFIin;

! Reset Best_Fit error flag
n_Inos_Error_Code:=0;

if b_HPFit BF_INOS 1,6,1,1,1,1\b_PAR_UPD_AVG:=FALSE;

! Reset PLC signals
Reset PLC_do_BF_Busy;
Reset PLC_do_BF_Meas_Err;

ENDPROC 
!BF_initialize()


ENDMODULE