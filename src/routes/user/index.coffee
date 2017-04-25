module.exports = ( router, config, schemas, jwt, bcrypt, mailing, _dates ) ->

  require( './signup' ) router, bcrypt, schemas, mailing, _dates
  require( './signin' ) router, bcrypt, jwt, schemas, config
  require( './verify' ) router, schemas, _dates
  require( './recovery' ) router, schemas, mailing, _dates
  require( './passwd' ) router, bcrypt, schemas, _dates