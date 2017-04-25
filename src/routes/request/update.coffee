module.exports = ( router, schemas, _dates ) ->

  router.put '/request', ( req, res ) ->

    data = req.body

    schemas?.requests?.update
      id : data.id
    ,
      Object.assign data,
        updatedAt : _dates.timestamp()
    , ( count ) ->

      return res.sendStatus 500 if count is 0
      
      return res.sendStatus 200


    #return res.send schemas?.requests?.getData()