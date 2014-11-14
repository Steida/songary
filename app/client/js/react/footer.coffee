goog.provide 'app.react.Footer'

class app.react.Footer

  ###*
    @param {app.react.Login} login
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (login, usersStore, element) ->
    {footer, p} = element

    @component = React.createFactory React.createClass
      render: ->
        footer {},
          login.component {} if !usersStore.isLogged()
          p {}, 'Songary © 2014'
