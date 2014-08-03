goog.provide 'app.Routes'

goog.require 'este.Routes'

class app.Routes extends este.Routes

  ###*
    @param {app.Storage} storage
    @constructor
    @extends {este.Routes}
  ###
  constructor: (@storage) ->
    super()

    @home = @route '/'
    @myNewSong = @route '/@me/songs/new'
    @mySong = @route '/@me/songs/:id'
    @editMySong = @route '/@me/songs/:id/edit'
    @notFound = @route '*'