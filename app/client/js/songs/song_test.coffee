suite 'app.songs.Song', ->

  Song = app.songs.Song
  song = null

  createSong = (name, artist, lyrics) ->
    song = new Song
    song.name = name
    song.artist = artist
    song.lyrics = lyrics
    song

  suite 'validate', ->
    test 'should return empty array for valid song', ->
      song = createSong 'Name', 'Artist', 'Bla [Ami]'
      assert.deepEqual song.validate(), []

    test 'should validate invalid name', ->
      song = createSong ' ', 'Artist', 'Bla [Ami]'
      assert.deepEqual song.validate(), [
        prop: 'name'
        message: 'Please fill out name.'
      ]

    test 'should validate invalid artist', ->
      song = createSong 'Hey Jude', ' ', '..'
      assert.deepEqual song.validate(), [
        prop: 'artist'
        message: 'Please fill out artist.'
      ]

    test 'should validate invalid lyrics', ->
      song = createSong 'Hey Jude', 'Beatles', ''
      assert.deepEqual song.validate(), [
        prop: 'lyrics'
        message: 'Please fill out lyrics.'
      ]

  suite 'update', ->
    test 'should ensure model state', ->
      song = new Song
      song.name = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
      song.artist = 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'
      song.lyrics = new Array(32001).join 'a'
      song.update()
      assert.equal song.urlName, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
      assert.equal song.urlArtist, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
      assert.equal song.lyrics.length, 32000