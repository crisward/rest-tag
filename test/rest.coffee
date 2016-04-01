window.riot = require('riot')
require '../lib/rest.js'
datagen = require './mockdata'
domnode = null
tag = null
opts = {}

if !('remove' in window.Element.prototype)
  window.Element.prototype.remove = -> if @parentNode then @parentNode.removeChild(@) 

describe 'rest',->

  beforeEach ->
    domnode = document.createElement('div')
    domnode.appendChild(document.createElement('rest'))
    node = document.body.appendChild(domnode)
    tag = riot.mount('rest',opts)[0]
    
  afterEach ->
    tag.unmount()
    domnode.remove()

  it "should exit",->
    expect(document.querySelector('rest')).to.not.be.null
  
  