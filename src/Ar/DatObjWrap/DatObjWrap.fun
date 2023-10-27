(********************************************************************
 * COPYRIGHT -- B&R Industrial Automation
 ********************************************************************
 * Library: DatObjWrap
 * File: DatObjWrap.fun
 * Author: blackburnd
 * Created: March 10, 2010
 ********************************************************************
 * Functions and function blocks of library DatObjWrap
 ********************************************************************)

FUNCTION DatObjWrapFn_Cyclic : BOOL (*This function implements a wrapper for Data Object writing and reading.*)
	VAR_IN_OUT
		t : DatObjWrap_typ; (*Data object wrapper control object.*)
	END_VAR
END_FUNCTION

FUNCTION DatObjWrapOpen_Init : BOOL (*Synchronously loads a data object. Should ONLY be called in the INIT routine.*)
	VAR_IN_OUT
		t : DatObjWrap_typ; (*Data object wrapper control object.*)
	END_VAR
END_FUNCTION

FUNCTION dowSetError : BOOL (*Set error status on DatObjWrap*)
	VAR_INPUT
		ErrorID : UINT;
	END_VAR
	VAR_IN_OUT
		t : DatObjWrap_typ;
	END_VAR
END_FUNCTION
