# Simple chat-api using Ruby on Rails

This simple chat-api using Ruby language and Ruby on Rails framework.


## Need to prepare :

* Ruby version >= 2.5.1
* Ruby on Rails version >= 5.2.3
* MySql

## How to run :

* Clone this repo

* run `bundle install` to install all dependency

* create a database, then setting `config/database.yml` with your database configuration (database, username, password)

* run `rails db:migrate` to migrate all DB schema

* run `rails server` to fire up application

## Available API list :

* `/api/signup` (POST) ---> use to signup to app and create account  
params (example) :  
```
{
	"name": "rahmat",
	"email": "rahmat@mail.com",
	"phone_number": "08123",
	"password": "12345",
	"password_confirmation": "12345"
}
```

* `/api/login` (POST) ---> use to login into app, and get bearer token   
params (example) :    
```
{
	"email": "rahmat@mail.com",
	"password": "12345"
}
```

* No logout API, because it use JWT token. JWT token is save on client side, to logout just delete the token. And then user not have permission to the below API.

* `/api/send-message` (POST)  ---> use to send message to another user    
header :     
`Authorization`   (Bearer xxxx) get bearer token from `/api/login` response     
`Content-Type`   (application/json)        
params (example) :    
```
{
	"from": "08123",
	"to": "0812",
	"text": "Hallo apa kabar"
}
```
I assume that params `from` and `to` use user `phone_number`, so make sure you already create at least 2 users to send messages to another user. Above example indicate that user with phone number `08123` want to send message to another user that have phone number `0812`.

* `/api/list-message`  (GET) ---> use to list messages from user to another user     
header :     
`Authorization`   (Bearer xxxx) get bearer token from `/api/login` response     
`Content-Type`   (application/json)        
params (example) :    
```
{
	"from": "08123",
	"to": "0812"
}
```

* `/api/list-all-conversation` (GET)  ---> use to list all their conversations between all users that chat with him/her (included : last_message , unread_count)     
header :     
`Authorization`   (Bearer xxxx) get bearer token from `/api/login` response     
`Content-Type`   (application/json)        
params (example) :      
```
{
	"user": "08123"
}
```

* `/api/update-message` (PUT)  ---> use to update message that already send    
header :     
`Authorization`   (Bearer xxxx) get bearer token from `/api/login` response     
`Content-Type`   (application/json)        
params (example) :    
```
{
	"from_user": "08123",
	"old_text": "Hallo apa kabar",
	"new_text": "Hallo kabar apa"
}
```
Make sure `old_text` input already on DB if not, there will no change.

* `/api/delete-message` (POST)  ---> use to delete message that already send    
header :     
`Authorization`   (Bearer xxxx) get bearer token from `/api/login` response     
`Content-Type`   (application/json)        
params (example) :    
```
{
	"from_user": "08123",
	"text": "Hallo kabar apa"
}
```
Make sure `text` input already on DB if not, there will no delete data.





To hit and test the API you can use [Insomina](https://insomnia.rest/) or [Postman](https://www.postman.com/)
