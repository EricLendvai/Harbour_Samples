Function Main()

// Notes:
// To avoid unexpected behavior with variables, avoid using PRIVATE,PUBLIC or STATIC variable inside codeblocks.
// Only use variables defined in the parameters list or create new variable as LOCAL.

// For some codeblock internals   https://vivaclipper.wordpress.com/tag/hb_codeblock/

local bAddValues := {|a,b|a-b,a+b}   //Only a+b will be returned, since only the last expression separated by "," is implicitly returned
local bMultiplyValue := {|a,b|
                         return a*b  //A "return" statement is required
                        }
local bComplexCalc := {|a,b,c|       // example of codeblock with conditional statement
                         local iMultiplier := 5
                         local iResult
                         if a > 3
                            iResult := (b+c)*iMultiplier
                         else
                            iResult := 25
                         endif
                         return iResult
                      }

local bDeferredDefinition  // Will be initialized later
local bWithInnerCodeblock := {|a,b|
                                local bMultiplier := {|a,b|a*b}
                                return Eval(bMultiplier,2*a,b)
                             }

local bTestIfParameterByReference := {|a,b|
                                        local iResult:= a+b
                                        a := 100
                                        return iResult
                                     }

local bChangeArray := {|aArray,xRow,yCol,Value|aArray[xRow,yCol] := Value,nil}   // Will set the value of an Array cell. Arrays are always passed by reference.

local iTestVariable

local aTest1 := {}   // Empty Array

?"Should be 8 => ",Eval(bAddValues,3,5)
?"Should be 15 => ",Eval(bMultiplyValue,3,5)
?"Complex Calc of 1,2,4 => ",Eval(bComplexCalc,1,2,4)
?"Complex Calc of 11,2,4 => ",Eval(bComplexCalc,11,2,4)

bDeferredDefinition := {|a,b|
                        return a+b*3
                       }

?"Should be 7 => ",Eval(bDeferredDefinition,1,2)

?"Should be 48 => ",Eval(bWithInnerCodeblock,4,6)

?"Should be 28 => ",ApplyCode(bMultiplyValue,4,7)   //Passed by value
?"Should be 28 => ",ApplyCode(@bMultiplyValue,4,7)  //Passed by reference, which means the codeblock definition will be changed
?"Should be 2800 => ",ApplyCode(bMultiplyValue,4,7)

iTestVariable := 3
?"Should Print 8",Eval(bTestIfParameterByReference,iTestVariable,5)
?"Should Print 3",iTestVariable
?"Should Print 8",Eval(bTestIfParameterByReference,@iTestVariable,5)
?"Should Print 100",iTestVariable


// Create an array and use hb_AScan on search into

AAdd(aTest1,{"Hello",1})
AAdd(aTest1,{"hello world",5})
AAdd(aTest1,{"I said HELLO",40})
AAdd(aTest1,{"It is some JEllo",8})
AAdd(aTest1,{"Hello World",15})
AAdd(aTest1,{"Hello world",16})
Eval(bChangeArray,aTest1,1,2,2)

?"Should be 0 => ",hb_AScan(aTest1,{|aSubArray|aSubArray[1] == "world"})
?"Should be 2 => ",hb_AScan(aTest1,{|aSubArray|"world" $ aSubArray[1]})
?"Should be 6 => ",hb_AScan(aTest1,{|aSubArray|"world" $ aSubArray[1] .and. aSubArray[2] > 10})   // Example of multi-column condition

Eval(bChangeArray,aTest1,2,2,20)
?"Should be 2 => ",hb_AScan(aTest1,{|aSubArray|"world" $ aSubArray[1] .and. aSubArray[2] > 10})

RETURN nil
//====================================================================================
function ApplyCode(bCodeBlock,par1,par2)
local xResult := Eval(bCodeBlock,par1,par2)
bCodeBlock := {|a,b|a*b*100}
return xResult
//====================================================================================
