authRoutes = require '../../conf/authorizedRoutes.json'

module.exports = ( jwt, server, model ) ->

  return ( req, res, next ) ->

    # next if options
    return next() if req.method is 'OPTIONS'

    # simple paths
    return next() if authRoutes.indexOf( req.path ) > -1

    # complex paths
    current = req.path.replace( /\/+$/, '' ).split( '/' )
    for path in authRoutes
      pieces = path.split '/'
      flag = true
      for i in [0...pieces.length] by 1
        if current[ i ] isnt pieces[ i ]
          flag = flag and ( pieces[ i ].indexOf( ':' ) is 0 )
        else
          flag = flag and ( current[ i ] is pieces[ i ] )

      return next() if flag

    # tokenize
    token = req?.headers?.authorization?.split( ' ' )[ 1 ]
    return res.sendStatus 401 if not token
    
    decoded = jwt.decode token, server.secret

    model.findOne
      username : decoded.username
    , ( user ) ->
      return res.sendStatus 401 if not user

      return next()