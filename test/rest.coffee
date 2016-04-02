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
      
  describe "after collection loaded",->
    
    beforeEach ->
      requests[0].respond(200, {"Content-Type": "application/json"},JSON.stringify(datagen(10)))
    
    it "should have access to data",->
      expect(tag.users.length).to.equal(10)
      
    it "should have a $save method on each element in the collection",->
      expect(tag.users[0].$save).to.exist
      
  describe "after record loaded",->
    
    beforeEach ->
      requests[0].respond(200, {"Content-Type": "application/json"},JSON.stringify(datagen(1)[0]))
    
    it "should have access to data",->
      expect(requests[0].url).to.equal("/api/users")
      expect(tag.users.first_name).to.exist
      
    it "should have a $save method on each element in the collection",->
      expect(tag.users.$save).to.exist
      
    it "should update data with PUT when save is called on record with id",->
      tag.users.id = 5
      tag.users.$save()
      expect(requests.length).to.equal(2)
      body = JSON.parse(requests[1].requestBody)
      expect(requests[1].requestHeaders['Content-Type']).to.contain('json')
      expect(body.id).to.eql(tag.users.id)
      expect(body.first_name).to.equal(tag.users.first_name)
      expect(requests[1].method).to.equal('PUT')
      expect(requests[1].url).to.equal("/api/users/5")
 
    it "should insert data with POST when save is called on record without an id",->
      delete tag.users.id
      tag.users.$save()
      expect(requests.length).to.equal(2)
      body = JSON.parse(requests[1].requestBody)
      expect(requests[1].requestHeaders['Content-Type']).to.contain('json')
      expect(body.id).to.eql(tag.users.id)
      expect(body.first_name).to.equal(tag.users.first_name)
      expect(requests[1].method).to.equal('POST')
      expect(requests[1].url).to.equal("/api/users")
 
    it "should update data with server response",->
      tag.users.$save()
      requests[1].respond(200, {"Content-Type": "application/json"},JSON.stringify({id:1,first_name:"cris"}))
      expect(tag.users.first_name).to.equal("cris")
      
      