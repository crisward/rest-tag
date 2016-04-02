window.riot = require('riot')
require '../lib/rest.js'
datagen = require './mockdata'
domnode = null
tag = null
opts = {src:"/api/users",data:"users"}
requests = null

if !('remove' in window.Element.prototype)
  window.Element.prototype.remove = -> if @parentNode then @parentNode.removeChild(@) 

describe 'rest',->

  beforeEach ->
    @xhr = sinon.useFakeXMLHttpRequest()
    requests = []
    @xhr.onCreate = (xhr)-> requests.push(xhr)   
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
      
  describe "after data loaded",->
    
    beforeEach ->
      requests[0].respond(200, {"Content-Type": "application/json"},JSON.stringify(datagen(10)))
    
    it "should have access to data",->
      expect(tag.users.length).to.equal(10)
      
    it "should have a $save method on each element in the collection",->
      expect(tag.users[0].$save).to.exist