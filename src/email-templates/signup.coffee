emailConfig = require '../conf/email.json'

module.exports = ( args ) ->

  return false if not args or not args.to or not args.password or not args.key

  return {
    from    : "\" #{ emailConfig.name } \" <noreply@creze.com>"
    to      : args.to
    subject : 'SIGNUP'
    html    : "Usuario: #{ args.to }<br />Password: #{ args.password }<br /><a href=\"#{ emailConfig.dashURL }/verify/#{ args.key }\">Verificar cuenta</a>"
  }
