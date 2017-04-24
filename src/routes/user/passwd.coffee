randomstring = require 'randomstring'
validator    = require 'validator'

module.exports = ( router, bcrypt, schemas, _dates ) ->

  router.put '/passwd', ( req, res ) ->

    data = req.body

    # bad request error
    if not data?.key or not data?.password
      return res.sendStatus 400

    schemas.users.findOne
      key    : data.key
      status : 'PASSWORD_RECOVERY'
    , ( user ) ->

      return res.sendStatus 404 if not user

      console.log 

      # generate password hash
      bcrypt.genSalt 10, ( err, salt ) ->
        return res.status( 500 ).send err if err
        bcrypt.hash data.password, salt, ( err, hash ) ->
          return res.status( 500 ).send err if err
          # save user
          schemas.users.update
            username : user.username
          ,
            status   : 'ACTIVE'
            password : hash
          , ( count ) ->
            return res.sendStatus 500 if count is 0
            return res.sendStatus 200