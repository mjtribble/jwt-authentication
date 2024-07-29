# JWT-based Authentication API with Token Refresh

Simple ruby on rails API with registration and jwt authentication. 

### Running the app locally

You need to have ruby installed on your machine, the version specified in .ruby-version

Example using homebrew and rbenv on mac:

```bash
# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install rbenv
brew install rbenv nodenv

# install ruby
rbenv install $(cat .ruby-version)

# instal gems from Gemfile.lock
bundle install

# Now you should be set and you can run the server:
bin/rails s
```

### Linter

This app uses [standard](https://github.com/testdouble/standard). If you are not familiar with standard, it's a wrapper around [rubocop](https://github.com/rubocop/rubocop) that does not allow customization. The idea is to not bikeshed about style, just apply rules.

You can fix style by running `bundle exec standardrb --fix`. There is also a [VSCode plugin](https://marketplace.visualstudio.com/items?itemName=testdouble.vscode-standard-ruby) if you are using VSCode.

### Running tests
```
bin/rails test
```

### API Documentation
Endpoints:
POST /api/register Request Body:
```
{
"email": "example@example.com", "password": "securepassword"
}
```

Successful Response Body:
```
{
"token": "****token***", "refresh_token": "***refresh_token***"
}
```

POST /api/login Request Body:
```
{
"email": "example@example.com",
   
  "password": "securepassword" }
```
Successful Response Body:
```
{
"token": "****token***", "refresh_token": "***refresh_token***"
}
```
POST /api/token/validate Request Headers:
```
   { "Authorization": "Bearer ****token***" }
```
Successful Response:
```
HTTP 200 OK
```
POST /api/token/refresh Request Body:
```
   { "refresh_token": "***refresh_token***" }
```
Successful Response Body:    
```
{
"token": "****token***", "refresh_token": "***refresh_token***"
}
```
GET /api/widgets Request Headers:
```
   { "Authorization": "Bearer ****token***" }
```
Successful Response Body:
```
[
{
"id": 1,
       "name": "Foo",
     },
{
"id": 2,
       "name": "Bar",
     },
{
"id": 3,
       "name": "Baz",
     }
]
```