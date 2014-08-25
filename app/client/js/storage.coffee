goog.provide 'app.Storage'

goog.require 'este.labs.Storage'
goog.require 'goog.async.Throttle'
goog.require 'goog.structs.Map'
goog.require 'goog.structs.Set'

class app.Storage extends este.labs.Storage

  ###*
    @param {app.LocalStorage} localStorage
    @param {app.Firebase} firebase
    @param {app.user.Store} userStore
    @constructor
    @extends {este.labs.Storage}
    @final
  ###
  constructor: (@localStorage, @firebase, @userStore) ->
    super()

    @stores = [@userStore]
    @storesStates = new goog.structs.Map
    @pendingStores = new goog.structs.Set
    @save = new goog.async.Throttle @savePendingStores, Storage.THROTTLE_MS, @

    @localStorage.load @stores
    @listenStores()
    @firebase.simpleLogin()

  @THROTTLE_MS: 1000

  ###*
    TODO: Handle error.
    @private
  ###
  savePendingStores: ->
    stores = @pendingStores.getValues()
    @pendingStores.clear()
    for store in stores
      json = @deepCopy store.toJson()
      @saveStoreToClient store, json
      @saveStoreToServer store, json
    return

  ###*
    @param {este.labs.Store} store
    @param {Object} json
    @private
  ###
  saveStoreToClient: (store, json) ->
    console.log 'storage.saveStoreToClient' if goog.DEBUG
    @localStorage.set store, json

  ###*
    TODO: Try JSONPatch, https://github.com/facebook/immutable-js/issues/52.
    @param {este.labs.Store} store
    @param {Object} json
    @private
  ###
  saveStoreToServer: (store, json) ->
    console.log 'storage.saveStoreToServer' if goog.DEBUG
    isUserStoreWithUser = store instanceof app.user.Store && store.user
    if isUserStoreWithUser
      if @firebase.userRef
        console.log '@firebase.userRef.set json' if goog.DEBUG
        json.updated = Firebase.ServerValue.TIMESTAMP
        @firebase.sync -> @userRef.set json

  ###*
    @private
  ###
  listenStores: ->
    @stores.forEach (store) =>
      store.listen 'change', @onStoreChange.bind @, store

  ###*
    @param {este.labs.Store} store
    @param {goog.events.Event} e
    @private
  ###
  onStoreChange: (store, e) ->
    console.log 'onStoreChange e.target: ', e.target if goog.DEBUG

    # NOTE: This is only for dev.
    # return if !@storeStateChanged store, @deepCopy store.toJson()

    if e.target instanceof app.Firebase
      @saveStoreToClient store, @deepCopy store.toJson()
      @notify()
      return

    if e.target instanceof app.LocalStorage
      @notify()
      return

    # Postpone local changes persistence. It saves traffic and cpu.
    @pendingStores.add store
    @save.fire()
    # But update UI immediately.
    @notify()

  ###*
    @override
  ###
  load: (route, params, routes) ->
    switch route
      when routes.mySong, routes.editMySong
        return @notFound() if !@userStore.songById params.id
        @ok()
      else
        @ok()

  # ###*
  #   NOTE: This is only for dev.
  #   Check if store state has changed.
  #   @param {este.labs.Store} store
  #   @param {Object} json
  #   @return {boolean}
  # ###
  # storeStateChanged: (store, json) ->
  #   jsonString = JSON.stringify json
  #   return false if @storesStates.get(store) == jsonString
  #   @storesStates.set store, jsonString
  #   true
