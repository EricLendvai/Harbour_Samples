//Copyright (c) 2022 Eric Lendvai MIT License

#include "hb_fcgi.ch"

// Following was used to test memory consuption under Docker
// static aFiller[0]

//=================================================================================================================
Function Main()

local cHtml
// local cCrash  // To test the error handler

SendToDebugView("Starting echo")

private oFcgi
// oFcgi := hb_Fcgi():New()
oFcgi := MyFcgi():New()    // Used a subclass of hb_Fcgi

do while oFcgi:Wait()
    oFcgi:OnRequest()
enddo

SendToDebugView("Done")

return nil
//=================================================================================================================
class MyFcgi from hb_Fcgi
    method OnFirstRequest()
    method OnRequest()
    method OnShutdown()
endclass
//-----------------------------------------------------------------------------------------------------------------
method OnFirstRequest() class MyFcgi
    SendToDebugView("Called from method OnFirstRequest")
return nil 
//-----------------------------------------------------------------------------------------------------------------
method OnShutdown() class MyFcgi
    SendToDebugView("Called from method OnShutdown")
return nil 
//-----------------------------------------------------------------------------------------------------------------
method OnRequest() class MyFcgi
    local cHtml

    SendToDebugView("Request Counter",::RequestCount)

    ::Print([<!DOCTYPE html><html><body>])

    // Following can be used to test the VSCODE debugger
    altd()
    //cCrash++    // To test the error handler


    // if empty(mod(::RequestCount,100))
    //     ASize(aFiller,0)
    // endif
    // AAdd(aFiller,space(1000000))

    ::Print("<h1>FastCGI echo</h1>")

    ::Print("<p>FastCGI EXE = "+::FastCGIExeFullPath+"</p>")
    cHtml := [<table border="1" cellpadding="3" cellspacing="0">]
    cHtml += [<tr><td>Protocol</td>]     +[<td>]+::RequestSettings["Protocol"]+[</td></tr>]
    cHtml += [<tr><td>Port</td>]         +[<td>]+trans(::RequestSettings["Port"])+[</td></tr>]
    cHtml += [<tr><td>Host</td>]         +[<td>]+::RequestSettings["Host"]+[</td></tr>]
    cHtml += [<tr><td>Site Path</td>]    +[<td>]+::RequestSettings["SitePath"]+[</td></tr>]
    cHtml += [<tr><td>Path</td>]         +[<td>]+::RequestSettings["Path"]+[</td></tr>]
    cHtml += [<tr><td>Page</td>]         +[<td>]+::RequestSettings["Page"]+[</td></tr>]
    cHtml += [<tr><td>Query String</td>] +[<td>]+::RequestSettings["QueryString"]+[</td></tr>]
    cHtml += [<tr><td>Web Server IP</td>]+[<td>]+::RequestSettings["WebServerIP"]+[</td></tr>]
    cHtml += [<tr><td>Client IP</td>]    +[<td>]+::RequestSettings["ClientIP"]+[</td></tr>]
    cHtml += [</table>]
    ::Print(cHtml)

    // ::Print([<p>]+::GenerateRandomString(16,"01234567890ABCDEF")+[</p>])

// altd()

// cCrash += 0

    ::Print("<p>Request Count = "+Trans( ::RequestCount )+"</p>")
    ::Print("<p>Input Length  = "+Trans( ::GetInputLength() )+"</p>")

    // Following will be abstracted to assist in making FastCGI platform independent.


    ::Print([<p>Input Field "FirstName" = ]+::GetInputValue("FirstName")+[</p>])
    ::Print([<p>Input Field "LastName" = ]+::GetInputValue("LastName")+[</p>])
    ::Print([<p>Input Field "NotExistingValue" = ]+::GetInputValue("Bogus")+[</p>])

    ::Print([<p>Uploaded File Name "File1" = ]+::GetInputFileName("File1")+[</p>])
    ::Print([<p>Uploaded File Content Type "File1" = ]+::GetInputFileContentType("File1")+[</p>])

    ::Print("<p>Request Environment:</p>")
    ::Print(::ListEnvironment())

    ::Print([</body></html>])

return nil
//=================================================================================================================
