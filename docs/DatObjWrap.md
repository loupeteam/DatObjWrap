![Automation Resources Group](http://automationresourcesgroup.com/images/arglogo254x54.png)

#DatObjWrap Library
The DatObjWrap library provides a simple, intuitive interface for opening and saving data objects.

Data objects offer power fail safe data storage. They have the advantage over permanent memory that they are also protected against battery failure. The DatObjWrap library provides a clean interface for the most common data object operations. Any state machines necessary to perform these operations are built into the library and do not need to be implemented by the application developer.

#Usage
The DatObjWrap functionality can be integrated into any project using a data structure and two function calls. For an example of how to use this in a project, please see the ARG Automation Studio Starter Project at [https://github.com/autresgrp/StarterProject](https://github.com/autresgrp/StarterProject).

##Initialization
The only initialization necessary is to declare a variable of type **DatObjWrap_typ**.

##Opening Data Objects on Startup
To open a data object on startup, the DataObjWrapper variable must be parameterized and the **DatObjWrapOpen_Init()** function must be called. **The DatObjWrapOpen_Init() function can only be called in the INIT routine of your program.**

	DatObjWrapper.IN.PAR.DataObjName:=	'rec1';
	DatObjWrapper.IN.PAR.pData:=		ADR(Recipe);
	DatObjWrapper.IN.PAR.len:=			SIZEOF(Recipe);

	DatObjWrapOpen_Init( DatObjWrapper );

After this function call, the Recipe variable will contain the values from the 'rec1' data object. If desired, the DatObjWrapOpen_Init function can be called multiple times with different parameters to load data from multiple data objects.

##Cyclic Operation
To handle data objects cyclically, the **DatObjWrapFn_Cyclic()** function should be called in the CYCLIC routine of your program, once every scan, unconditionally. This function should not be called on the same DatObjWrapper variable more than once per scan.

	DatObjWrapFn_Cyclic( DatObjWrapper );

The DatObjWrapper can then be used as an interface for higher level programs.

	IF( OpenRecipeDataObject )THEN
		
		OpenRecipeDataObject:=	0;
	
		DatObjWrapper.IN.PAR.DataObjName:=	'rec1';
		DatObjWrapper.IN.PAR.pData:=		ADR(Recipe);
		DatObjWrapper.IN.PAR.len:=			SIZEOF(Recipe);

		DatObjWrapper.IN.CMD.Open:=	1;
	
	END_IF

	IF( SaveRecipeDataObject )THEN
		
		SaveRecipeDataObject:=	0;

		DatObjWrapper.IN.PAR.DataObjName:=	'rec1';
		DatObjWrapper.IN.PAR.pData:=		ADR(Recipe);
		DatObjWrapper.IN.PAR.len:=			SIZEOF(Recipe);
		
		DatObjWrapper.IN.CMD.SaveAs:=	1;
	
	END_IF

	IF( DatObjWrapper.OUT.STAT.Done )THEN
		DatObjWrapper.IN.CMD.Open:=		0;
		DatObjWrapper.IN.CMD.SaveAs:=	0;
	END_IF

#Reference

##DatObjWrapper Data Structure
The main data structure of the DatObjWrap library is the DatObjWrapper structure (DatObjWrap_typ datatype). This provides the interface to higher level programs and also stores all necessary internal information. It is divided into inputs (DatObjWrapper.IN), outputs (DatObjWrapper.OUT), and internals (DatObjWrapper.Internal).

###Inputs
The DatObjWrapper inputs are divided into commands (IN.CMD) and parameters (IN.PAR). Commands are used to initiate operations, and parameters determine how the commands will be processed.

####Commands
* **Open** - Read data from a data object.
* **SaveAs** - Save data to a data object.
* **AcknowledgeError** - Acknowledge any errors that occur during Open or SaveAs operations.

####Parameters
* **DataObjName** - Name of the data object to Open or SaveAs.
* **pData** - Starting address of the data buffer. For Open operations, data will be copied from the data object to pData. For SaveAs operations, data will be copied from pData to the data object.
* **len** - Length of the data to be copied, in bytes.

###Outputs
The DatObjWrapper outputs contain status information (OUT.STAT).

* **Busy** - Operation is currently being processed.
* **Done** - Operation completed successfully. **Done** is reset when the input command is reset.
* **Error** - Error occurred during operation. **Error** is reset with the **AcknowledgeError** command.
* **ErrorID** - Current error ID number.
* **ErrorString** - Current error text information.
* **ErrorLevel** - Current error level.
* **ErrorState** - State in which the error occurred.

##Error ID Numbers
* 20600 - doERR_ILLPARAMETER - Invalid parameter. Check IN.PAR.pData.
* 20601 - doERR_DUPOBJECT - Object already present.
* 20602 - doERR_ILLMEMTYPE - Invalid memory type.
* 20603 - doERR_NOMEMORY - No memory available for object.
* 20604 - doERR_BRINSTALL - Error installing data object.
* 20605 - doERR_ILLOBJECT - Data object not found. Check IN.PAR.DataObjName.
* 20606 - doERR_ILLOBJTYPE - Object found, but it was not a data object. Check IN.PAR.DataObjName.
* 20607 - doERR_WRONGOFFSET - Invalid offset specified.
* 20608 - doERR_ILLEGALLENGTH - Invalid length specified. Check IN.PAR.len.
* 20609 - doERR_MODULNOTFOUND - Data object not found. Check IN.PAR.DataObjName.
* 20610 - doERR_WRONGTIME - Invalid date set.
* 20611 - doERR_ILLSTATE - Data object not in correct state.
* 20612 - doERR_STARTHANDLER - System error.
* 20613 - doERR_TOOLONG_MODULNAME - Data object name is too long. Check IN.PAR.DataObjName.
* 20614 - doERR_BURNINGOBJECT - System error.

These error ID numbers are passed on directly from the DataObj library. For additional information, please see the Automation Studio Online Help.