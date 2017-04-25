module.exports = ( router, schemas, mailing, _dates ) ->

  router.post '/send-request', ( req, res ) ->

    data = req.body

    # generate id
    id = 1000 if schemas?.requests?.getData().length is 0

    if not id
      rqs   = schemas.requests.getData()
      index = rqs.length - 1
      id    = rqs[ index ].id + 1

    # request model
    request = Object.assign data,
      id        : id
      status    : 'RECEIVED'
      createdAt : _dates.timestamp()
      updatedAt : _dates.timestamp()

    schemas?.requests?.insert request

    res.sendStatus 200