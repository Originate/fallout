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

    checkIn: (newData) ->
      @data = @data.mergeDeep newData
      @emitChange()

    checkOut: ->
      @data.toJS()

    emitChange: ->
      listener?.call this for listener in @listeners

    ignore: (handler) ->
      index = @listeners.indexOf handler
      @listeners.splice index, 1 if index >= 0

    initialize: (initialData) ->
      @data = Immutable.fromJS initialData
      @emitChange()

    observe: (handler) ->
      @listeners.push handler unless @listeners.indexOf(handler) >= 0

    setData: (newData) ->
      @data = newData
      @emitChange()

  Fallout.store = new Fallout.Store()

  Fallout.actions = {}

  Fallout.defineActionSet = (name, params) ->
    Fallout.actions[name] = params
    Fallout.actions[name].store = Fallout.store
    Fallout.actions[name].actions = Fallout.actions

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
        unless Immutable.is @state["_#{name}"], storeValue
          @_updateStateFromFallout name, storeValue

    _falloutWatchSelectors: ->
      if @watch?
        if typeof(@watch) is 'function' then @watch() else @watch
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
