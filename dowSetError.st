(********************************************************************
 * COPYRIGHT -- Automation Resources Group
 ********************************************************************
 * Library: DatObjWrap
 * File: dowSetError.st
 * Author: David Blackburn
 * Created: December 22, 2011
 ********************************************************************
 * Implementation of library DatObjWrap
 ********************************************************************) 


(********************************************************************)
(* Set error status on DatObjWrap 									*)
(********************************************************************)


(* Reset Busy, Done			DONE and TESTED DFB 20111222 *)
(* Set Error				DONE and TESTED DFB 20111222 *)
(* Set ErrorID				DONE and TESTED DFB 20111222 *)
(* Set ErrorLevel			DONE and TESTED DFB 20111222 *)
(* Set ErrorState			DONE and TESTED DFB 20111222 *)
(* Set State				DONE and TESTED DFB 20111222 *)
(* Set ErrorString			DONE and TESTED DFB 20111222 *)
	

FUNCTION dowSetError


(****************************************************)
(* Set return value to get rid of compile warning 	*)
(****************************************************)

dowSetError:=	FALSE;


(************************************************)
(* Set error status								*)
(************************************************)

t.OUT.STAT.Busy:=		0;
t.OUT.STAT.Done:=		0;
t.OUT.STAT.Error:=		1;
t.OUT.STAT.ErrorID:=	ErrorID;
t.OUT.STAT.ErrorLevel:=	3;
t.OUT.STAT.ErrorState:=	t.Internal.State;
t.Internal.State:=		DOWRAP_ST_ERROR;


(* Set ErrorString *)

CASE ErrorID OF
	
	0: t.OUT.STAT.ErrorString:=	'';
	
	doERR_ILLPARAMETER:			t.OUT.STAT.ErrorString:=	'Invalid parameter. Check IN.PAR.pData.';
	doERR_DUPOBJECT:			t.OUT.STAT.ErrorString:=	'Object already present.';
	doERR_ILLMEMTYPE:			t.OUT.STAT.ErrorString:=	'Invalid memory type.';
	doERR_NOMEMORY:				t.OUT.STAT.ErrorString:=	'No memory available for object.';
	doERR_BRINSTALL:			t.OUT.STAT.ErrorString:=	'Error installing data object.';
	doERR_ILLOBJECT:			t.OUT.STAT.ErrorString:=	'Data object not found. Check IN.PAR.DataObjName.';
	doERR_ILLOBJTYPE:			t.OUT.STAT.ErrorString:=	'Object found, but it was not a data object. Check IN.PAR.DataObjName.';
	doERR_WRONGOFFSET:			t.OUT.STAT.ErrorString:=	'Invalid offset specified.';
	doERR_ILLEGALLENGTH:		t.OUT.STAT.ErrorString:=	'Invalid length specified. Check IN.PAR.len.';
	doERR_MODULNOTFOUND:		t.OUT.STAT.ErrorString:=	'Data object not found. Check IN.PAR.DataObjName.';
	doERR_WRONGTIME:			t.OUT.STAT.ErrorString:=	'Invalid date set.';
	doERR_ILLSTATE:				t.OUT.STAT.ErrorString:=	'Data object not in correct state.';
	doERR_STARTHANDLER:			t.OUT.STAT.ErrorString:=	'System error.';
	doERR_TOOLONG_MODULNAME:	t.OUT.STAT.ErrorString:=	'Data object name is too long. Check IN.PAR.DataObjName.';
	doERR_BURNINGOBJECT:		t.OUT.STAT.ErrorString:=	'System error.';
	
	ELSE	t.OUT.STAT.ErrorString:=	'Unknown error.';
	
END_CASE


END_FUNCTION
