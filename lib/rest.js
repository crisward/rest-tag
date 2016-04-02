
riot.tag2('rest', '<yield></yield>', '', '', function(opts) {
this.on('mount', function() {
  if (opts.src) {
    return this.load(opts.src);
  }
});

this.load = (function(_this) {
  return function(url) {
    var xhr;
    xhr = new XMLHttpRequest();
    xhr.open('GET', encodeURI(url));
    xhr.onload = function() {
      var res;
      if (xhr.status === 200) {
        res = JSON.parse(xhr.responseText);
        return _this[opts.data] = _this._addSave(res);
      }
    };
    return xhr.send();
  };
})(this);

this.save = (function(_this) {
  return function() {};
})(this);

this._addSave = (function(_this) {
  return function(data) {
    if (Array.isArray(data)) {
      return data.map(function(row) {
        row.$save = _this.save;
        return row;
      });
    } else {
      data.$save = _this.save;
      return data;
    }
  };
})(this);
});