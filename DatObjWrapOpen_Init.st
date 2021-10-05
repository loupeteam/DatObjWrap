(********************************************************************
 * COPYRIGHT --  
 ********************************************************************
 * Library: DatObjWrap
 * File: DatObjWrapOpen_Init.st
 * Author: David
 * Created: July 27, 2010
 ********************************************************************
 * Implementation of library DatObjWrap
 ********************************************************************) 


(************************************************************************************)
(* Synchronously loads a data object. Should ONLY be called in the INIT routine.	*)
(************************************************************************************)


(* GetInfo			DONE and TESTED DFB 20110516 *)
	(* No error		DONE and TESTED DFB 20110516 *)
	(* Error		DONE and TESTED DFB 20111222 *)
	
(* Read				DONE and TESTED DFB 20110516 *)
	(* No error		DONE and TESTED DFB 20110516 *)
	(* Error		DONE and TESTED DFB 20111222 *)


FUNCTION DatObjWrapOpen_Init


(****************************************************)
(* Set return value to get rid of compile warning 	*)
(****************************************************)

DatObjWrapOpen_Init:=	FALSE;


(********************************************)		
(* DatObjGetInfo 							*)
(********************************************)		


(* Map inputs *)

t.Internal.FUB.DatObjGetInfo.enable:=	1;
t.Internal.FUB.DatObjGetInfo.pName:=	ADR(t.IN.PAR.DataObjName);


(* Call FUB *)

t.Internal.FUB.DatObjGetInfo();	

t.Internal.FUB.DatObjGetInfo.enable:=	0;


(* check status *)

(* if no error *)

IF( t.Internal.FUB.DatObjGetInfo.status = 0 ) THEN		


	(* store ident *)

	t.Internal.Ident:=	t.Internal.FUB.DatObjGetInfo.ident;


(* Error *)

ELSE
	
	
	(* Set error info and return *)
	
	dowSetError( t.Internal.FUB.DatObjGetInfo.status, t );
		
	RETURN;


END_IF
		

(********************************************)		
(* DatObjRead	 							*)
(********************************************)		


(* Map inputs *)

t.Internal.FUB.DatObjRead.enable:=			1;
t.Internal.FUB.DatObjRead.ident:=			t.Internal.Ident;
t.Internal.FUB.DatObjRead.Offset:=			0;
t.Internal.FUB.DatObjRead.pDestination:=	t.IN.PAR.pData;
t.Internal.FUB.DatObjRead.len:=				t.IN.PAR.len;


(* Call FUB *)

t.Internal.FUB.DatObjRead();	

t.Internal.FUB.DatObjRead.enable:=	0;


(* check status *)
		
(* If Error *)

IF( t.Internal.FUB.DatObjRead.status <> 0 ) THEN		
	
	
	(* Set error info and return *)

	dowSetError( t.Internal.FUB.DatObjRead.status, t );
	
	RETURN;
 	
	
END_IF
	

END_FUNCTION
