
riot.tag2('rest', '<yield></yield>', '', '', function(opts) {
this.on('mount', function() {
  if (opts.src) {
    return this.load();
  }
});

this.load = (function(_this) {
  return function() {
    var xhr;
    xhr = new XMLHttpRequest();
    xhr.open('GET', encodeURI(opts.src));
    xhr.onload = function() {
      var res;
      if (xhr.status === 200) {
        res = JSON.parse(xhr.responseText);
        if (Array.isArray(res)) {
          return _this[opts.data] = res.map(function(row) {
            row.$save = _this.save;
            return row;
          });
        } else {
          res.$save = _this.save;
          return res;
        }
      }
    };
    return xhr.send();
  };
})(this);

this.save = (function(_this) {
  return function() {};
})(this);
});