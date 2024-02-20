#include "dbinfo.ch"

#xtranslate el_dbf()         => DBINFO(DBI_FULLPATH)
#xtranslate el_dbf(<xAlias>) => (<xAlias>)->(DBINFO(DBI_FULLPATH))

request DBFCDX
request DBFFPT
request HB_CODEPAGE_EN

Function Main()

local l_lInDocker := (hb_GetEnv("InDocker","False") == "True") .or. File("/.dockerenv")

local aTableContactStructure := {;
          {"KEY"      ,"I:+", 4,0},;
          {"FIRSTNAME","C"  ,60,0},;
          {"LASTNAME" ,"C"  ,60,0},;
          {"NOTE"     ,"M"  , 4,0},;
          {"DOB"      ,"D"  , 8,0}}

local aTableCallLogStructure := {;
          {"KEY"       ,"I:+", 4,0},;
          {"FK_CONTACT","I",   4,0},;
          {"NOTE"      ,"M"  , 4,0},;
          {"TIME"      ,"T",   0,0},;
          {"DATETIME"  ,"@",   0,0}}

local cPath := "."+hb_ps()+"Tables"+hb_ps()   // hb_ps() will return "/" or "\" depending of the OS.
local cContactTableName := "Contact"
local cCallLogTableName := "CallLog"
local iKey
local xValue

altd()

// If in docker, due to a bug in not being able to lock records of shared tables on a mounted volume, the cPath should be on its OS tree structure.
if l_lInDocker
    cPath := "/Tables/"
    ?"In Docker"
endif

hb_DirCreate(cPath)  // To ensure with have a separate folder for tables.

RddSetDefault("DBFCDX")
rddInfo( RDDI_TABLETYPE, DB_DBF_VFP )
Set(_SET_CODEPAGE,"EN")

hb_FileDelete(cPath+cContactTableName+".*")
hb_FileDelete(cPath+cCallLogTableName+".*")

// Documention: 
//  dbCreate(<cFileName>,<aStruct>,[<cRDD>],[<lKeepOpen>],[<cAlias>],[<cDelimArg>],[<cCodePage>],[<nConnection>]) -> <lSuccess>
//  dbUseArea([<lNewArea>],[<cRddName>],[<cDatabase>],[<cAlias>],[<lShared>],[<lReadOnly>],[<cCodePage>],[<nConnection>]) -> <lSuccess>

CreateTableAsNeeded(cPath+cContactTableName+".dbf",aTableContactStructure)
if !file(cPath+cContactTableName+".cbx")
    dbUseArea(.t.,"DBFCDX", cPath+cContactTableName+".dbf", "Contact", .f., .f., "EN")  // Opened in any open workarea, shared and read-write mode.
    select Contact
    OrdCreate( cPath+cContactTableName+".cdx", "tag1", "upper(FIRSTNAME+LASTNAME)",,.f.)
    OrdCreate( cPath+cContactTableName+".cdx", "tag2", "upper(LASTNAME+FIRSTNAME)",,.f.)
    dbCloseArea()
endif

CreateTableAsNeeded(cPath+cCallLogTableName+".dbf",aTableCallLogStructure)

dbUseArea(.t.,"DBFCDX", cPath+cContactTableName+".dbf", "MyContactsByFirstName", .t., .f., "EN")  // Opened in any open workarea, shared and read-write mode.
SET ORDER TO TAG tag1   // same as ordSetFocus( "tag1" )

dbUseArea(.t.,"DBFCDX", cPath+cContactTableName+".dbf", "MyContactsByLastName", .t., .f., "EN")  // Opened in any open workarea, shared and read-write mode.
ordSetFocus( "tag2" )

dbUseArea(.t.,"DBFCDX", cPath+cCallLogTableName+".dbf", "CallLog"   , .t., .f., "EN")  // Opened in any open workarea, shared and read-write mode.
?"Alias() = ",Alias()  //Is returned as upper case
?"el_dbf('MyContactsByFirstName') = ",el_dbf('MyContactsByFirstName')
?"el_dbf('CallLog') = "   ,el_dbf('CallLog')
?'ValType(CallLog->note) = ', ValType(CallLog->note)
xValue := CallLog->note
?'xValue := CallLog->note + ValType(xValue) = ', ValType(xValue)
?'ValType(CallLog->time) = ', ValType(CallLog->time)
?'ValType(CallLog->datetime) = ', ValType(CallLog->datetime)


// //Currently the following will fail in Dev Container / Ubuntu
// altd()

// ?"List By First Name"
// select MyContactsByFirstName
// dbGoTop()
// do while !eof()
//     ?left(field->FirstName,30),left(field->LastName,30),field->dob
//     dbSkip()
// enddo

// dbGoTop()
// altd()
// // ?dbRLock()   //Will fail on the mounted drive.
// field->FirstName := "bogus"


select MyContactsByFirstName
if dbappend()
    field->FirstName := "Albert"
    field->LastName  := "Einstein"
    field->dob       :=ctod("03/14/1879")
    dbRUnlock()
    iKey := Field->key

    //Add a Cal log and link it to Albert
    if CallLog->(dbappend())
        CallLog->fk_contact := iKey
        CallLog->time       := hb_datetime()
        CallLog->note       := "Congratulated him on theory of relativity"
        CallLog->(dbRUnlock())
    endif

    if dbappend()  //Still on the MyContactsByFirstName workarea
        field->FirstName := "Marie"
        field->LastName  := "Currie"
        field->dob       :=ctod("11/07/1867")
        dbRUnlock()
    endif
  
    if dbappend()  //Still on the MyContactsByFirstName workarea
        field->FirstName := "Gordon"
        field->LastName  := "Sumner"
        field->dob       :=ctod("10/02/1951")
        field->note      := "Full name: Gordon Matthew Thomas Sumner, aka - Sting the singer."
        dbRUnlock()
    endif

else
    ? [Failed to add record!]
endif
?
?"List By First Name"
select MyContactsByFirstName
dbGoTop()
do while !eof()
    ?left(field->FirstName,30),left(field->LastName,30),field->dob
    dbSkip()
enddo
?
?"List By Last Name"
select MyContactsByLastName
dbGoTop()
do while !eof()
    ?left(field->FirstName,30),left(field->LastName,30),field->dob
    dbSkip()
enddo

MyContactsByFirstName->(dbCloseArea())
MyContactsByLastName->(dbCloseArea())
CallLog->(dbCloseArea())

RETURN nil
//=================================================================================================================
function CreateTableAsNeeded(par_cTableFullName,par_aStructure)
if !file(par_cTableFullName)
    select 0
    DbCreate(par_cTableFullName,par_aStructure,"DBFCDX",.f.,,,"EN")
    if used()  // Even though specified to no keep open, it is still left open for VFP DBFs it seems. Will close it since we want it to be open in shared mode.
        dbCloseArea()
    endif
    SetTableCodePageToEN(par_cTableFullName+".dbf")  // Needed to fix VFP dbf codepage
endif
return nil
//=================================================================================================================
function SetTableCodePageToEN(par_TableFullPath)
local nFileHandle
//Mark Codepage flag as "EN"
nFileHandle := FOpen(par_TableFullPath)
if nFileHandle >= 0
    FSeek(nFileHandle,29)
    FWrite(nFileHandle,chr(1),1)
    FClose(nFileHandle)
endif
return nil
//=================================================================================================================
