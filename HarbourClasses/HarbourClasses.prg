#include "hbclass.ch"

Function Main()
local oCar1 := Cars()
local oCar2 := Cars()

altd()

oCar1:Model := "Subaru"
oCar1:SetMaxSpeed(8)
oCar1:Drive(5)
oCar1:ExtraMethod()

with object oCar2
    :Model := "Ford"
    :SetMaxSpeed(10)
    :Drive(7)
endwith

?

RETURN nil
//====================================================================================
class Cars 
hidden:
    data Max_Speed init 0          // Should be value from 1 to 10
    data Version   init "1.0"

exported:
    data Model     init "Unknow"

    method SetMaxSpeed(par_speed)
    method Drive(par_Distance)

    method InitClass()

    method new()
    method init()

    method ExtraMethod()

    DESTRUCTOR destroy
endclass

method InitClass() class Cars
?"Called class InitClass"
return self


method new() class Cars
?"Called class new"
return self

method init() class Cars
?"Called class init"
return self


method SetMaxSpeed(par_speed) class Cars
::Max_Speed := min(10,max(1,par_speed))
return NIL

method Drive(par_Distance) class Cars
local iActualDistance := min(20,max(1,par_Distance))   // At least 1 and max 20
local iCounter
?"Driving "+::Model+" "
for iCounter = 1 to iActualDistance
    hb_idleSleep((11-::Max_Speed)/10)
    ??"-"
endfor
return NIL


method destroy() class Cars
?"Called class destroy for model "+::Model
return NIL
//====================================================================================

#include "HarbourClasses_Extra1.prg"

//====================================================================================
