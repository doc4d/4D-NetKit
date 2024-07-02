property webServer : 4D.WebServer:=WEB Server(Web server database)
property isDebug : Boolean:=False
property trace : Boolean:=False


singleton Class constructor()


// Mark: - [Public]
// ----------------------------------------------------


Function base64UrlSafeDecode($inBase64Encoded : Text) : Text
    
/*
    Largely inspired by UTL_base64UrlSafeDecode.4dm 
    From blegay's acme_component here: https://github.com/blegay/acme_component
    
    MIT License
    
    Copyright (c) 2020 blegay
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/
    
    var $outDecodedString : Text
    
    If (Asserted(Count parameters>0; "requires 1 parameter"))
        
        // replace the "\r" and "/n" we may find...
        $inBase64Encoded:=Replace string($inBase64Encoded; "\r"; ""; *)
        $inBase64Encoded:=Replace string($inBase64Encoded; "\n"; ""; *)
        
        $inBase64Encoded:=Replace string($inBase64Encoded; "_"; "/"; *)  // convert "_" to "/"
        $inBase64Encoded:=Replace string($inBase64Encoded; "-"; "+"; *)  // convert "-" to "+"
        
        // if the base64 encoded does not contain the padding characters ("="), lets add them
        // base64 encoded data should have a length multiple of 4
        var $padModulo : Integer:=Mod(Length($inBase64Encoded); 4)
        If ($padModulo>0)
            $inBase64Encoded:=$inBase64Encoded+((4-$padModulo)*"=")
        End if 
        
        BASE64 DECODE($inBase64Encoded; $outDecodedString)  // decode to plain text
        
    End if 
    
    return $outDecodedString
    
    
    // ----------------------------------------------------
    
    
Function camelCase($inString : Text)->$result : Text
    
    var $string : Text:=Lowercase($inString; *)
    var $wordSep : Text:=" ,;:=?./\\±_@#&(!)*+=%\t\r\n"
    var $uppercase : Boolean:=False
    var $length : Integer:=Length($string)
    var $i : Integer
    $result:=""
    
    For ($i; 1; $length)
        
        var $char : Text:=Substring($string; $i; 1)
        
        Case of 
            : (Position($char; $wordSep; *)>0)
                $uppercase:=True
                
            Else 
                If ($uppercase)
                    $result:=$result+Uppercase($char)
                Else 
                    $result:=$result+$char
                End if 
                $uppercase:=False
        End case 
    End for 
    
    
    // ----------------------------------------------------
    
    
Function convertToGraphAttachment($inObject : cs.GraphAttachment)->$result : Object
    
    // converts cs.GraphAttachment into microsoft.graph.fileAttachment
    If (OB Instance of($inObject; cs.GraphAttachment))
        
        $result:={}
        $result["@odata.type"]:=(Length(String($inObject["@odata.type"]))>0) ? \
         $inObject["@odata.type"] : "#microsoft.graph.fileAttachment"
        If (Length(String($inObject.cid))>0)
            $result.contentId:=String($inObject.cid)
        End if 
        If (String($inObject.disposition)="inline")
            $result.isInline:=True
        End if 
        If (Length(String($inObject.name))>0)
            $result.name:=String($inObject.name)
        End if 
        If (Length(String($inObject.type))>0)
            $result.contentType:=String($inObject.type)
        End if 
        If (Not(OB Is defined($inObject; "contentBytes")))
            var $blob : Blob:=$inObject.getContent()
        End if 
        $result.contentBytes:=$inObject.contentBytes
        $result.size:=$inObject.size
        
    End if 
    
    return $result
    
    
    // ----------------------------------------------------
    
    
Function getErrorStack() : Object
    
    C_LONGINT(Error; Error line; $i)
    C_TEXT(Error method; Error formula)
    
    return {error: Error; line: Error line; method: Error method; formula: Error formula; errors: Last errors}
    
    
    // ----------------------------------------------------
    
    
Function getHeaderValueParameter($headerValue : Text; $paramName : Text; $defaultValue : Text)->$paramValue : Text
    
    $paramValue:=This.getParameterValue($headerValue; $paramName)
    If (Length($paramValue)=0)
        $paramValue:=$defaultValue
    End if 
    
    
    // ----------------------------------------------------
    
    
Function getParameterValue($headerValue : Text; $paramName : Text)->$paramValue : Text
    
    ARRAY LONGINT($foundPosArr; 0)
    ARRAY LONGINT($foundLenArr; 0)
    
    var $pattern : Text:=$paramName+"=(\"|)([A-Za-z0-9-\\/\\:;??=&\\.]+)(\"|)"
    var $startPos; $endPos : Integer
    
    If (Match regex($pattern; $headerValue; 1; $foundPosArr; $foundLenArr))
        If (Size of array($foundPosArr)=3)
            If ($foundLenArr{2}>0)
                $startPos:=$foundPosArr{2}
                $endPos:=$startPos+$foundLenArr{2}
            End if 
        End if 
    End if 
    If (($startPos>0) && ($endPos>$startPos))
        $paramValue:=Substring($headerValue; $startPos; $endPos-$startPos)
    End if 
    
    
    // ----------------------------------------------------
    
    
Function getJMAPAttribute($inKey : Text) : Text
    
    Case of 
        : ($inKey="id")
            return "id"
        : ($inKey="threadId")
            return "threadId"
        : ($inKey="sizeEstimate")
            return "size"
        : ($inKey="snippet")
            return "preview"
        : ($inKey="Date")
            return "receivedAt"
        : ($inKey="Subject")
            return "subject"
        : ($inKey="labelIds")
            return "mailboxIds"
        : ($inKey="Message-Id")
            return "messageId"
        : ($inKey="Message-Id")
            return "messageId"
        : ($inKey="From")
            return "from"
        : ($inKey="Sender")
            return "sender"
        : ($inKey="To")
            return "to"
        : ($inKey="Cc")
            return "cc"
        : ($inKey="Reply-To")
            return "replyTo"
        : ($inKey="In-Reply-To")
            return "inReplyTo"
        : ($inKey="Keywords")
            return "keywords"
    End case 
    
    return ""
    
    
    // ----------------------------------------------------
    
    
Function getPathFromURL($URL : Text)->$path : Text
    
    ARRAY LONGINT($pos; 0)
    ARRAY LONGINT($len; 0)
    
    var $pattern : Text:="(?mi-s)^(https?|wss?)://.*(:\\d*)(/?.*)"  //was "(?mi-s)^(?:https?:\\/\\/)?(?:[^?\\/\\s]+[?\\/])(.*)"
    
    If (Match regex($pattern; $URL; 1; $pos; $len))
        
        If (Size of array($pos)>2)
            $path:=Substring($URL; $pos{3}+1; $len{3}-1)
        End if 
        
        $path:="/"+$path
        
    End if 
    
    
    // ----------------------------------------------------
    
    
Function getPortFromURL($URL : Text)->$port : Integer
    
    ARRAY LONGINT($pos; 0)
    ARRAY LONGINT($len; 0)
    
    var $pattern : Text:="(?mi-s)^(https?|wss?)://.*(:\\d*)/?.*"
    
    If (Match regex($pattern; $URL; 1; $pos; $len))
        
        var $scheme : Text
        
        $scheme:=Substring($URL; $pos{1}; $len{1})
        If (Size of array($pos)>1)
            $port:=Num(Substring($URL; $pos{2}+1; $len{2}-1))
        Else 
            $port:=Choose((($scheme="http") | ($scheme="ws")); 80; 443)
        End if 
        
    Else 
        $port:=Choose((($URL="http:@") | ($URL="ws:@")); 80; 443)
    End if 
    
    
    // ----------------------------------------------------
    
    
Function getURLParameterValue($URL : Text; $paramName : Text)->$paramValue : Text
    
    var $posQuery : Integer:=Position("?"; $URL)
    If ($posQuery>0)
        
        var $queryString : Text:=Substring($URL; $posQuery+1)
        var $parameters : Collection:=Split string($queryString; "&"; sk ignore empty strings)
        var $parameter : Text
        
        For each ($parameter; $parameters)
            
            var $values : Collection:=Split string($parameter; "=")
            
            If ($values.length=2)
                If ($values[0]=$paramName)
                    $paramValue:=$values[1]
                    break
                End if 
            End if 
        End for each 
    End if 
    
    
    // ----------------------------------------------------
    
    
Function isEmailAddressHeader($inKey : Text) : Boolean
    
    If (($inKey="From") || \
     ($inKey="Sender") || \
     ($inKey="Reply-To") || \
     ($inKey="To") || \
     ($inKey="Cc") || \
     ($inKey="BCc") || \
     ($inKey="Resent-From") || \
     ($inKey="Resent-Sender") || \
     ($inKey="Resent-Reply-To") || \
     ($inKey="Resent-To") || \
     ($inKey="Resent-Cc") || \
     ($inKey="Resent-BCc"))
        
        return True
        
    End if 
    
    return False
    
    
    // ----------------------------------------------------
    
    
Function startWebServer($inParameters : Object) : Boolean
    
    var $port : Integer:=(Num($inParameters.port)>0) ? Num($inParameters.port) : 50993
    var $bIsSSL : Boolean:=(Value type($inParameters.useTLS)#Is undefined) ? Bool($inParameters.useTLS) : False
    var $debugLog : Integer:=Bool($inParameters.enableDebugLog) ? wdl enable with all body parts : wdl disable web log
    
    If (This.webServer.isRunning)
        If ((This.webServer.HTTPEnabled=$bIsSSL) || ($bIsSSL && (This.webServer.HTTPSPort#$port)) || (Not($bIsSSL) && (This.webServer.HTTPPort#$port)) || (This.webServer.debugLog#$debugLog))
            This.webServer.stop()
            DELAY PROCESS(Current process; 20)
        End if 
    End if 
    
    If (Not(This.webServer.isRunning))
        var $settings : Object:={}
        $settings.HTTPEnabled:=Not($bIsSSL)
        $settings.HTTPSEnabled:=$bIsSSL
        If ($bIsSSL)
            $settings.HTTPSPort:=$port
            $settings.certificateFolder:=Folder("/PACKAGE/"; *)
        Else 
            $settings.HTTPPort:=$port
        End if 
        $settings.debugLog:=$debugLog
        $settings.scalableSession:=False
        $settings.keepSession:=False
        
        If (OB Is defined($inParameters; "webFolder"))
            If (OB Instance of($inParameters.webFolder; 4D.Folder))
                $settings.rootFolder:=$inParameters.webFolder
            Else 
                $settings.rootFolder:=Folder($inParameters.webFolder; fk platform path)
            End if 
        Else 
            $settings.rootFolder:=Folder(fk web root folder; *)
        End if 
        
        var $status : Object:=This.webServer.start($settings)
        
    End if 
    
    return This.webServer.isRunning
    
    
    // ----------------------------------------------------
    
    
Function stopWebServer() : Boolean
    
    If (This.webServer.isRunning)
        This.webServer.stop()
    End if 
    
    return This.webServer.isRunning
    
    
    // ----------------------------------------------------
    
    
Function trimSpaces($inText : Text) : Text
    
    var $startPos : Integer:=1
    var $endPos : Integer:=Length($inText)
    
    While (($startPos<=$endPos) && ($inText[[$startPos]]=" "))
        $startPos+=1
    End while 
    
    While (($endPos>=$startPos) && ($inText[[$endPos]]=" "))
        $endPos-=1
    End while 
    
    return Substring($inText; $startPos; $endPos-$startPos+1)
    
    
    // ----------------------------------------------------
    
    
Function urlDecode($inURL : Text) : Text
    
/*
    Largely inspired from url_decode.4dm by Vincent de Lachaux
    See: https://github.com/4d/4D-SVG project
*/
    var $i : Integer
    var $hexValues : Text:="123456789ABCDEF"
    var $urlLength : Integer:=Length($inURL)
    var $result : Text:=""
    
    For ($i; 1; $urlLength; 1)
        
        If ($inURL[[$i]]="%")
            
            var $c : Integer:=(Position(Substring($inURL; $i+1; 1); $hexValues)*16)+(Position(Substring($inURL; $i+2; 1); $hexValues))
            $result+=Char($c)
            $i+=2
            
        Else 
            
            $result+=$inURL[[$i]]
            
        End if 
    End for 
    
    return $result
    
    
    // ----------------------------------------------------
    
    
Function urlEncode($value : Text) : Text
    
    var $i; $j : Integer
    var $length : Integer:=Length($value)
    var $result : Text:=""
    
    For ($i; 1; $length)
        
        var $char : Text:=Substring($value; $i; 1)
        var $code : Integer:=Character code($char)
        var $shouldEscape : Boolean:=False
        
        Case of 
            : ($code=45)
            : ($code=46)
            : ($code>47) && ($code<58)
            : ($code>63) && ($code<91)
            : ($code=95)
            : ($code>96) && ($code<123)
            : ($code=126)
            Else 
                $shouldEscape:=True
        End case 
        
        If ($shouldEscape)
            var $data : Blob
            CONVERT FROM TEXT($char; "utf-8"; $data)
            For ($j; 0; BLOB size($data)-1)
                var $hex : Text:=String($data{$j}; "&x")
                $result:=$result+"%"+Substring($hex; Length($hex)-1)
            End for 
        Else 
            $result:=$result+$char
        End if 
    End for 
    
    return $result
