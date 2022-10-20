
#include "hbcurl.ch"

Function Main()

local l_pCurlHandle
local l_aHeaderParameter := {}
local l_nResult
local l_cResult
local l_cURL
local l_oAPIReturn

// If in docker, due to a bug in not being able to lock records of shared tables on a mounted volume, the cPath should be on its OS tree structure.
if GetEnv("InDocker") == "True"  // Environment Variable is set in the Dockerfile
    cPath := "/Tables/"
    ?"In Docker"
endif

?"ClientAPI"
?



l_cURL := "https://api.zippopotam.us/us/90210"


// l_cURL := "http://host.docker.internal:8164/fcgi_DataWharf/api/applicationInformation"
// AAdd(l_aHeaderParameter,"AccessToken: 0123456789")



if empty(Curl_Global_Init())
    ? curl_version()
    l_pCurlHandle := curl_easy_init()
    if !hb_IsNil(l_pCurlHandle)
        ?"Got a connection"

        //  {"Accept: application/json", "Content-Type: application/json"}
        

        if !empty(l_aHeaderParameter)
            Curl_Easy_SetOpt(l_pCurlHandle, HB_CURLOPT_HTTPHEADER,l_aHeaderParameter)
        endif

        // Curl_Easy_SetOpt(l_pCurlHandle, HB_CURLOPT_URL, "localhost:8164/fcgi_DataWharf/api/applicationInformation")
        // Curl_Easy_SetOpt(l_pCurlHandle, HB_CURLOPT_URL, "http://host.docker.internal:8164/fcgi_DataWharf/api/applicationInformation")

        //Inside of Docker container "localhost" must be "host.docker.internal"

        Curl_Easy_SetOpt(l_pCurlHandle, HB_CURLOPT_URL, l_cURL)


        Curl_Easy_SetOpt(l_pCurlHandle, HB_CURLOPT_DL_BUFF_SETUP , 100*1024)  // Max Buffer download size set to 100 Kb

        altd()
        l_nResult := Curl_Easy_Perform(l_pCurlHandle)

        if empty(l_nResult)
            l_cResult := curl_easy_dl_buff_get( l_pCurlHandle )
        else
            l_cResult := Alltrim(Str( l_nResult, 5 )) + " " + curl_easy_strerror( l_nResult )
        endif
        ?l_cResult


        // hb_jsonDecode(l_cResult,@l_oAPIReturn,[<cdpID>]) ➔ <nLengthDecoded>
        ?"Result Length = ",hb_jsonDecode(l_cResult,@l_oAPIReturn)
        altd()

        curl_easy_cleanup(l_pCurlHandle)
    endif
    Curl_Global_Cleanup()
endif

RETURN nil
//=================================================================================================================
//=================================================================================================================
//=================================================================================================================
//v17