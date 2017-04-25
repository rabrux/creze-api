module.exports = ( router, schemas ) ->

  router.get '/request', ( req, res ) ->

    return res.send schemas?.requests?.getData()