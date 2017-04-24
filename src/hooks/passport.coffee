JwtStrategy = require('passport-jwt').Strategy
ExtractJwt  = require('passport-jwt').ExtractJwt

module.exports = ( passport, users, server, _dates ) ->
  opts =
    jwtFromRequest : ExtractJwt.fromAuthHeader()
    secretOrKey    : server.secret
  passport.use new JwtStrategy opts, ( jwt_payload, done ) ->
    console.log 'jwt_payload', jwt_payload
    schemas.User.findOne { id: jwt_payload.id }, ( err, user ) ->
      return done err, user
