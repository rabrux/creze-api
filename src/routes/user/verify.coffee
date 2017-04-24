module.exports = ( router, schemas ) ->

  router.get '/verify/:hash', ( req, res ) ->

    schemas.users.findOne { key: req.params.hash }, ( user ) ->

      # invalid key error
      return res.status( 400 ).send 'INVALID_KEY' if not user
      # already verified error
      return res.send 'ALREADY_VERIFIED' if user.status isnt 'EMAIL_PENDING_VALIDATE'

      schemas.users.update user, { status : 'ACTIVE' }, ( count ) ->
        return res.send 'SUCCESSFULLY_VERIFIED'
