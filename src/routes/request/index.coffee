module.exports = ( router, schemas, mailing, _dates ) ->

  require( './insert' ) router, schemas, mailing, _dates
  require( './list' ) router, schemas
  require( './update' ) router, schemas, _dates