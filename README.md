oAuth2 client using Resource Owner Password Credentials Grant and a JWT bearer token
-----------------------------------------------------------------------------------------

Ths is an IOS client accompanying [https://github.com/jeromyevans/node-oauth2-jwt-example]

This grant type is used where the app is trusted by the resource owner (the user) and has a client id and 
client secret known by the server.  *Trust* implies the user is willing to enter their username and password into the client, which 
usually means the client is issued or approved by the some organization that owns the authorization server.

The client uses [NXOAuth2Client](https://github.com/nxtbgthng/OAuth2Client)

The IOS client use-case is:
* The user enters their username and password into the client. 
* The client authenticates (grant_type=password) against the server and receives an access token and refresh token. The
 client Id and client secret are also validated by the server.
* The client stores the tokens and account details in the Keystore.  These are retained across invocation of the app until explicitly removed.
* The client uses the access token for all subsequent requests made via NXOAuth2Client 
* If the access token expires, the client requests a new one from this server (grant_type=refresh_token)
 and receives a new access token (NXOAuth2Client does this) 

In this demo the client has to login every time the app is launched, but this isn't necessary - the account can just be looked-up frmo the Keystore.


