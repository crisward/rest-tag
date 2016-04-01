rest
  <yield />
  
  script(type='coffee').
  
    @on 'mount',->
      @load() if opts.src
      
    @load = =>
      xhr = new XMLHttpRequest()
      xhr.open('GET', encodeURI(opts.src))
      xhr.onload = => if xhr.status==200 then @[opts.data] = JSON.parse(xhr.responseText) 
      xhr.send()