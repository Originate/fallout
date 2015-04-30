Fallout = require '../dist/fallout.js'
Immutable = require 'immutable'

beforeEach ->
  Fallout.store.listeners = []
  Fallout.store.data = Immutable.Map()

describe 'Store', ->

  describe '#checkIn', ->

    it 'sets data in an empty store', ->
      data = foo: 'bar'
      Fallout.store.checkIn data
      expect(Fallout.store.data.get 'foo').to.eq 'bar'

    it 'updates data in a store', ->
      Fallout.store.data = Fallout.store.data.set 'foo', 'bar'
      data = Fallout.store.checkOut()
      data.foo = 'baz'
      Fallout.store.checkIn data
      expect(Fallout.store.data.get 'foo').to.eq 'baz'

    it 'alerts listeners of the change', ->
      listener = sinon.spy()
      Fallout.store.observe listener
      data = foo: 'bar'
      Fallout.store.checkIn data
      expect(listener).to.have.been.called

  describe '#checkOut', ->

    it 'returns a plan object representation of the store', ->
      data = Fallout.store.checkOut()
      expect(data.constructor).to.eq Object

    it 'returns the data in the store', ->
      Fallout.store.data = Fallout.store.data.set 'foo', 'bar'
      data = Fallout.store.checkOut()
      expect(data.foo).to.eq 'bar'

  describe '#ignore', ->

    it 'removes the listener when already added', ->
      listener = ->
      Fallout.store.observe listener
      Fallout.store.ignore listener
      expect(Fallout.store.listeners).to.have.length 0

    it 'can be called even if the listener is not registered', ->
      listener = ->
      Fallout.store.ignore listener
      expect(Fallout.store.listeners).to.have.length 0

  describe '#initialize', ->

    it 'initializes the store with the specified data', ->
      Fallout.store.initialize a: 1
      expect(Fallout.store.checkOut().a).to.eq 1

    it 'alerts listeners of the change', ->
      listener = sinon.spy()
      Fallout.store.observe listener
      Fallout.store.initialize a: 1
      expect(listener).to.have.been.called

  describe '#observe', ->

    it 'adds the listener when already added', ->
      listener = ->
      Fallout.store.observe listener
      expect(Fallout.store.listeners).to.include listener

    it 'does not add the listener when already added', ->
      listener = ->
      Fallout.store.observe listener
      Fallout.store.observe listener
      expect(Fallout.store.listeners).to.have.length 1

  describe '#setData', ->

    it 'sets the store data to the supplied Immutable structure', ->
      Fallout.store.setData Immutable.Map a: 1
      expect(Fallout.store.data.get 'a').to.eq 1

    it 'alerts listeners of the change', ->
      listener = sinon.spy()
      Fallout.store.observe listener
      Fallout.store.setData Immutable.Map a: 1
      expect(listener).to.have.been.called

