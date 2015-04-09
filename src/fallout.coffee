((root, factory) ->

  if typeof define is 'function' and define.amd
    define ['immutable', 'exports'], (Immutable, exports) ->
      root.Fallout = factory root, exports, Immutable

  else if typeof exports isnt 'undefined'
    Immutable = require 'immutable'
    factory root, exports, Immutable

  else
    root.Fallout = factory root, {}, root.Immutable

)(this, (root, Fallout, Immutable) ->

  Fallout.Immutable = Immutable

  Fallout.Store = class
    constructor: ->
      @data = Immutable.Map()
      @listeners = []

    emitChange: ->
      for listener in @listeners
        listener.call(this)

    observe: (handler) ->
      unless @listeners.indexOf(handler) >= 0
        @listeners.push handler

    ignore: (handler) ->
      index = @listeners.indexOf handler
      return unless index >= 0
      @listeners.splice(index, 1)

    checkOut: ->
      @data.toJS()

    checkIn: (newData) ->
      @data = @data.mergeDeep newData
      @emitChange()

  Fallout.store = new Fallout.Store()

  Fallout.actions = {}

  Fallout.defineActionSet = (name, params) ->
    Fallout.actions[name] = params
    Fallout.actions[name].store = Fallout.store

  Fallout.Mixin =
    componentWillMount: ->
      @actions = Fallout.actions
      for name, selector of @_falloutWatchSelectors()
        @_updateStateFromFallout name, Fallout.store.data.getIn selector

    componentDidMount: ->
      Fallout.store.observe @onFalloutStoreChange

    componentWillUnmount: ->
      Fallout.store.ignore @onFalloutStoreChange

    onFalloutStoreChange: ->
      for name, selector of @_falloutWatchSelectors()
        storeValue = Fallout.store.data.getIn selector
        unless @state["_#{name}"] is storeValue
          @_updateStateFromFallout name, storeValue

    _falloutWatchSelectors: ->
      if @watch?
        selectors = if typeof(@watch) is 'function'
          @watch()
        else
          @watch
      else
        {}

    _updateStateFromFallout: (name, value) ->
      newState = {}
      if value? and value.toJS?
        newState[name] = value.toJS()
      else
        newState[name] = value
      newState["_#{name}"] = value
      @setState newState

  Fallout
)
