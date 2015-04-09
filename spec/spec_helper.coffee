global.chai = require 'chai'
global.expect = chai.expect
global.sinon = require 'sinon'

chai.use require 'sinon-chai'

process.env.NODE_ENV = 'test'
