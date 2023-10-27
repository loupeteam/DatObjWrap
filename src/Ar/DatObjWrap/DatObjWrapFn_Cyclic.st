(*
 * File: DatObjWrapFn_Cyclic.st
 * Copyright (c) 2023 Loupe
 * https://loupe.team
 * 
 * This file is part of DatObjWrap, licensed under the MIT License.
 * 
  ********************************************************************
 * Implementation of library DatObjWrap
 ********************************************************************) 


(****************************************************************************)
(* This function implements a wrapper for Data Object writing and reading	*)
(****************************************************************************)


(* Resetting internal CMDs				DONE and TESTED DFB 20110516 *)


(* Main state machine					DONE and TESTED DFB 20110516 *)
	
	(* ST_WAIT							DONE and TESTED DFB 20110516 *)
		(* Handling CMDs				DONE and TESTED DFB 20110516 *)
			(* Setting CurrOperation	DONE and TESTED DFB 20110516 *)
		(* Handling Done				DONE and TESTED DFB 20110516 *)
		
	(* ST_GETINFO						DONE and TESTED DFB 20110516 *)
		(* Handling FUB					DONE and TESTED DFB 20110516 *)
		(* Checking status				DONE and TESTED DFB 20110516 *)
			(* Done						DONE and TESTED DFB 20110516 *)
			(* No error					DONE and TESTED DFB 20110516 *)
			(* Module Not Found			DONE and TESTED DFB 20111222 *)
				(* Open					DONE and TESTED DFB 20111222 *)
				(* SaveAs				DONE and TESTED DFB 20110516 *)
			(* Other error				DONE will not be tested *)
		
	(* ST_CREATE						DONE and TESTED DFB 20110516 *)
		(* Handling FUB					DONE and TESTED DFB 20110516 *)
		(* Checking status				DONE and TESTED DFB 20110516 *)
			(* Done						DONE and TESTED DFB 20110516 *)
			(* No error					DONE and TESTED DFB 20110516 *)
			(* Other error				DONE and TESTED DFB 20111222 *)
		
	(* ST_OPEN							DONE and TESTED DFB 20110516 *)
		(* Handling FUB					DONE and TESTED DFB 20110516 *)
		(* Checking status				DONE and TESTED DFB 20110516 *)
			(* Done						DONE and TESTED DFB 20110516 *)
			(* No error					DONE and TESTED DFB 20110516 *)
			(* Other error				DONE and TESTED DFB 20111222 *)
		
	(* ST_SAVE							DONE and TESTED DFB 20110516 *)
		(* Handling FUB					DONE and TESTED DFB 20110516 *)
		(* Checking status				DONE and TESTED DFB 20110516 *)
			(* Done						DONE and TESTED DFB 20110516 *)
			(* No error					DONE and TESTED DFB 20110516 *)
			(* Other error				DONE and TESTED DFB 20111222 *)
			
	(* ST_ERROR							DONE and TESTED DFB 20111222 *)


(* Busy, Done, Error					DONE and TESTED DFB 20111222 *)

(* Resetting AcknowledgeError			DONE and TESTED DFB 20110516 *)


FUNCTION DatObjWrapFn_Cyclic


(****************************************************)
(* Set return value to get rid of compile warning 	*)
(****************************************************)

DatObjWrapFn_Cyclic:=	FALSE;


(****************************************************)
(* Reset Internal CMDs								*)
(****************************************************)

IF( NOT(t.IN.CMD.Open) )THEN

	t.Internal.CMD.Open:=	0;
	
END_IF


IF( NOT(t.IN.CMD.SaveAs) )THEN

	t.Internal.CMD.SaveAs:=	0;
	
END_IF


(****************************************)
(* Main State machine					*)
(****************************************)

CASE t.Internal.State OF
	
	
	DOWRAP_ST_WAIT:
	
	
		(* If all CMDs are cleared, then clear Done status *)
		
		IF( 	NOT(t.IN.CMD.Open)
			AND NOT(t.IN.CMD.SaveAs)
			)THEN  		
		
			t.OUT.STAT.Done:=	0;
			
		END_IF
		
		
		(* Set CurrOperation to INVALID. It will be set below on leaving the state *)
		
		t.Internal.CurrOperation:=	DOWRAP_OP_INVALID;
		
		
		(* Wait for new commands *)
		
		IF( t.IN.CMD.SaveAs AND NOT(t.Internal.CMD.SaveAs) )THEN
			

			t.Internal.CMD.SaveAs:=	1;
			
			t.OUT.STAT.Busy:=	1;
			t.OUT.STAT.Done:=	0;
						
			t.Internal.State:=			DOWRAP_ST_GETINFO;
			t.Internal.CurrOperation:=	DOWRAP_OP_SAVEAS;
			

		ELSIF( t.IN.CMD.Open AND NOT(t.Internal.CMD.Open) )THEN

			
			t.Internal.CMD.Open:=	1;
			
			t.OUT.STAT.Busy:=	1;
			t.OUT.STAT.Done:=	0;
						
			t.Internal.State:=			DOWRAP_ST_GETINFO;
			t.Internal.CurrOperation:=	DOWRAP_OP_OPEN;

			
		END_IF
				
	
	DOWRAP_ST_GETINFO:
		
		
		(* DatObjGetInfo *)
		
		t.Internal.FUB.DatObjGetInfo.enable:=	1;
		t.Internal.FUB.DatObjGetInfo.pName:=	ADR(t.IN.PAR.DataObjName);
  		
		
		(* Check FUB status *)
		
		(* If finished *)
		
		IF( t.Internal.FUB.DatObjGetInfo.status < DOWRAP_STATUS_FUB_DISABLED ) THEN
  
  			
			t.Internal.FUB.DatObjGetInfo.enable:=	0;
  			
  			
			(* if no error *)
  			
			IF( t.Internal.FUB.DatObjGetInfo.status = 0 ) THEN		
				
				
				(* store ident *)
				
				t.Internal.Ident:=	t.Internal.FUB.DatObjGetInfo.ident;
				
				
				(* go to appropriate state *)
				
				IF( t.Internal.CurrOperation = DOWRAP_OP_OPEN ) THEN
				
					t.Internal.State:=	DOWRAP_ST_OPEN;
				
				ELSIF( t.Internal.CurrOperation = DOWRAP_OP_SAVEAS ) THEN
				
					t.Internal.State:=	DOWRAP_ST_SAVE;
				
				ELSE
				
					t.Internal.State:=	DOWRAP_ST_WAIT;
				
				END_IF
				
			
			(* if data object not found *)
			
			ELSIF( t.Internal.FUB.DatObjGetInfo.status = doERR_MODULNOTFOUND )THEN
   				
				
				(* if loading, then an error *)
				
				IF( t.Internal.CurrOperation = DOWRAP_OP_OPEN ) THEN
					
					dowSetError( t.Internal.FUB.DatObjGetInfo.status, t );
				
				ELSIF( t.Internal.CurrOperation = DOWRAP_OP_SAVEAS ) THEN
				
					t.Internal.State:=	DOWRAP_ST_CREATE;
					
				ELSE
					
					t.Internal.State:=	DOWRAP_ST_WAIT;
				
				END_IF
			
			
			(* if other error *)
			
			ELSE
				
				dowSetError( t.Internal.FUB.DatObjGetInfo.status, t );
				
			END_IF(* status checking *)
			

		END_IF(* if FUB finished *)
		
		
	DOWRAP_ST_CREATE:
	
		
		(* Create the data object and write to it *)
		(* Will only get here if saving *)
		
		t.Internal.FUB.DatObjCreate.enable:=	1;
		t.Internal.FUB.DatObjCreate.grp:=		0;
		t.Internal.FUB.DatObjCreate.pName:=		ADR(t.IN.PAR.DataObjName);
		t.Internal.FUB.DatObjCreate.len:=		t.IN.PAR.len;
		t.Internal.FUB.DatObjCreate.MemType:=	doUSRROM;
		t.Internal.FUB.DatObjCreate.Option:=	0;
		t.Internal.FUB.DatObjCreate.pCpyData:=	t.IN.PAR.pData;
		
		
		(* Check FUB status *)
		
		(* if FUB finished *)
		
		IF( t.Internal.FUB.DatObjCreate.status < DOWRAP_STATUS_FUB_DISABLED ) THEN
  
  			
			t.Internal.FUB.DatObjCreate.enable:=	0;
  			
  			
			(* if no error *)
  			
			IF( t.Internal.FUB.DatObjCreate.status = 0 ) THEN		
				
				
				(* Done saving *)
				
				t.OUT.STAT.Busy:=	0;
				t.OUT.STAT.Done:=	1;
				
				t.Internal.State:=	DOWRAP_ST_WAIT;
										
			
			(* if other error *)
			
			ELSE
				
				dowSetError( t.Internal.FUB.DatObjCreate.status, t );
				
//				t.OUT.STAT.Error:=		1;
//				t.OUT.STAT.ErrorID:=	t.Internal.FUB.DatObjCreate.status;
//				t.OUT.STAT.ErrorState:=	t.Internal.State;
//				t.Internal.State:=		DOWRAP_ST_ERROR;	
			
			END_IF(* status checking *)
			
		END_IF(* if FUB finished *)
	
	
	DOWRAP_ST_OPEN:
	
		
		(* Read data from data object *)
		
		t.Internal.FUB.DatObjRead.enable:=			1;
		t.Internal.FUB.DatObjRead.ident:=			t.Internal.Ident;
		t.Internal.FUB.DatObjRead.Offset:=			0;
		t.Internal.FUB.DatObjRead.pDestination:=	t.IN.PAR.pData;
		t.Internal.FUB.DatObjRead.len:=				t.IN.PAR.len;
	

		(* Check FUB status *)
		
		(* If finished *)
		
		IF( t.Internal.FUB.DatObjRead.status < DOWRAP_STATUS_FUB_DISABLED ) THEN
  
  
  			t.Internal.FUB.DatObjRead.enable:=	0;
  			
  
  			(* if no error *)
  			
			IF( t.Internal.FUB.DatObjRead.status = 0 ) THEN		
				
				
				(* Done loading *)
				
				t.OUT.STAT.Busy:=	0;
				t.OUT.STAT.Done:=	1;
				
				t.Internal.State:=	DOWRAP_ST_WAIT;
									
			
			(* if other error *)
			
			ELSE
				
				dowSetError( t.Internal.FUB.DatObjRead.status, t );
				
//				t.OUT.STAT.Error:=		1;
//				t.OUT.STAT.ErrorID:=	t.Internal.FUB.DatObjRead.status;
//				t.OUT.STAT.ErrorState:=	t.Internal.State;
//				t.Internal.State:=		DOWRAP_ST_ERROR;	
			
			END_IF(* status checking *)
			
		END_IF(* if FUB finished *)
	
	
	DOWRAP_ST_SAVE:
	
	
		(* Write data to data object *)
		
		t.Internal.FUB.DatObjWrite.enable:=		1;
		t.Internal.FUB.DatObjWrite.ident:=		t.Internal.Ident;
		t.Internal.FUB.DatObjWrite.Offset:=		0;
		t.Internal.FUB.DatObjWrite.pSource:=	t.IN.PAR.pData;
		t.Internal.FUB.DatObjWrite.len:=		t.IN.PAR.len;
		
		
		(* Check FUB status *)
		
		(* if finished *)
		
		IF( t.Internal.FUB.DatObjWrite.status < DOWRAP_STATUS_FUB_DISABLED ) THEN
  
  			
			t.Internal.FUB.DatObjWrite.enable:=	0;
  			
			
  			(* if no error *)
  			
			IF( t.Internal.FUB.DatObjWrite.status = 0 ) THEN		
				
				
				(* Done saving *)
				
				t.OUT.STAT.Busy:=	0;
				t.OUT.STAT.Done:=	1;
				
				t.Internal.State:=	DOWRAP_ST_WAIT;
									
			
			(* if other error *)
			
			ELSE
				
				dowSetError( t.Internal.FUB.DatObjWrite.status, t );
				
//				t.OUT.STAT.Error:=		1;
//				t.OUT.STAT.ErrorID:=	t.Internal.FUB.DatObjWrite.status;
//				t.OUT.STAT.ErrorState:=	t.Internal.State;
//				t.Internal.State:=		DOWRAP_ST_ERROR;	
			
			END_IF(* status checking *)
			
		END_IF(* if FUB finished *)
	
	
	DOWRAP_ST_ERROR:
	
				
		IF( t.IN.CMD.AcknowledgeError )THEN
			
			t.IN.CMD.AcknowledgeError:=	0;
			
			t.OUT.STAT.Error:=			0;
			t.OUT.STAT.ErrorID:=		0;
			t.OUT.STAT.ErrorString:=	'';
			t.OUT.STAT.ErrorLevel:=		0;
			t.OUT.STAT.ErrorState:=		0;

			t.Internal.State:=		DOWRAP_ST_WAIT;
			
		END_IF
	
	
END_CASE


(* Reset AcknowledgeError CMD *)

t.IN.CMD.AcknowledgeError:=	0;
			

(****************************************)
(* Call FUBs							*)
(****************************************)

t.Internal.FUB.DatObjGetInfo();
t.Internal.FUB.DatObjCreate();
t.Internal.FUB.DatObjRead();
t.Internal.FUB.DatObjWrite();


END_FUNCTION
