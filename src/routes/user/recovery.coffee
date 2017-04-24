randomstring = require 'randomstring'
validator    = require 'validator'

module.exports = ( router, schemas, _dates ) ->

  router.put '/recovery', ( req, res ) ->

    data = req.body

    # bad request error
    return res.status( 400 ).send 'username is required' if not data?.username

    if not validator.isEmail( data.username )
      return res.status( 400 ).send 'INVALID_EMAIL_ADDRESS'

    schemas.users.findOne { username : data.username }, ( user ) ->

      # not found error
      return res.sendStatus 404 if not user

      switch user.status
        when 'EMAIL_PENDING_VALIDATE'
          return res.status( 400 ).send 'EMAIL_NOT_VALIDATED'
        when 'SUSPENDED', 'BANNED'
          return res.sendStatus 401
        else
          # generate random hash key
          key = randomstring.generate()
          # update model
          schemas.users.update
            username : data.username
          ,
            key       : key
            status    : 'PASSWORD_RECOVERY'
            updatedAt : _dates.timestamp()
          , ( count ) ->
            return res.sendStatus 200