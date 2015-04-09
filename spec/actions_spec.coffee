Fallout = require '../dist/fallout.js'

beforeEach ->
  Fallout.actions = {}

describe '#defineActionSet', ->

  it 'sets the actions for a given name', ->
    actions =
      a: sinon.spy()
      b: sinon.spy()
    Fallout.defineActionSet 'test', actions
    expect(Fallout.actions['test']).to.eq actions
