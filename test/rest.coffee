window.riot = require('riot')
require '../lib/rest.js'
datagen = require './mockdata'
domnode = null
tag = null
opts = {src:"/api/users",data:"users"}

if !('remove' in window.Element.prototype)
  window.Element.prototype.remove = -> if @parentNode then @parentNode.removeChild(@) 

describe 'rest',->

  beforeEach ->
    @xhr = sinon.useFakeXMLHttpRequest()
    @requests = []
    @xhr.onCreate = (xhr)=> @requests.push(xhr)   
    domnode = document.createElement('div')
    domnode.appendChild(document.createElement('rest'))
    node = document.body.appendChild(domnode)
    tag = riot.mount('rest',opts)[0]
    
  afterEach ->
    tag.unmount()
    domnode.remove()
    @xhr.restore()

  it "should exit",->
    expect(document.querySelector('rest')).to.not.be.null
    
  it "should load data",->
    expect(@requests.length).to.equal(1)
  
  it "should have access to data",->
    @requests[0].respond(200, {"Content-Type": "application/json"},JSON.stringify(datagen(10)))
    expect(tag.users.length).to.equal(10)
    