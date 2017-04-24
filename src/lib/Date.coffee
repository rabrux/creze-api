moment = require 'moment-timezone'

class Dates

  constructor : ( options ) ->
    Object.assign @, options

  utc : ( date ) -> moment.utc( +date )

  toLocal : ( date ) ->
    date = parseInt date
    d = moment()
    d = moment( date ) if date
    d.tz( @getTimezone() ).locale( @getLocale() )

  now : -> @toLocal()

  timestamp : ( date ) -> parseInt @toLocal( date ).format( 'x' )

  # getters and setters
  getTimezone : -> @timezone
  setTimezone : ( @timezone ) ->

  getLocale   : -> @locale
  setLocale   : ( @locale ) ->


module.exports = Dates
