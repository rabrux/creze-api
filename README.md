# API Boilerplate

## Description ##

## Prerequisites ##

* Git
* NodeJS
* NPM
* Dev Dependencies
  * CoffeeScript

## Installation and Configuration ##

* ** Download Source Code **
```bash
> git clone https://github.com/rabrux/creze-api.git api
```

* ** Go to Source Code Directory **
```bash
> cd api
```

* ** Installing NPM Dependencies **
```bash
> npm install
```
*To install dev dependencies (just coffeescript) run command `npm install -g coffee-script` it can be require root privileges*

* ** Build API Server **
```bash
> npm run build
```

* ** Execute API Server **
```bash
> npm start
```

## Understanding Project Structure ##

### API Files Structure ###

Base file structure to understand project bootstrap

```
.
│   README.md                # This README file
│   package.json             # NPM config file
│   .gitignore               # Excluded files
│
└───conf                     # Configuration files
│
└───src                      # Source directory
    │
    │   api.coffee           # Main server file
    │
    └───email-templates      # Email templates
    │
    └───hooks                # Server hooks
    │
    └───lib                  # Local libraries (reused code)
    │
    └───routes               # Server API paths (group in folders)
```
##### Adding new NPM package  #####

If you need to use an unincluded package, you must add with the command `npm install --save YourPackageName`, it instruction install the npm package and add it to the config file (`--save`).

##### Config Files #####

Before create a configuration file verify that is not categorized in any existing file.

if you need a new configuration file you must create it within `./conf/<FileName>`. It can be described in JSON format if only contains static variables otherwise you can create it as a new module package like `module.exports` and saved as .coffee extension.

** JSON config file example **

```json
{
  "port"     : 1337,
  "secret"   : "YOUR_SECRET_HERE",
  "database" : "mongodb://localhost:27017/"
}
```

** Dynamic config file example (CoffeeScript) **

```coffeescript
module.exports = ( <inject_dependencies> ) ->

  object =
    name : 'lorem'
    date : new Date()

  return object
```
where `<inject_dependencies>` are variables, objects or modules needed for returning a computed object. This configuration file can be loaded as `require( '<file_path>' )( <inject_dependencies> )` for example `myConfig = require( 'myconfig' )( mongoose, app )`

** Email config example (src/conf/email.json) **

```json
{
  "name"     : "NAME",
  "dashURL" : "http://localhost:8080/#",
  "login"    : {
    "host"   : "<host>",
    "port"   : 465,
    "secure" : true,
    "auth"   : {
      "user" : "<email>",
      "pass" : "<password>"
    }
  }
}
```

** Server config example (src/conf/server.json) **

```json
{
  "port"     : 1337,
  "secret"   : "YOUR_SECRET_HERE",
  "locale"   : "es",
  "timezone" : "America/Mexico_City"
}
```


##### Hooks Files #####

A **hook** is an express middleware action that executes when an event is triggered.

[Express Middleware Docs](http://expressjs.com/en/guide/using-middleware.html)

** Before hook **
```coffeescript
module.exports = ( app ) ->

  app.use ( req, res, next ) ->
    console.log 'Before'
    next()
```

** After hook **
```coffeescript
module.exports = ( app ) ->

  app.use ( req, res, next ) ->
    res.on 'finish', ->
      console.log 'After'
    next()
```

##### Route Files #####

A route in express is a entry point where the client can interact with the API.

Router architecture example:
* System
  * singup
  * validateEmail
  * resetPassword
  * ...
  * index

Where index is a file that includes all routes for a faster access. It has to be included into `./src/index.coffee`

For organization purposes each route file can only contain a single route, and a group of routes that share interaction with one specific data model. That route files had to be grouped in a folder with a name that describes it function.

##### Email Template File #####

For organization purposes all email templates are stored in `./src/email-templates` and saved as CoffeeScript file type.

** Email Template example **
```coffeescript
emailConfig = require '../conf/email.json'

module.exports = ( args ) ->

  if !args or !args.to or !args.key
    return false

  return {
    from    : "\" #{ emailConfig.name } \" <#{ emailConfig.login.auth.user }>"
    to      : args.to
    subject : 'SIGNUP'
    html    : "<a href=\"#{ emailConfig.dashURL }/verify/#{ args.key }\">validate</a>"
  }
```

Where `args` param is an object that contains all dynamic data that will be required to correctly render the template.

##### Library Files #####

A Library file contains code that is used in many times in the API.

For organization purposes all library files are within `./src/email-templates` and saved as CoffeeScript file type.

## License

*MIT License:*

```
Copyright (c) 2017 Alchimia Labs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```

## Contributors ##

```json
{
  "contributors": [
    {
      "name": "rabrux",
      "email": "raul[at]alchimia[dot]mx",
      "github": "https://github.com/rabrux",
      "twitter": "[at]rabrux"
    }
  ]
}
```

## Last Update ##

Last update April 23, 2017
