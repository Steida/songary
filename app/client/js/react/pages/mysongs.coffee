goog.provide 'app.react.pages.MySongs'

class app.react.pages.MySongs

  ###*
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @param {app.react.Touch} touch
    @param {app.Firebase} firebase
    @constructor
  ###
  constructor: (routes, userStore, touch, firebase) ->
    {div,h1,ul,li,p,nav,button} = React.DOM
    {a} = touch.scroll 'a'

    @component = React.createClass

      render: ->
        # TODO: Add byName sort option.
        songs = userStore.songsSortedByUpdatedAt()
        visibleSongs = songs.filter (song) -> !song.inTrash
        deletedSongs = songs.filter (song) -> song.inTrash

        div className: 'page',
          if songs.length
            ul className: 'songs', visibleSongs.map (song) ->
              li key: song.id,
                a href: routes.mySong.url(song),
                  "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          else
            p {}, MySongs.MSG_NO_SONGS
          nav {},
            a
              className: 'btn btn-link'
              href: routes.newSong.url()
            , MySongs.MSG_ADD_NEW_SONG
            if deletedSongs.length > 0
              a
                className: 'btn btn-link'
                href: routes.trash.url()
              , "Trash (#{deletedSongs.length})"

  @MSG_ADD_NEW_SONG: goog.getMsg 'Add Song'
  @MSG_NO_SONGS: goog.getMsg "
    You have no songs stored on your device yet. Add or search one.
  "
