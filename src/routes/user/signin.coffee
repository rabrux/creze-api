validator = require 'validator'

module.exports = ( router, bcrypt, jwt, schemas, server ) ->

  router.post '/signin', ( req, res ) ->

    data = req.body

    if not data.username or not data.password
      return res.status( 400 ).send 'INVALID_CREDENTIALS'

    if not validator.isEmail( data.username )
      return res.status( 400 ).send 'INVALID_EMAIL_ADDRESS'

    schemas.users.findOne { username : data.username }, ( user ) ->

      # invalid user error
      return res.sendStatus 401 if not user

      switch user.status
        when 'EMAIL_PENDING_VALIDATE'
          return res.status( 400 ).send 'EMAIL_NOT_VALIDATED'
        when 'SUSPENDED', 'BANNED'
          return res.sendStatus 401

      bcrypt.compare data.password, user.password, ( err, isMatch ) ->
        return res.sendStatus 500 if err
        return res.sendStatus 401 if not isMatch
        
        token = jwt.encode user, server.secret

        return res.send
          token : 'JWT ' + token
          name  : user.name