# Office365 class

## Overview

The `Office365` class allows you to call the [Microsoft Graph API](https://docs.microsoft.com/en-us/graph/overview#data-and-services-powering-the-microsoft-365-platform) to:
* get information from Office365 applications, such as user information
* create, move or send emails

This can be done after a valid token request, (see [OAuth2Provider object](#oauth2provider)).

The `Office365` class can be instantiated in two ways:
* by calling the `New Office365 provider` method
* by calling the `cs.NetKit.Office365.new()` function

**Warning:** Shared objects are not supported by the 4D NetKit API.


## Table of Contents 

### [Initialization](##new-office365-provider) 

* [New Office365 provider](#new-office365-provider)

###  [Calendar](#calendar-1) 

* [Office365.calendar.getCalendar()](#office365calendargetcalendar)
* [Office365.calendar.getCalendars()](#office365calendargetcalendars)
* [Office365.calendar.getEvent()](#office365calendargetevent)
* [Office365.calendar.getEvents()](#office365calendargetevents)
* [Office365.calendar.createEvent()](#office365calendarcreateevent)
* [Office365.calendar.updateEvent()](#office365calendarupdateevent)
* [Office365.calendar.deleteEvent()](#office365calendardeleteevent)
* [Office365.category.list()](#office365categorylist)
* [Event object](#event-object)

###  [Mail](#mail-1) 

* [Office365.mail.send()](#office365mailsend)
* [Office365.mail.append()](#office365mailappend)
* [Office365.mail.update()](#office365mailupdate)
* [Office365.mail.reply()](#office365mailreply)
* [Office365.mail.createFolder()](#office365mailcreatefolder)
* [Office365.mail.renameFolder()](#office365mailrenamefolder)
* [Office365.mail.deleteFolder()](#office365maildeletefolder)
* [Office365.mail.getFolder()](#office365mailgetfolder)
* [Office365.mail.getFolderList()](#office365mailgetfolderlist)
* [Office365.mail.getMail()](#office365mailgetmail)
* [Office365.mail.getMails()](#office365mailgetmails)
* [Office365.mail.move()](#office365mailmove)
* [Office365.mail.copy()](#office365mailcopy)
* [Office365.mail.delete()](#office365maildelete)
* [Well-known folder names](#well-known-folder-names)
* ["Microsoft" mail object properties](#microsoft-mail-object-properties)

### [User](#user-1) 

* [Office365.user.get()](#office365userget)
* [Office365.user.getCurrent()](#office365usergetcurrent)
* [Office365.user.list()](#office365userlist)

### [Status](#status-object) 

* [Status object (Office365 Class)](#status-object)


## **New Office365 provider**

**New Office365 provider**( *paramObj* : Object { ; *param* : Object } ) : cs.NetKit.Office365

### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|paramObj|cs.NetKit.OAuth2Provider|->| Object of the OAuth2Provider class  |
|param|Object|->| Additional options |
|Result|cs.NetKit.Office365|<-| Object of the Office365 class|

### Description

`New Office365 provider` instantiates an object of the `Office365` class.

In `paramObj`, pass an [OAuth2Provider object](#new-auth2-provider).

In `param`, you can pass an object that specifies the following options:

|Property|Type|Description|
|---------|---|------|
|mailType|Text|Indicates the Mail type to use to send and receive emails. Possible types are: <br/>- "MIME"<br/>- "JMAP"<br/>- "Microsoft" (default)|

### Returned object

The returned `Office365` object contains the following properties:

|Property||Type|Description|
|----|-----|---|------|
|mail||Object|Email handling object|
||send()|Function|Sends the emails|
||type|Text|(read-only) Mail type used to send and receive emails. Default is "Microsoft", can bet set using the `mailType` option|
||userId|Text|User identifier, used to identify the user in Service mode. Can be the `id` or the `userPrincipalName`|


### Example 1

To create the OAuth2 connection object and an Office365 object:

```4d
var $oAuth2: cs.NetKit.OAuth2Provider
var $office365 : cs.NetKit.Office365

$oAuth2:=New OAuth2 provider($param)
$office365:=New Office365 provider($oAuth2;New object("mailType"; "Microsoft"))
```

### Example 2

Refer to [this tutorial](#authenticate-to-the-microsoft-graph-api-in-service-mode) for an example of connection in Service mode.

## Calendar

### Office365.calendar.getCalendar()

**Office365.calendar.getCalendar**({*id*: Text}) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|id|Text|->|ID of the calender to retrieve.|
|calendar|Object|<-|[Object](https://learn.microsoft.com/en-us/graph/api/resources/calendar?view=graph-rest-1.0#properties) containing the properties and relationships of the specified calendar.  |

> To retrieve calendar IDs call the getCalendars() function. If id is null, empty or missing, returns the primary calendar of the currently logged in user.

#### Description

`Office365.calendar.getCalendar()` retrieves the properties and relationships of a specific calendar associated with the passed `id` and returns a `calendar` object containing the requested calendar's details.

#### Example

```4d
var $oAuth2 : cs.NetKit.OAuth2Provider 
var $Office365 : cs.NetKit.Office365
var $params; $calendarList; $calendarA : Object

// Set up parameters:
$params:=New object
$params.name:="Microsoft"
$params.permission:="signedIn"
$params.clientId:="your-client-id" // Replace with your Microsoft identity platform client ID
$params.redirectURI:="http://127.0.0.1:50993/authorize/"
$params.scope:="https://graph.microsoft.com/.default"

// Create an OAuth2Provider Object
$oAuth2:=New OAuth2 provider($params)

// Create an Office365 object
$Office365:=New Office365 provider($oAuth2)


// Retrieve the entire list of calendars
$calendarList:=$Office365.calendar.getCalendars()

// Retrieve the first calendar in the list using its ID
$calendarA:=$Office365.calendar.getCalendar($calendarList.calendars[0].id)

```

### Office365.calendar.getCalendars()

**Office365.calendar.getCalendars**({*param*: Object}) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|param|Object|->|Set of options to filter, order, or select specific calendar properties.|
|result|Object|<-| Object containing the retrieved calendars and related data.|

#### Description

`Office365.calendar.getCalendars()` retrieves a collection of the user's calendars. 

In *param*, you can pass the following optional properties:

| Property | Type | Description |
|---|---|---|
|select| Text | Specifies which calendar properties (columns) to retrieve. Comma-separated values.|
|orderby | Text | Specifies the order of the returned results. Syntax is property name followed by `asc` (ascending) or `desc` (descending).|
|filter| Text  | OData filter expression to filter the results. For example: `"name eq 'Work'"` retrieves calendars with the name "Work". |

#### Returned object

The function returns an object containing the following properties:

| Property | Type | Description |
|---|---|---|
|calendars| Collection  | Collection of calendar objects retrieved from the user's account. Each calendar object contains properties such as `id`, `name`, and `owner`.                               |
|statusText| Text | Status message returned by the Microsoft server or the last error message from the 4D error stack.|                                                                          
|success| Boolean | `True` if the operation is successful, `False` otherwise.|
|errors | Collection | Collection of 4D error items (if any):|                                                                                                                                  
|   | | - `.errcode`: 4D error code number.|                                                                                                                                         
|  | | - `.message`: Error description.|                                                                                                                                           
| |  | - `.componentSignature`: Signature of the component that returned the error.|                                                                                                                                                                                                              

#### Example

```4d
var $oAuth2 : cs.NetKit.OAuth2Provider
var $Office365 : cs.NetKit.Office365
var $params; $calendarList : Object

// Set up parameters:
$params:=New object
$params.name:="Microsoft"
$params.permission:="signedIn"
$params.clientId:="your-client-id" // Replace with your Microsoft identity platform client ID
$params.redirectURI:="http://127.0.0.1:50993/authorize/"
$params.scope:="https://graph.microsoft.com/.default"

// Create an OAuth2Provider Object
$oAuth2:=New OAuth2 provider($params)

// Create an Office365 object
$Office365:=New Office365 provider($oAuth2)

// Retrieve the entire list of calendars
$calendarList:=$Office365.calendar.getCalendars()

```

### Office365.calendar.getEvent()

**Office365.calendar.getEvent**(*param*: Object) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|param|Object|->|Object containing the necessary details to retrieve a specific event|
|result|Object|<-|Object containing the retrieved event|

#### Description

`Office365.calendar.getEvent()` retrieves details of a specific event, including its properties and relationships. The event is identified by its unique `eventId` within the specified calendar.

In *param*, you can pass the following properties:

| Property | Type | Description |
|---|---|---|
| eventId | String |(Required) The unique identifier of the event|
| calendarId | String | Calendar identifier. To retrieve calendar IDs call the calendarList.list(). If not provided, the user's primary (currently logged-in) calendar is used |
| timeZone | String | Time zone used in the response. UTC by default |


#### Returned object

The function returns a Microsoft [`event`](https://learn.microsoft.com/en-us/graph/api/resources/event?view=graph-rest-1.0) object. If the event has attachments, an `attachments` attribute is included, which holds a collection of attachment objects.

### Office365.calendar.getEvents()

**Office365.calendar.getEvents**({*param*: Object}) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|param|Object|->|Object containing filters and options for retrieving calendar events|
|result|Object|<-| Object containing the retrieved events |

#### Description

`Office365.calendar.getEvents()` retrieves events from a specified calendar. By default, events are pulled from the user's primary calendar unless another calendar is specified.

In *param*, you can pass the following optional properties:

| Property | Type | Description |
|---|---|---|
| calendarId | String | Calendar identifier. To retrieve calendar IDs, call Google.Calendar.getCalendars(). If not provided, the user's primary (currently logged-in) calendar is used |
| startDateTime | Text, Object | Filters events by start time. If set, `endDateTime` must also be provided. **Text:** ISO 8601 UTC timestamp (exclusive upper bound). Defaults to no filtering. **Object:** Must contain `date` (date type) and `time` (time type), formatted according to system settings |
| endDateTime | Text, Object | Filters events by end time. If set, `startDateTime` must also be provided. **Text:** ISO 8601 UTC timestamp (exclusive lower bound). Defaults to no filtering. **Object:** Must contain `date` (date type) and `time` (time type), formatted according to system settings |
| timeZone | String | Time zone used in the response. UTC by default|
| select | Text | Specifies which event properties to return (columns) |
| orderby | Text | Defines sorting order for results |
| filter | Text | Applies additional filters based on specific conditions, such as event status, organizer, or categories. Uses [Microsoft Graph OData query syntax](https://learn.microsoft.com/en-us/graph/query-parameters#filter-parameter). Example: "status eq 'confirmed' and organizer/emailAddress/address eq 'example@domain.com'"|
| top | Integer | Limit number of events per page. Maximum value is 999. If top is not defined, the default value is applied (10). When a result set spans multiple pages. Use `.next()` to fetch additional pages. See [Microsoft’s documentation on paging](https://learn.microsoft.com/en-us/graph/paging) for more information |

**Note**: If no time range is provided (`startDateTime` or `endDateTime`) it returns single-instance meetings and series masters. When both `startDateTime` and `endDateTime` are specified, it retrieves all occurrences, exceptions, and single-instance events within the defined time range.

#### Returned object

The method returns an object containing the following properties:

| Property | Type | Description |
|---|---|---|
| errors | Collection | Collection of 4D error items (not returned if an Office 365 server response is received). Each item includes: `[].errcode` (4D error code number), `[].message` (error description), and `[].componentSignature` (component that returned the error) | 
| statusText | Text | Status message returned by the Office 365 server, or the last error message from the 4D error stack | 
|success |Boolean| `True` if the operation is successful, `False` otherwise | 
|isLastPage|Boolean | `True` if the last page of results has been reached |
| page | Integer | Current page number in the result set. Starts at `1`. The default page size is `10`, but this can be adjusted using the `top` parameter | 
| next() | Function | Retrieves the next page of results and increments `page` by `1`. Returns `True` if successful, `False` if there are no more pages. | 
| previous() | Function | Retrieves the previous page of results and decrements `page` by `1`. Returns `True` if successful, `False` if there are no previous pages | 
| calendarId | String | Calendar identifier, same as the `calendarId` provided in the passed parameters (if present) | 
| events | Collection | Collection of event objects. If any events have attachments, an `attachments` attribute is included, containing a collection of attachment objects | 

#### Example

```4d
// Gets all the calendars 
var $calendars:=$office365.calendar.getCalendars()
// For the rest of the example, we'll use the first calendar in the list
var $myCaldendar:=$calendars.calendars[0]

// Gets all the event of the selected calendars
var $events:=$office365.calendar.getEvents({calendarId: $myCalendar.id; top: 10})
```

### Office365.calendar.createEvent()

**Office365.calendar.createEvent**(*event*: Object ) : Object

#### Parameters

| Parameter | Type   |  | Description                                               |
| --------- | ---- |---|------------------------- |
| event | Object | -> | Object containing details of the calendar [event](#event-object) to create |
| result| Object | <- | [Status object](#status-object-microsoft-class)|

#### Description

`Office365.calendar.createEvent()` creates a new calendar event.

In *event*, pass the properties you want to set for the event.

#### Returned Object

The function returns a [**status object**](#status-object-microsoft-class) with an additional `event` property:

| Property   | Type   | Description|                                         
| -------- | ---------- | ----------------------------------- |
| event| Object | [Event object](#event-object) returned by the server                 |
| success | Boolean| See [Status object](#status-object-microsoft-class) |
| statusText | Text| See [Status object](#status-object-microsoft-class) |
| errors  | Collection | See [Status object](#status-object-microsoft-class) |

#### Permissions 
 
One of the following permissions is required to create an event:

| Type                    | Permission            |
| ----------------------- | --------------------- |
| Delegated (Work/School) | `Calendars.ReadWrite` |
| Delegated (Personal)    | `Calendars.ReadWrite` |
| Application             | `Calendars.ReadWrite` |

#### Example

Create a calendar event:

```4d
var $oAuth2 : cs.NetKit.OAuth2Provider 
var $Office365 : cs.NetKit.Office365
var $event; $result : Object

$event:={}
$event.subject:="Team Sync"
$event.start:={date: Current date; time: Current time}
$event.end:={date: Current date; time: Current time+3600}
$event.attendees:=[{email: "first.lastname@gmail.com"}]

$result:=$Office365.calendar.createEvent($event)
If (Not($result.success))
  ALERT($result.statusText)
End if
```
### Office365.calendar.updateEvent()

**Office365.calendar.updateEvent**(*event*: Object) : Object

#### Parameters

| Parameter | Type | | Description|                                                                                                             
| --------- | ------ | ---- | ----------------------------- |
| event     | Object | ->| Object containing the complete updated [event](#event-object). |
| Result| Object | <-| [Status object](#status-object-office365-class)|                                                                         

#### Description

`Office365.calendar.updateEvent()` updates an existing calendar event.

In *event*, pass the event id (mandatory) and the properties you want to update. 

To check the updatable properties, please refer to the [event object](#event-object) table below.

> **Note**: 
 When using `Office365.calendar.updateEvent()`, you only need to include the fields you want to update. Any property you leave out will keep its current value, unless it needs to be recalculated due to changes in related fields (e.g., updating recurrence may affect dates).

#### Returned Object

The method returns a [**status object**](#status-object-office365-class) with an additional `event` property:

| Property   | Type       | Description                                         |
| ---------- | ---------- | --------------------------------------------------- |
| event      | Object     | Updated [event object](#event-object) returned by the server         |
| success    | Boolean    | [see Status object](#status-object-office365-class) |
| statusText | Text       | [see Status object](#status-object-office365-class) |
| errors     | Collection | [see Status object](#status-object-office365-class) |

#### Permissions 
 
One of the following permissions is required to update an event:

| Type                    | Permission            |
| ----------------------- | --------------------- |
| Delegated (Work/School) | `Calendars.ReadWrite` |
| Delegated (Personal)    | `Calendars.ReadWrite` |
| Application             | `Calendars.ReadWrite` |

#### Example

Update an already existing event calendar:

```4d
#DECLARE($eventId:Text)
var $oAuth2 : cs.NetKit.OAuth2Provider 
var $Office365 : cs.NetKit.Office365
var $result : Object

$event.id:=$eventId
$event.subject:="Updated Meeting Title"
$event.start:={date: Current date; time: Current time}
$event.end:={date: Current date; time: Current time+3600}

$result:=$Office365.calendar.updateEvent($event)
If (Not($result.success))
  ALERT($result.statusText)
End if
```

### Office365.calendar.deleteEvent()

**Office365.calendar.deleteEvent**(*param*: Object) : Object

#### Parameters

| Parameter | Type   | Direction | Description                                                                                                         |
| --------- | ------ | --------- | ------------------------------------------------------------------------------------------------------------------- |
| param     | Object | ->  | Object containing details for the calendar [event](#event-object) to delete|
| Result    | Object | <-  | [Status object](#status-object-office365-class)                                                                     |

#### Description

`Office365.calendar.deleteEvent()` deletes a calendar event.

In *param*, you can pass the following properties:

| Property    | Type | Description                                                                                                                                                                      |
| ----------- | ---- | ---------------------------------------- |
| eventId     | Text | **Required.** ID of the event to delete.                                                                                                                                         |
| calendarId  | Text | ID of the calendar. If not provided, the primary calendar of the currently logged-in user is used.                                                                                                     |


#### Returned Object

The method returns a [**status object**](#status-object-office365-class).

#### Permissions

One of the following permissions is required to delete an event:

| Type                    | Permission            |
| ----------------------- | --------------------- |
| Delegated (Work/School) | `Calendars.ReadWrite` |
| Delegated (Personal)    | `Calendars.ReadWrite` |
| Application             | `Calendars.ReadWrite` | 

#### Example

Delete a calendar event:

```4d
var $oAuth2 : cs.NetKit.OAuth2Provider 
var $Office365 : cs.NetKit.Office365

$status:=$office365.calendar.deleteEvent({eventId: $event.event.id})
If ($result.success)
  ALERT("Calendar event correctly deleted")
Else
  ALERT($result.statusText)
End if

```

### Office365.category.list()

**Office365.category.list**() : Object

#### Parameters

| Parameter | Type   |    | Description                                                        |
| --------- | ------ | -- | ------------------------------------------------------------------ |
| This method does not take any parameters.|  | | |
| Result    | Object | <- | [Status object](#status-object) including a `categories` property. |

#### Description

`Office365.category.list()` retrieves the list of defined categories used to group and organize items such as messages and calendar events in a Microsoft account.

Each category includes a display name and a color, which can be applied when creating or updating events.

#### Returned Object

The method returns a [**status object**](#status-object) with an additional `categories` property:

| Property   | | Type       | Description                                                                                                                                                                                      |
| --------- | --|-------- | ----------------------------- |
| success    | | Boolean    | [See Status object](#status-object)                                                                                                                                                              |
| statusText | | Text       | [See Status object](#status-object)                                                                                                                                                              |
| errors     | | Collection | [See Status object](#status-object)                                                                                                                                                              |
| categories | | Collection | Collection of category objects. |
| | id         | Text | ID of the category.                                                                                                                                                                                                                                  |
| | displayName | Text | A unique name that identifies the category in the user's mailbox. Once set, this name cannot be changed.                                                                                                                                                            |
| | color      | Text | A pre-set color constant mapped to one of 25 predefined Outlook colors (e.g., `"Preset0"`, `"Preset12"`). See the list of [color constants](https://learn.microsoft.com/en-us/graph/api/resources/outlookcategory?view=graph-rest-1.0#properties) for more details. |

#### Permissions

One of the following permissions is required:

| Type                    | Permission             |
| ----------------------- | ---------------------- |
| Delegated (Work/School) | `MailboxSettings.Read` |
| Delegated (Personal)    | `MailboxSettings.Read` |
| Application             | `MailboxSettings.Read` | 

#### Example

```4d
var $oAuth2 : cs.NetKit.OAuth2Provider
var $Office365 : cs.NetKit.Office365
var $result : Object
var $toDisplay : Collection
 
$result:=$o365.category.list()
$toDisplay:=[]
 
If (Not($result.success))
	ALERT($result.statusText)
Else 
	// Process the category list
	For each ($category; $result.categories)
		$toDisplay.push($category.displayName)
	End for each 
End if
```  
### Event object

The `event` object used with Microsoft Calendar methods includes the following main properties. For the full list, refer to the [official Microsoft documentation](https://learn.microsoft.com/en-us/graph/api/resources/event?view=graph-rest-1.0).

| Property  |   | Type  | Description| Updatable |                                                                                                 
| -------- | -- | ----- | ----------------------- |-----------|
| id             |   | Text    | ID for the event. Case-sensitive and read-only. |         |
| calendarId |    | Text  | Calendar ID. If not provided, the user's primary calendar is used.   |         |
| attachments| | Collection | Event file [attachments](#attachment-object).|          |                                                                                    
| attendees |   | Collection | List of attendees.|Yes|                                                                                          
|  | emailAddress | Text       |  Required. Attendee’s email address.|         |                                                                     
| | type         | Text       | Attendee role: `"required"`, `"optional"`, or `"resource"`.|         |                                                 
| body | | Object |Body of the message associated with the event.| Yes |                                                                  
| | content      | Text       | Content of the body|         |                                                                                     
| | contentType  | Text       | Type of the content. <br> Possible values: `"text"` or `"html"`.|         |                                                                                       
| categories | | Collection | List of categories associated with the event. Must match the `displayName` of categories returned by [`Office365.category.list()`](#office365categorylist). |Yes|
| start   |  | Object  | Start time of the event.|Yes|                                                                                    
|  | date  | Date  | Start time of the event. If provided as text, use the format `"yyyy-mm-dd"`.|         |                                                     
| | time  | Time| Start time (not used for all-day events).|         |                                                                   
|  | dateTime  | Text   | Combined start date and time (`"yyyy-mm-ddThh:mm:ss"` format). Overrides `date` and `time`.                 |         |
|  | timeZone     | Text | Time zone for the `dateTime`, using IANA format (e.g., `"Europe/Zurich"`). Defaults to UTC if not provided.|          |                                                              
| end   | | Object     | End time of the event.|Yes|                                                                                      
| | date         | Date       | End date of the event. If provided as text, use the format `"yyyy-mm-dd"`.|         |                                                       
| | time         | Time       | End time (not used for all-day events).|         |                                                                     
| | dateTime     | Text       | Combined end date and time (`"yyyy-mm-ddThh:mm:ss"` format). Overrides `date` and `time`.|         |                   
| | timeZone     | Text | Time zone for the `dateTime`, using IANA format (e.g., `"Europe/Zurich"`). Defaults to UTC if not provided.|         | 
| isAllDay   | | Boolean    | (Default: false) Set to `true` if it's an all-day event.|Yes|
| isDraft        |   | Boolean |(Default: false) Set to `true` if changes have been made to the meeting but not yet sent to attendees.|         |                                                                         
| isCancelled | | Boolean    | (Default: false) Whether the event is canceled.|         |                                                                              
| isReminderOn| | Boolean    | (Default: false) Whether a reminder is set for the event.| Yes |                                                                    
| isOnlineMeeting | | Boolean    | (Default: false) Set to `true` to create an online meeting. Once set, the event stays online and further changes to this setting are ignored.|Yes|                                                               
| onlineMeetingProvider | | Text | Provider used: `"teamsForBusiness"`, `"skypeForBusiness"`, `"skypeForConsumer"`, etc.|Yes |                                                                                           
|location| | Object| Event [location object](https://learn.microsoft.com/en-us/graph/api/resources/location?view=graph-rest-1.0).|Yes |                                                                                                                                                                    
| reminderMinutesBeforeStart | | Integer    | Time in minutes before start to trigger reminder.|Yes |                                                                   
| responseRequested  | | Boolean    | Whether a response is requested from attendees. Default is `true`.|Yes |
| recurrence  |  | Object     | [Recurrence pattern](https://learn.microsoft.com/en-us/graph/api/resources/recurrencepattern?view=graph-rest-1.0) (e.g., daily, weekly) .| Yes | 
| seriesMasterId |   | Text    | ID of the recurring series master event, if this event is part of a recurring series. |         |
| importance | | Text | Event importance: `"low"`, `"normal"`, or `"high"`.|Yes |                                                                                                   
| sensitivity | | Text       | Event sensitivity: `"normal"`, `"personal"`, `"private"`, `"confidential"`.| Yes |                                        
| showAs|  | Text | Availability status: `busy`, `free`, etc.| Yes |             
| subject | | Text | Event title or subject line.| Yes |                                                                                     
| allowNewTimeProposals | | Boolean    | (Default: true) Whether attendees can propose a new time.|         |                                                
| hideAttendees  | | Boolean    | (Default: false) If `true`, attendees will only see themselves.|Yes|                                                             

## Mail 
 
### Office365.mail.append()

**Office365.mail.append**( *email* : Object ; *folderId* : Text) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|email|Object|->| Microsoft message object to append|
|folderId|Text|->| Id of the destination folder. Can be a folder id or a [Well-known folder name](#well-known-folder-name).|
|Result|Object|<-| [Status object](#status-object)  |

#### Description

`Office365.mail.append()` creates a draft *email* in the *folderId* folder.

In `email`, pass the email to create. It must be of the [Microsoft mail object](#microsoft-mail-object-properties) type.


#### Returned object

The method returns a [status object](#status-object).

#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadWrite|
|Application|Mail.ReadWrite|


#### Example

```4d
$status:=$office365.mail.append($draft; $folder.id)
```


### Office365.mail.copy()

**Office365.mail.copy**( *mailId* : Text ; *folderId* : Text) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|mailId|Text|->| Id of the mail to copy|
|folderId|Text|->| Id of the destination folder. Can be a folder id or a [Well-known folder name](#well-known-folder-name).|
|Result|Object|<-| [Status object](#status-object)  |

#### Description

`Office365.mail.copy()` copies the *mailId* email to the *folderId* folder within the user's mailbox.

#### Returned object

The method returns a [status object](#status-object).

#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadWrite|
|Application|Mail.ReadWrite|

#### Example

To copy an email from a folder to another:

```4d
$status:=$office365.mail.copy($mailId; $folderId)
```


### Office365.mail.createFolder()

**Office365.mail.createFolder**( *name* : Text { ; *isHidden* : Boolean { ; *parentFolderId* : Text } }) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|name|Text|->|Display name of the new folder|
|isHidden|Boolean|->|True to create a hidden folder (Default is False)|
|parentFolderId|Text|->|ID of the parent folder to get. Can be a folder id or a [Well-known folder name](#well-known-folder-name).|
|Result|Object|<-| [Status object](#status-object)  |

`Office365.mail.getFolder()` creates a new folder named *name* and returns its ID in the [status object](#status-object).

By default, the new folder is not hidden. Pass `True` in the isHidden parameter to create a hidden folder. This property cannot be changed afterwards. Find more information in [Hidden mail folders](https://docs.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0#hidden-mail-folders) on the Microsoft web site.

By default, the new folder is created at the root folder of the mailbox. If you want to create it within an existing folder, pass its id in the *parentFolderId* parameter.

#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadWrite|
|Application|Mail.ReadWrite|


#### Returned object

The method returns a [status object](#status-object).

#### Example

You want to create a "Backup" mail folder at the root of your mailbox and move an email to this folder:

```4d
// Creates a new folder on the root
$status:=$office365.mail.createFolder("Backup")
If($status.success=True)
	$folderId:=$status.id
		// Moves your email in the new folder
	$status:=$office365.mail.move($mailId; $folderId)
End if
```

### Office365.mail.delete()

**Office365.mail.delete**( *mailId* : Text ) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|mailId|Text|->| Id of the mail to delete|
|Result|Object|<-| [Status object](#status-object)  |

#### Description

`Office365.mail.delete()` deletes the *mailId* email.


#### Permissions


One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadWrite|
|Application|Mail.ReadWrite|


#### Returned object

The method returns a [status object](#status-object).


**Note:** You may not be able to delete items in the recoverable items deletions folder (for more information, see the [Microsoft's documentation website](https://learn.microsoft.com/en-us/graph/api/message-delete?view=graph-rest-1.0&tabs=http)).


#### Example

You want to delete all mails in the *$mails* collection:

```4d
For each($mail;$mails)
	$office365.mail.delete($mail.id)
End for each
```

### Office365.mail.deleteFolder()

**Office365.mail.deleteFolder**( *folderId* : Text ) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|folderId|Text|->| ID of the folder to delete. Can be a folder id or a [Well-known folder name](#well-known-folder-name) if one exists.|
|Result|Object|<-| [Status object](#status-object)  |

#### Description

`Office365.mail.deleteFolder()` deletes the *folderId* mail folder.

#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadWrite|
|Application|Mail.ReadWrite|


#### Returned object

The method returns a [status object](#status-object).

#### Example

```4d
$status:=$office365.mail.deleteFolder($folderId)
```

### Office365.mail.getFolder()

**Office365.mail.getFolder**( *folderId* : Text ) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|folderId|Text|->|ID of the folder to get. Can be a folder ID or a [Well-known folder name](#well-known-folder-name).|
|Result|Object|<-|mailFolder object|

`Office365.mail.getFolder()` allows you to get a **mailFolder** object from its *folderId*.

#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadBasic, Mail.Read, Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadBasic, Mail.Read, Mail.ReadWrite|
|Application|Mail.ReadBasic.All, Mail.Read, Mail.ReadWrite|


#### mailFolder object

The method returns a **mailFolder** object containing the following properties (additional information can be returned by the server):

| Property | Type | Description |
|---|---|---|
|childFolderCount|Integer|Number of immediate child mailFolders in the current mailFolder|
|displayName|Text|mailFolder's display name|
|id|Text|mailFolder's unique identifier|
|isHidden|Boolean|Indicates whether the mailFolder is hidden. This property can be set only when creating the folder. Find more information in [Hidden mail folders](https://docs.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0#hidden-mail-folders) on the Microsoft web site.|
|parentFolderId|Text|Unique identifier for the mailFolder's parent mailFolder.|
|totalItemCount|Integer|Number of items in the mailFolder.|
|unreadItemCount|Integer|Number of items in the mailFolder marked as unread.|


### Office365.mail.getFolderList()

**Office365.mail.getFolderList**( *param* : Object ) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|param|Object|->| Description of folders to get|
|Result|Object|<-| Status object that contains folder list and other information|

`Office365.mail.getFolderList()` allows you to get a mail folder collection of the signed-in user.

In *param*, pass an object to define the folders to get. The available properties for that object are (all properties are optional):

| Property | Type | Description |
|---|---|---|
|folderId|text|Can be a folder id or a [Well-known folder name](#well-known-folder-name). <br/>- If it is a parent folder id, get the folder collection under the specified folder (children folders<br/>- If the property is omitted or its value is "", get the mail folder collection directly under the root folder.|
|search|text|Restricts the results of a request to match a search criterion. The search syntax rules are available on [Microsoft's documentation website](https://docs.microsoft.com/en-us/graph/search-query-parameter#using-search-on-directory-object-collections).|
|filter|text|Allows retrieving just a subset of folders. See [Microsoft's documentation on filter parameter](https://docs.microsoft.com/en-us/graph/query-parameters#filter-parameter).|
|select|text|Set of properties to retrieve. Each property must be separated by a comma (,). |
|top|integer|Defines the page size for a request. Maximum value is 999. If `top` is not defined, default value is applied (10). When a result set spans multiple pages, you can use the `.next()` function to ask for the next page. See [Microsoft's documentation on paging](https://docs.microsoft.com/en-us/graph/paging) for more information. |
|orderBy|text|Defines how returned items are ordered. Default is ascending order. Syntax: "fieldname asc" or "fieldname desc" (replace "fieldname" with the name of the field to be arranged).|
|includeHiddenFolders|boolean|True to include hidden folders in the response. False (default) to not return hidden folders. |


#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadBasic, Mail.Read, Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadBasic, Mail.Read, Mail.ReadWrite|
|Application|Mail.ReadBasic.All, Mail.Read, Mail.ReadWrite|


#### Returned object

The method returns a status object containing the following properties:

| Property ||  Type | Description |
|---|---| ---|---|
| errors | |  Collection | Collection of 4D error items (not returned if an Office 365 server response is received)|
||[].errcode|Integer|4D error code number|
||[].message|Text|Description of the 4D error|
||[].componentSignature|Text|Signature of the internal component that returned the error|
| isLastPage | |  Boolean | `True` if the last page is reached |
| page ||   Integer | Folder information page number. Starts at 1. By default, each page holds 10 results. Page size limit can be set in the `top` option. |
| next() ||   Function | Function that updates the `folders` collection with the next mail information page and increases the `page` property by 1. Returns a boolean value: <br/>- If a next page is successfully loaded, returns `True`<br/>- If no next page is returned, the `folders` collection is not updated and `False` is returned  |
| previous() ||   Function | Function that updates the `folders` collection with the previous folder information page and decreases the `page` property by 1. Returns a boolean value: <br/>- If a previous page is successfully loaded, returns `True`<br/>- If no previous `page` is returned, the `folders` collection is not updated and `False` is returned  |
| statusText ||   Text | Status message returned by the Office 365 server, or last error returned in the 4D error stack |
| success | |  Boolean | `True` if the `Office365.mail.getFolderList()` call is successful, `False` otherwise |
| folders ||  Collection | Collection of `mailFolder` objects with information on folders.|
|| [].childFolderCount|Integer|The number of immediate child mailFolders in the current mailFolder.
|| [].displayName|	Text|	The mailFolder's display name.
|| [].id|	Text|	The mailFolder's unique identifier.
|| [].isHidden|	Boolean|	Indicates whether the mailFolder is hidden. This property can be set only when creating the folder. Find more information in Hidden mail folders.
|| [].parentFolderId|	Text|	The unique identifier for the mailFolder's parent mailFolder.
|| [].totalItemCount	|Integer|	The number of items in the mailFolder.
|| [].unreadItemCount|	Integer	|The number of items in the mailFolder marked as unread.


The method returns an empty collection in the `folders` property if:
- no folders are found at the defined location
- an error is thrown

#### Example

You want to :

```4d  
//get the mail folder collection under the root folder (in $result.folders)
var $result : Object
$result:=$office365.mail.getFolderList()

//get the mail subfolder collection under the 9th folder
var $subfolders : Collection
$subfolders:=$office365.mail.getFolderList($result.folders[8].id)
```


### Office365.mail.getMail()

**Office365.mail.getMail**( *mailId* : Text { ; *param* : Object } ) : Object<br/>**Office365.mail.getMail**( *mailId* : Text { ; *param* : Object } ) : Blob

#### Parameters

|Parameter||Type||Description|
|-----|----|--- |:---:|------|
|mailId||Text|->| Id of the mail to get|
|param||Object|->|Format options for the returned mail object|
||mailType|Text|| Type of the mail object to return. Available values: <br/>- "MIME"<br/>- "JMAP"<br/>- "Microsoft" (default)<br/>By default if omitted, the same format as the [`mail.type` property](#new-office365-provider) is used|
||contentType|Text|| Format of the `body` and `uniqueBody` properties to be returned. Available values: <br/>- "text"<br/>- "html" (default)|
|Result||Blob &#124; Object|<-| Downloaded mail|

`Office365.mail.getMail()` allows you to get a single mail from its *mailId*.

By default, the mail is returned with its original format, as defined in the [`mail.type` property of the provider](#new-office365-provider). However, you can convert it to any type using the `mailType` property of the *param* parameter.   

You can also select the preferred format of the `body` and `uniqueBody` properties of the returned mail using the `contentType` property of the *param* parameter.

The data type of the function result depends on the mail type:

|Mail type|Function result|
|---|---|
|MIME|Blob|
|JMAP|Object|
|Microsoft|Object|

If an error occurs, the function returns Null and an error is generated.

See also [Microsoft's documentation website](https://learn.microsoft.com/en-us/graph/api/message-get?view=graph-rest-1.0&tabs=http).

#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadBasic, Mail.Read|
|Delegated (personal Microsoft account)|Mail.ReadBasic, Mail.Read|
|Application|Mail.ReadBasic.All, Mail.Read|


#### Example

Download a specific email:

```4d
$mail:=$office.mail.getMail($mailId)
```


### Office365.mail.getMails()

**Office365.mail.getMails**( *param* : Object ) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|param|Object|->| Description of mails to get|
|Result|Object|<-| Status object that contains mail list and other information|

`Office365.mail.getMails()` allows you to get messages in the signed-in user's mailbox (for detailed information, please refer to the [Microsoft's documentation website](https://learn.microsoft.com/en-us/graph/api/user-list-messages?view=graph-rest-1.0&tabs=http)).  

This method returns mail bodies in HTML format only.

In *param*, pass an object to define the mails to get. The available properties for that object are (all properties are optional):

| Property | Type | Description |
|---|---|---|
|folderId|text|To get messages in a specific folder. Can be a folder id or a [Well-known folder name](#well-known-folder-name). If the destination folder is not present or empty, get all the messages in a user's mailbox.|
|search|text|Restricts the results of a request to match a search criterion. The search syntax rules are available on [Microsoft's documentation website](https://learn.microsoft.com/en-us/graph/search-query-parameter?tabs=http#using-search-on-message-collections).|
|filter|text|Allows retrieving just a subset of mails. See [Microsoft's documentation on filter parameter](https://docs.microsoft.com/en-us/graph/query-parameters#filter-parameter).|
|select|text|Set of [properties of the Microsoft Mail object](#microsoft-mail-object-properties) to retrieve. Each property must be separated by a comma (,). |
|top|integer|Defines the page size for a request. Maximum value is 999. If `top` is not defined, default value is applied (10). When a result set spans multiple pages, you can use the `.next()` function to ask for the next page. See [Microsoft's documentation on paging](https://docs.microsoft.com/en-us/graph/paging) for more information. |
|orderBy|text|Defines how returned items are ordered. Default is ascending order. Syntax: "fieldname asc" or "fieldname desc" (replace "fieldname" with the name of the field to be arranged).|


#### Returned object

The method returns a status object containing the following properties:

| Property ||  Type | Description |
|---|---| ---|---|
| errors | |  Collection | Collection of 4D error items (not returned if an Office 365 server response is received)|
||[].errcode|Integer|4D error code number|
||[].message|Text|Description of the 4D error|
||[].componentSignature|Text|Signature of the internal component that returned the error|
| isLastPage | |  Boolean | `True` if the last page is reached |
| page ||   Integer | Mail information page number. Starts at 1. By default, each page holds 10 results. Page size limit can be set in the `top` option. |
| next() ||   Function | Function that updates the `mails` collection with the next mail information page and increases the `page` property by 1. Returns a boolean value: <br/>- If a next page is successfully loaded, returns `True`<br/>- If no next page is returned, the `mails` collection is not updated and `False` is returned  |
| previous() ||   Function | Function that updates the `folders` collection with the previous mail information page and decreases the `page` property by 1. Returns a boolean value: <br/>- If a previous page is successfully loaded, returns `True`<br/>- If no previous `page` is returned, the `mails` collection is not updated and `False` is returned  |
| statusText ||   Text | Status message returned by the Office 365 server, or last error returned in the 4D error stack |
| success | |  Boolean | `True` if the `Office365.mail.getFolderList()` call is successful, `False` otherwise |
| mails ||  Collection | Collection of [Microsoft mail objects](#microsoft-mail-object-properties). If no mail is returned, the collection is empty|

#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadBasic, Mail.Read, Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadBasic, Mail.Read, Mail.ReadWrite|
|Application|Mail.ReadBasic.All, Mail.Read, Mail.ReadWrite|

#### Example

You want to retrieve *sender* and *subject* properties of all the mails present in the Inbox folder, using its [well-known folder name](#well-known-folder-name):

```4d
$param:=New object
$param.folderId:="inbox"
$param.select:="sender,subject"

$mails:=$office365.mail.getMails($param)
```

### Office365.mail.move()

**Office365.mail.move**( *mailId* : Text ; *folderId* : Text) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|mailId|Text|->| Id of the mail to move|
|folderId|Text|->| Id of the destination folder. Can be a folder id or a [Well-known folder name](#well-known-folder-name).|
|Result|Object|<-| [Status object](#status-object)  |

#### Description

`Office365.mail.move()` moves the *mailId* email to the *folderId* folder. It actually creates a new copy of the email in the destination folder and removes the original email from its source folder.

#### Returned object

The method returns a [status object](#status-object).


#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadWrite|
|Application|Mail.ReadWrite|


#### Example

To move an email from a folder to another:

```4d
$status:=$office365.mail.move($mailId; $folderId)
```

### Office365.mail.renameFolder()

**Office365.mail.renameFolder**( *folderId* : Text ; *name* : Text ) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|folderId|Text|->| ID of the folder to rename|
|name|Text|->| New display name for the folder|
|Result|Object|<-| [Status object](#status-object) |

#### Description

`Office365.mail.renameFolder()` renames the *folderId* mail folder with the provided *name*.

Note that the renamed folder ID is different from the *folderId*. You can get it in the returned [status object](#status-object).

#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.ReadWrite|
|Delegated (personal Microsoft account)|Mail.ReadWrite|
|Application|Mail.ReadWrite|


#### Returned object

The method returns a [status object](#status-object).

#### Example

You want to rename the the "Backup" folder to "Backup_old":

```4d
$status:=$office365.mail.renameFolder($folderId; "Backup_old")
```


### Office365.mail.reply()

**Office365.mail.reply**( *reply* : Object ; *mailId* : Text { ; *replyAll* : Boolean } ) : Object

#### Parameters

|Parameter||Type||Description|
|----|-----|--- |:---:|------|
|reply||Object|->| reply object|
||message|Text &#124; Blob &#124; Object|->|Microsoft message (object) or JMAP (object) or MIME (Blob / Text) that contains the reponse|
||comment|Text|->| (only available with Microsoft message object or no message) Message used as body to reply to the email when present. You must specify either a *comment* or the [body property](#microsoft-mail-object-properties) of the message parameter; specifying both will return an HTTP 400 Bad Request error.|
|mailId||Text|->| Id of the mail to which you reply|
|replyAll||Boolean|->| True to reply to all recipients of the message. Default=False|
|Result|Object|<-| [Status object](#status-object)  |

#### Description

`Office365.mail.reply()` replies to the sender of *mailId* message and, optionnally, to all recipients of the message.

**Note:** Some mails, like drafts, cannot be replied.

If you pass `False` in *replyAll* and if the original message specifies a recipient in the `replyTo` property, the reply is sent to the recipients in `replyTo` and not to the recipient in the `from` property.

#### Returned object

The method returns a [status object](#status-object)

#### Permissions

One of the following permissions is required to call this API. For more information, including how to choose permissions, see the [Permissions section on the Microsoft documentation](https://docs.microsoft.com/en-us/graph/permissions-reference).

|Permission type|Permissions (from least to most privileged)
|---|----|
|Delegated (work or school account)|Mail.Send|
|Delegated (personal Microsoft account)|Mail.Send|
|Application|Mail.Send|

#### Example

To reply to an email and create a conversation:

```4d
$reply:=New object
// Text that will be send as reply
$reply.comment:="Thank you for your message"
$status:=$office365.mail.reply($reply; $mails.mailId)
```



### Office365.mail.send()

**Office365.mail.send**( *email* : Text ) : Object<br/>**Office365.mail.send**( *email* : Object ) : Object<br/>**Office365.mail.send**( *email* : Blob ) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|email|Text &#124; Blob &#124; Object|->| Email to be sent|
|Result|Object|<-| [Status object](#status-object) |

#### Description

`Office365.mail.send()` sends an email using the MIME or JSON formats.

In `email`, pass the email to be sent. Possible types:

* Text or Blob: the email is sent using the MIME format
* Object: the email is sent using the JSON format, in accordance with either:
    * the [Microsoft mail object properties](#microsoft-mail-object-properties)
    * the [4D email object format](https://developer.4d.com/docs/API/EmailObjectClass.html#email-object), which follows the JMAP specification

> Passing both the `textBody` and `htmlBody` properties is not supported by `Office365.mail.send()`. In this case, only the html body part is actually sent.

The data type passed in `email` must be compatible with the [`Office365.mail.type` property](#returned-object-1). In the following example, since the mail type is `Microsoft`, `$email` must be an object. For the list of available properties, see [Microsoft mail object's properties](#microsoft-mail-object-properties):

```4d
$Office365:=New Office365 provider($token; New object("mailType"; "Microsoft"))
$status:=$Office365.mail.send($email)
```

> To avoid authentication errors, make sure your application asks for permission to send emails through the Microsoft Graph API. See [Permissions](https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http#permissions).

#### Returned object

The method returns a [status object](#status-object).

### Office365.mail.update()

**Office365.mail.update**( *mailId* : Text ; *updatedFields* : Object ) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|mailId|Text|->|The ID of the email to update|
|updatedFields|Object|->|email fields to update|
|Result|Object|<-| [Status object](#status-object) |

#### Description

`Office365.mail.update()` allows you to update various properties of received or drafted emails.

In *updatedFields*, you can pass several properties:

|Property|Type|Description|Updatable only if isDraft = true|
|:----|:----|:----|:----|
|bccRecipients|Recipient|The Bcc recipients for the message.| |
|body|ItemBody|The body of the message.|X|
|categories|String collection|The categories associated with the message.| |
|ccRecipients|Recipient collection|The Cc recipients for the message.| |
|flag|followupFlag|The flag value that indicates the status, start date, due date, or completion date for the message.| |
|from|Recipient|The mailbox owner and sender of the message. Must correspond to the actual mailbox used.|X|
|importance|String|The importance of the message. The possible values are: Low, Normal, High.| |
|inferenceClassification|String|The classification of the message for the user, based on inferred relevance or importance, or on an explicit override. The possible values are: focused or other.| |
|internetMessageId|String|The message ID in the format specified by RFC2822.|X|
|isDeliveryReceiptRequested|Boolean|Indicates whether a read receipt is requested for the message.|X|
|isRead|Boolean|Indicates whether the message has been read.| |
|isReadReceiptRequested|Boolean|Indicates whether a read receipt is requested for the message.|X|
|replyTo|Recipient collection|The email addresses to use when replying.|X|
|sender|Recipient|The account that is actually used to generate the message. Updatable when sending a message from a shared mailbox, or sending a message as a delegate. In any case, the value must correspond to the actual mailbox used.|X|
|subject|String|The subject of the message.|X|
|toRecipients|Recipient collection|The To recipients for the message.| |

**Notes:**

* Existing properties that are not included in the *updatedFields* object will maintain their previous values or be recalculated based on changes to other property values.
* Specific properties, such as the body or subject, can only be updated for emails in draft status (isDraft = true).

#### Returned object

The method returns a [status object](#status-object).

### Well-known folder names


Outlook creates certain folders for users by default. Instead of using the corresponding `folder id` value, for convenience, you can use the well-known folder name when accessing these folders. Well-known names work regardless of the locale of the user's mailbox. For example, you can get the Drafts folder using its well-known name "draft". For more information, please refer to the [Microsoft Office documentation](https://docs.microsoft.com/en-us/graph/api/resources/mailfolder?view=graph-rest-1.0).


### "Microsoft" mail object properties

When you send an email with the "Microsoft" mail type, you must pass an object to `Office365.mail.send()`. For a comprehensive list of properties supported by Microsoft mail objects, please refer to the [Microsoft Office documentation](https://learn.microsoft.com/en-us/graph/api/resources/message?view=graph-rest-1.0#properties). Most common properties are listed below:

| Property | Type | Description |
|---|---|---|
| attachments |[attachment](#attachment-object) collection | The attachments for the email. |
| bccRecipients |[recipient](#recipient-object) collection | The Bcc: recipients for the message. |
| body |itemBody object| The body of the message. It can be in HTML or text format.|
| ccRecipients |[recipient](#recipient-object) collection | The Cc: recipients for the message. |  
| flag |[followup flag](#followup-flag-object) object| The flag value that indicates the status, start date, due date, or completion date for the message. |
| from |[recipient](#recipient-object) object | The owner of the mailbox from which the message is sent. In most cases, this value is the same as the sender property, except for sharing or delegation scenarios. The value must correspond to the actual mailbox used.|
| id |Text|Unique identifier for the message (note that this value may change if a message is moved or altered).|
| importance|Text| The importance of the message. The possible values are: `low`, `normal`, and `high`.|
| internetMessageHeaders |[internetMessageHeader](#internetmessageheader-object) collection | A collection of message headers defined by [RFC5322](https://www.ietf.org/rfc/rfc5322.txt). The set includes message headers indicating the network path taken by a message from the sender to the recipient.|
| isDeliveryReceiptRequested  |Boolean| Indicates whether a delivery receipt is requested for the message. |
| isReadReceiptRequested |Boolean| Indicates whether a read receipt is requested for the message. |
| replyTo |[recipient](#recipient-object) collection | The email addresses to use when replying. |
| sender |[recipient](#recipient-object) object | The account that is actually used to generate the message. In most cases, this value is the same as the from property. You can set this property to a different value when sending a message from a shared mailbox, for a shared calendar, or as a delegate. In any case, the value must correspond to the actual mailbox used. Find out more about setting the [from and sender properties](https://docs.microsoft.com/en-us/graph/outlook-create-send-messages#setting-the-from-and-sender-properties) of a message. |
| subject |Text| The subject of the message.|
| toRecipients |[recipient](#recipient-object) collection | The To: recipients for the message. |

#### Attachment object

| Property |  Type | Description |
|---|---|---|
|@odata.type|Text|always "#microsoft.graph.fileAttachment" (note that the property name requires that you use the `[""]` syntax)|
|contentBytes|Text| The base64-encoded contents of the file (only to send mails) |
|contentId|	Text|	The ID of the attachment in the Exchange store.|
|contentType |Text|	The content type of the attachment.|
|id |Text|The attachment ID. (cid)|
|isInline 	|Boolean |Set to true if this is an inline attachment.|
|name| 	Text|	The name representing the text that is displayed below the icon representing the embedded attachment.This does not need to be the actual file name.|
|size|Number|The size in bytes of the attachment.|
|getContent()|Function|Returns the contents of the attachment object in a `4D.Blob` object.|

#### itemBody object

| Property |  Type | Description | Can be null of undefined |
|---|---|---|---|
|content|Text|The content of the item.|No|
|contentType|Text| The type of the content. Possible values are `"text"` and `"html"` |No|

#### recipient object

| Property ||  Type | Description | Can be null of undefined |
|---|---|---|---|---|
|emailAddress||Object||Yes|
||address|Text|The email address of the person or entity.|No|
||name|Text| The display name of the person or entity.|Yes|

#### internetMessageHeader object

| Property |  Type | Description | Can be null of undefined |
|---|---|---|---|
|name |	Text|Represents the key in a key-value pair.|No|
|value|Text|The value in a key-value pair.|No|

#### followup flag object

| Property |  Type | Description |
|---|---|---|
|dueDateTime|[dateTime &#124; TimeZone](#datetime-and-timezone)|	The date and time that the follow up is to be finished. Note: To set the due date, you must also specify the `startDateTime`; otherwise, you will get a `400 Bad Request` response.|
|flagStatus|Text|The status for follow-up for an item. Possible values are `"notFlagged"`, `"complete"`, and `"flagged"`.|
|startDateTime|[dateTime &#124; TimeZone](#datetime-and-timezone)| The date and time that the follow-up is to begin.|

#### dateTime and TimeZone

|Property|Type|Description|
|---|---|---|
|dateTime|Text|A single point of time in a combined date and time representation ({date}T{time}; for example, 2017-08-29T04:00:00.0000000).|
|timeZone|Text|Represents a time zone, for example, "Pacific Standard Time". See below for more possible values.|

In general, the timeZone property can be set to any of the time zones currently supported by Windows, as well as the additional time zones supported by the calendar API:
* [Default time zones](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11)
* [Additional time zones](https://docs.microsoft.com/en-us/graph/api/resources/datetimetimezone?view=graph-rest-1.0#additional-time-zones)



#### Example: Create an email with a file attachment and send it

Send an email with an attachment, on behalf of a Microsoft 365 user:

```4d
var $oAuth2 : cs.NetKit.OAuth2Provider
var $token; $param; $email; $status : Object

// Set up authentication
$param:=New object()
$param.name:="Microsoft"
$param.permission:="signedIn"
$param.clientId:="your-client-id" // Replace with your client ID
$param.redirectURI:="http://127.0.0.1:50993/authorize/"
// Ask permission to send emails on behalf of the Microsoft user
$param.scope:="https://graph.microsoft.com/Mail.Send"  

$oAuth2:=New OAuth2 provider($param)

$token:=$oAuth2.getToken()

// Create the email, specify the sender and the recipient
$email:=New object()
$email.from:=New object("emailAddress"; New object("address"; "senderAddress@hotmail.fr")) // Replace with sender's email
$email.toRecipients:=New collection(New object("emailAddress"; New object("address"; "recipientAddress@hotmail.fr")))
$email.body:=New object()
$email.body.content:="Hello, World!"
$email.body.contentType:="html"
$email.subject:="Hello, World!"

// Create a text file and attach it to the email
var $attachment : Object
var $attachmentText : Text

$attachmentText:="Simple text file"
BASE64 ENCODE($attachmentText)
$attachment:=New object
$attachment["@odata.type"]:="#microsoft.graph.fileAttachment"
$attachment.name:="attachment.txt"
$attachment.contentBytes:=$attachmentText
$email.attachments:=New collection($attachment)

// Send the email
$Office365:=New Office365 provider($token; New object("mailType"; "Microsoft"))
$status:=$Office365.mail.send($email)
```

## Status object

Several Office365.mail functions return a standard `**status object**`, containing the following properties:

|Property|Type|Description|
|---------|--- |------|
|success|Boolean| True if the operation was successful|
|statusText|Text| Status message returned by the server or last error returned by the 4D error stack|
|errors|Collection| Collection of errors. Not returned if the server returns a `statusText`|
|id|Text|<br/>- [`copy()`](#office365-mail-copy) and [`move()`](#office365-mail-move): returned id of the mail.<br/>- [`createFolder()`](#office365-mail-createFolder) and [`renameFolder()`](#office365-mail-renameFolder): returned id of the folder|


Basically, you can test the `success` and `statusText` properties of this object to know if the function was correctly executed.

#### Error handling

When an error occurs during the execution of an Office365.mail function:

- if the function returns a [`**status object**`](#status-object), the error is handled by the status object and no error is thrown,
- if the function does not return a **status object**, an error is thrown that you can intercept with a project method installed with `ON ERR CALL`.

## User
 
### Office365.user.get()

**Office365.user.get**( *id* : Text { ; *select* : Text }) : Object<br/>**Office365.user.get**( *userPrincipalName* : Text { ; *select* : Text }) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|id|Text|->| Unique identifier of the user to search for |
|userPrincipalName|Text|->| User principal name (UPN) of the user to search for|
|select|Text|->| Set of properties to be returned|
|Result|Object|<-| Object holding information on the user|

#### Description

`Office365.user.get()` returns information on the user whose ID matches the *id* parameter, or whose User Principal Name (UPN) matches the *userPrincipalName* parameter.


> The UPN is an Internet-style login name for the user based on the Internet standard RFC 822. By convention, it should correspond to the user's email name.

If the ID or UPN is not found or connection fails, the command returns an object with `Null` as a value and throws an error.

In *select*, you can pass a string that contains a specific set of properties you want to retrieve. Each property must be separated by a comma (,). If the select parameter is omitted, the function returns an object with a predefined set of properties (see below).

> The list of available properties is available on [Microsoft's documentation website](https://docs.microsoft.com/en-us/graph/api/resources/user?view=graph-rest-1.0).

#### Returned object

By default, if the *select* parameter is omitted, the command returns an object with the following properties:

| Property | Type | Description
|---|---|---|
id | Text | Unique identifier for the user    
businessPhones | Collection | The user's phone numbers.
displayName | Text | Name displayed in the address book for the user.|
givenName | Text | The user's first name.
jobTitle | Text | The user's job title.
mail | Text | The user's email address.
mobilePhone | Text | The user's cellphone number.
officeLocation | Text | The user's physical office location.
preferredLanguage | Text | The user's language of preference.
surname | Text | The user's last name.
userPrincipalName | Text | The user's principal name.

Otherwise, the object contains the properties specified in the `select` parameter.

For more details on user information, see [Microsoft's documentation website](https://docs.microsoft.com/en-us/graph/api/resources/user?view=graph-rest-1.0).

### Office365.user.getCurrent()

**Office365.user.getCurrent**({*select* : Text}) : Object

#### Description

`Office365.user.getCurrent()` returns information on the current user. In this case, it requires a [signed-in user](https://docs.microsoft.com/en-us/graph/auth-v2-user), and therefore a delegated permission.

The command returns a `Null` object if the session is not a sign-in session.

In *select*, pass a string that contains a set of properties you want to retrieve. Each property must be separated by a comma (,).

By default, if the *select* parameter is not defined, the command returns an object with a default set of properties (see the [property table](#returned-object)).

#### Example

To retrieve information from the current user:

```4d
var $userInfo; $params : Object
var $oAuth2 : cs.NetKit.OAuth2Provider
var $Office365 : cs.NetKit.Office365

// Set up parameters:
$params:=New object
$params.name:="Microsoft"
$params.permission:="signedIn"
$params.clientId:="your-client-id" // Replace with your Microsoft identity platform client ID
$params.redirectURI:="http://127.0.0.1:50993/authorize/"
$param.scope:="https://graph.microsoft.com/.default"

$oAuth2:=New Oauth2 provider($params) //Creates an OAuth2Provider Object

$Office365:=New Office365 provider($oAuth2) // Creates an Office365 object

// Return the properties specified in the parameter.
$userInfo:=$Office365.user.getCurrent("id,userPrincipalName,\
principalName,displayName,givenName,mail")
```

### Office365.user.list()

**Office365.user.list**({*param*: Object}) : Object

#### Parameters

|Parameter|Type||Description|
|---------|--- |:---:|------|
|param|Object|->| Additional options for the search|
|result|Object|<-| Object holding a collection of users and additional info on the request|

#### Description

`Office365.user.list()` returns a list of Office365 users.

In *param*, you can pass an object to specify additional search options. The following table groups the available search options:

| Property | Type | Description |
|---|---|---|
| search | Text | Restricts the results of a request to match a search criterion. The search syntax rules are available on [Microsoft's documentation website](https://docs.microsoft.com/en-us/graph/search-query-parameter#using-search-on-directory-object-collections).|
| filter | Text | Allows retrieving just a subset of users. See [Microsoft's documentation on filter parameter](https://docs.microsoft.com/en-us/graph/query-parameters#filter-parameter). |
| select | Text | Set of properties to retrieve. Each property must be separated by a comma (,). By default, if `select` is not defined, the returned user objects have a [default set of properties](#returned-object)|
|top| Integer | Defines the page size for a request. Maximum value is 999. If `top` is not defined, the default value is applied (100). When a result set spans multiple pages, you can use the `.next()` function to ask for the next page. See [Microsoft's documentation on paging](https://docs.microsoft.com/en-us/graph/paging) for more information. |
|orderBy| Text | Defines how the returned items are ordered. By default, they are arranged in ascending order. The syntax is "fieldname asc" or "fieldname desc". Replace "fieldname" with the name of the field to be arranged.  |

#### Returned object

The returned object holds a collection of users as well as status properties and functions that allow you to navigate between different pages of results.

By default, each user object in the collection has the [default set of properties listed in the `Office365.user.get()` function](#returned-object). This set of properties can be customized using the `select` parameter.

| Property | Type | Description |
|---|---|---|
| errors |  Collection | Collection of 4D error items (not returned if an Office 365 server response is received): <br/>- [].errcode is the 4D error code number<br/>- [].message is a description of the 4D error<br/>- [].componentSignature is the signature of the internal component that returned the error|
| isLastPage |  Boolean | `True` if the last page is reached |
| page |  Integer | User information page number. Starts at 1. By default, each page holds 100 results. Page size limit can be set in the `top` option. |
| next() |  Function | Function that updates the `users` collection with the next user information page and increases the `page` property by 1. Returns a boolean value: <br/>- If a next page is successfully loaded, returns `True`<br/>- If no next page is returned, the `users` collection is not updated and `False` is returned  |
| previous() |  Function | Function that updates the `users` collection with the previous user information page and decreases the `page` property by 1. Returns a boolean value: <br/>- If a previous page is successfully loaded, returns `True`<br/>- If no previous `page` is returned, the `users` collection is not updated and `False` is returned  |
| statusText |  Text | Status message returned by the Office 365 server, or last error returned in the 4D error stack |
| success |  Boolean | `True` if the `Office365.user.list()` operation is successful, `False` otherwise |
| users | Collection | Collection of objects with information on users.|


#### Example

```4d
var $oAuth2 : cs.NetKit.OAuth2Provider
var $Office365 : cs.NetKit.Office365
var $userInfo; $params; $userList; $userList2; $userList3; $userList4 : Object
var $col : Collection

// Set up parameters:
$params:=New object
$params.name:="Microsoft"
$params.permission:="signedIn"
$params.clientId:="your-client-id" // Replace with your Microsoft identity platform client ID
$params.redirectURI:="http://127.0.0.1:50993/authorize/"
$params.scope:="https://graph.microsoft.com/.default"

// Create an OAuth2Provider Object
$oAuth2:=New OAuth2 provider($params)

// Create an Office365 object
$Office365:=New Office365 provider($oAuth2)

// Return a list with the first 100 users
$informationList1:=$Office365.user.list()

// Return a list of users whose displayName is Jean
$userList2:=$Office365.user.list(New object("filter"; "startswith(displayName,'Jean')"))

// return a list of users whose display names contain "F" and arrange it in descending order.
$userList3:=$Office365.user.list(New object("search"; "\"displayName:F\""; "orderBy"; "displayName desc"; "select"; "displayName"))

// Create a list filled with all the userPrincipalName

$userList4:=$Office365.user.list(New object("select"; "userPrincipalName"))
$col:=New collection
Repeat
    $col.combine($userList4.users)
Until (Not($userList4.next()))
```

## See also

[Google Class](./Google.md)<br/>
[OAuth2Provider Class](./OAuth2Provider.md)
