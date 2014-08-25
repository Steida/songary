goog.provide 'app.react.Login'

class app.react.Login

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @param {app.user.Store} userStore
    @param {app.Firebase} firebase
    @constructor
  ###
  constructor: (routes, touch, userStore, firebase) ->
    {button} = touch.none 'button'

    @component = React.createClass
      render: ->
        button
          onPointerUp: @onButtonPointUp
        , @getButtonLabel()

      onButtonPointUp: (e) ->
        if userStore.user
          routes.home.redirect()
          firebase.logout()
        else
          firebase.loginViaFacebook()

      getButtonLabel: ->
        if userStore.user
          Login.MSG_LOGOUT = goog.getMsg 'Logout {$displayName}',
            'displayName': userStore.user.displayName
        else
          Login.MSG_LOGIN_WITH_FACEBOOK = goog.getMsg 'Log in with Facebook'
