rest
  <yield />
  
  script(type='coffee').
  
    @on 'mount',->
      @load(opts.src) if opts.src
      
    @load = (url)=>
      xhr = new XMLHttpRequest()
      xhr.open('GET', encodeURI(url))
      xhr.onload = => 
        if xhr.status==200
          res = JSON.parse(xhr.responseText)
          @[opts.data] = _addSave(res,url)
      xhr.send()
      
    @save = (url)->
      xhr = new XMLHttpRequest()
      delete @.save
      if @.id?
        xhr.open('PUT', encodeURI(url+"/"+@.id))
      else
        xhr.open('POST', encodeURI(url))
      xhr.setRequestHeader('Content-Type', 'application/json')
      xhr.onload = =>
        if xhr.status==200
          res = JSON.parse(xhr.responseText)
          @[key] = val for key,val of res
          _addSave(@,url)
      xhr.send(JSON.stringify(@))
    
    _addSave = (data,url)=>
      if Array.isArray(data)
        data.map (row)=> 
          row.$save = @save.bind(row,url)
          return row
      else
        data.$save = @save.bind(data,url)
        return data
      
      