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
          @[opts.data] = @_addSave(res)
      xhr.send()
      
    @save = =>
    
    @_addSave = (data)=>
      if Array.isArray(data)
        data.map (row)=> 
          row.$save = @save
          return row
      else
        data.$save = @save
        return data
      
      