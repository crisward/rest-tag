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
          if Array.isArray(res)
            @[opts.data] = res.map (row)=> 
              row.$save = @save
              return row
          else
            res.$save = @save
            return res
      xhr.send()
      
    @save = =>
      