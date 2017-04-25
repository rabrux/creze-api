randomstring = require 'randomstring'
validator    = require 'validator'

module.exports = ( router, bcrypt, schemas, mailing, _dates ) ->

  router.post '/signup', ( req, res ) ->

    data = req.body

    if not data.username or not data.password or not data.name
      return res.status( 400 ).send 'username, password and name are required.'

    if not validator.isEmail( data.username )
      return res.status( 400 ).send 'INVALID_EMAIL_ADDRESS'

    schemas.users.find { username : data.username }, ( user ) ->

      return res.status( 400 ).send 'DUPLICATE_USER' if user.length isnt 0

      password = data.password
      user     = Object.assign data,
        key       : randomstring.generate()
        status    : 'EMAIL_PENDING_VALIDATE'
        createdAt : _dates.timestamp()
        updatedAt : _dates.timestamp()

      # generate password hash
      bcrypt.genSalt 10, ( err, salt ) ->
        return res.status( 500 ).send err if err
        bcrypt.hash user.password, salt, ( err, hash ) ->
          return res.status( 500 ).send err if err
          user.password = hash
          # save user
          schemas.users.insert user
          email = require( '../../email-templates/signup' )
            to       : user.username
            password : password
            key      : user.key

          if email
            mailing email, ( err, done ) ->
              return res.status( 500 ).send 'ERROR_ON_SEND_EMAIL' if err
              return res.status( 201 ).send user