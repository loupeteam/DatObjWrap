(********************************************************************
 * COPYRIGHT -- B&R Industrial Automation
 ********************************************************************
 * Library: DatObjWrap
 * File: DatObjWrap.typ
 * Author: blackburnd
 * Created: March 10, 2010
 ********************************************************************
 * Data types of library DatObjWrap
 ********************************************************************)

TYPE
	DOWRAP_OP_enum : 
		(
		DOWRAP_OP_INVALID := 0,
		DOWRAP_OP_OPEN,
		DOWRAP_OP_SAVEAS
		);
	DOWRAP_ST_enum : 
		(
		DOWRAP_ST_WAIT := 0, (*0*)
		DOWRAP_ST_GETINFO, (*1*)
		DOWRAP_ST_CREATE, (*2*)
		DOWRAP_ST_OPEN, (*3*)
		DOWRAP_ST_SAVE, (*4*)
		DOWRAP_ST_ERROR := 999, (*999*)
		DOWRAP_ST_
		);
	DatObjWrap_Int_FUB_typ : 	STRUCT 
		DatObjGetInfo : DatObjInfo;
		DatObjCreate : DatObjCreate;
		DatObjWrite : DatObjWrite;
		DatObjRead : DatObjRead;
	END_STRUCT;
	DatObjWrap_Internal_typ : 	STRUCT 
		Ident : UDINT; (*Data object ident*)
		State : DINT; (*State variable*)
		CurrOperation : DINT; (*Current operation (Save or Load)*)
		FUB : DatObjWrap_Int_FUB_typ;
		CMD : DatObjWrap_IN_CMD_typ;
	END_STRUCT;
	DatObjWrap_OUT_STAT_typ : 	STRUCT 
		Busy : BOOL; (*Object is busy performing an action*)
		Done : BOOL; (*Action finished successfully*)
		Error : BOOL; (*There is an error with the DOHandling*)
		ErrorID : UINT; (*Error number from internal FUBs*)
		ErrorString : STRING[DOWRAP_STRLEN_ERROR];
		ErrorLevel : USINT;
		ErrorState : DINT; (*State in which error occurred*)
	END_STRUCT;
	DatObjWrap_OUT_typ : 	STRUCT 
		STAT : DatObjWrap_OUT_STAT_typ;
	END_STRUCT;
	DatObjWrap_IN_PAR_typ : 	STRUCT 
		DataObjName : STRING[8]; (*Name of the data object to which to store data*)
		pData : UDINT; (*Pointer to the data location to be saved from/loaded to*)
		len : UDINT; (*Length of the data to be saved/loaded*)
	END_STRUCT;
	DatObjWrap_IN_CMD_typ : 	STRUCT 
		Open : BOOL; (*Load settings from Data Object.*)
		SaveAs : BOOL; (*Save settings to Data Object.*)
		AcknowledgeError : BOOL; (*Acknowledge errors*)
	END_STRUCT;
	DatObjWrap_IN_typ : 	STRUCT 
		CMD : DatObjWrap_IN_CMD_typ;
		PAR : DatObjWrap_IN_PAR_typ;
	END_STRUCT;
	DatObjWrap_typ : 	STRUCT 
		IN : DatObjWrap_IN_typ;
		OUT : DatObjWrap_OUT_typ;
		Internal : DatObjWrap_Internal_typ;
	END_STRUCT;
END_TYPE
