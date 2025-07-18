Class extends _GoogleAPI

property page : Integer
property isLastPage : Boolean
property statusText : Text
property success : Boolean
property errors : Collection

Class constructor($inProvider : cs.OAuth2Provider; $inParameters : Object)
	
	Super($inProvider)
	
	If ((Value type($inParameters.url)=Is text) && (Length($inParameters.url)>0))
		This._internals._URL:=$inParameters.url
	End if 
	This._internals._headers:=(Value type($inParameters.headers)=Is object) ? $inParameters.headers : Null
	This._internals._elements:=((Value type($inParameters.elements)=Is text) && (Length($inParameters.elements)>0)) ? $inParameters.elements : "items"
	This._internals._attributes:=(Value type($inParameters.attributes)=Is collection) ? $inParameters.attributes : Null
	This._internals._nextPageToken:=""
	This._internals._history:=[]
	This._internals._throwErrors:=False
	
	This.page:=1
	This.isLastPage:=False
	
	This._getList()
	
	
	// Mark: - [Private]
	// ----------------------------------------------------
	
	
Function _getList($inPageToken : Text) : Boolean
	
	var $URL : cs.URL:=cs.URL.new(This._internals._URL)
	
	If (Length(String($inPageToken))>0)
		$URL.addQueryParameter("pageToken"; inPageToken)
	End if 
	
	Super._throwErrors(False)
	var $response : Object:=Super._sendRequestAndWaitResponse("GET"; $URL.toString(); This._internals._headers)
	Super._throwErrors(True)
	
	This.isLastPage:=False
	This.statusText:=Super._getStatusLine()
	This.success:=False
	This._internals._nextPageToken:=""
	This._internals._list:=[]
	
	If ($response#Null)
		
		If (OB Is defined($response; This._internals._elements))
			This._internals._list:=OB Get($response; This._internals._elements; Is collection)
		End if 
		
		If (This._internals._attributes#Null)
			var $attribute : Text
			For each ($attribute; This._internals._attributes)
				
				If (OB Is defined($response; $attribute))
					This[$attribute]:=OB Get($response; $attribute)
				End if 
			End for each 
		End if 
		
		This.success:=True
		This._internals._history.push($inPageToken)
		This._internals._nextPageToken:=String($response.nextPageToken)
		This.isLastPage:=(Length(This._internals._nextPageToken)=0)
		
		return True
		
	Else 
		
		var $errorStack : Collection:=Super._getErrorStack()
		
		If ($errorStack.length>0)
			This.errors:=$errorStack
			This.statusText:=$errorStack.first().message
		End if 
		
		return False
	End if 
	
	
	// Mark: - [Public]
	// ----------------------------------------------------
	
	
Function next() : Boolean
	
	var $pageToken : Text:=String(This._internals._nextPageToken)
	
	If (Length($pageToken)>0)
		
		If (This._getList($pageToken))
			
			This.page+=1
			return True
		End if 
		
	Else 
		
		This.statusText:=Localized string("List_No_Next_Page")
		This.isLastPage:=True
	End if 
	
	return False
	
	
	// ----------------------------------------------------
	
	
Function previous() : Boolean
	
	If ((Num(This._internals._history.length)>0) && (This.page>1))
		
		var $index : Integer:=This.page-1
		var $pageToken : Text:=String(This._internals._history[$index-1])
		
		If (This._getList($pageToken))
			
			This.page-=1
			This._internals._history.resize(This.page)
			This.isLastPage:=(This.page<=1)
			
			return True
		End if 
		
	Else 
		
		This.statusText:=Localized string("List_No_Previous_Page")
		This.isLastPage:=True
	End if 
	
	return False
