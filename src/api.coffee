# npm packages
express    = require 'express'
app        = express()
bodyParser = require 'body-parser'
morgan     = require 'morgan'
jwt        = require 'jwt-simple'
bcrypt     = require 'bcrypt'
logger     = require 'winston'
path       = require 'path'
jsonDB     = require 'json-db-lib'
# end npm packages

# config data
server = require '../conf/server.json'
port   = process.env.PORT || server.port

# global helpers
mailing = require './lib/email'
Dates   = require './lib/Date'
_dates  = new Dates
  locale   : server.locale
  timezone : server.timezone

# database and collections
driver    = new jsonDB server.storage
users     = driver.Collection 'users'
requests  = driver.Collection 'requests'

# Logger server
logger.remove logger.transports.Console
logger.add logger.transports.Console,
  colorize: true
  timestamp: true

# Get our request parameters
app.use bodyParser.urlencoded( { extended: false } )
app.use bodyParser.json()

# Coords
app.use (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  res.header 'Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS'
  next()

# Log to console
app.use morgan( 'dev' )

app.get '/', ( req, res ) ->
  res.send "Hello world"

# Hooks
app.use require( './hooks/passport' )( jwt, server, users )

# Router
router = express.Router()
# routes
require( './routes/user/index' )( router, server, users : users, jwt, bcrypt, mailing, _dates )
require( './routes/request/index' )( router, requests : requests, mailing, _dates )

app.use '/', router

app.listen port

logger.info "Magic happends on #{ port }"
