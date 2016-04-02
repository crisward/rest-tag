
riot.tag2('rest', '<yield></yield>', '', '', function(opts) {
var _addSave;

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
        return _this[opts.data] = _addSave(res, url);
      }
    };
    return xhr.send();
  };
})(this);

this.save = function(url) {
  var xhr;
  xhr = new XMLHttpRequest();
  delete this.save;
  if (this.id != null) {
    xhr.open('PUT', encodeURI(url + "/" + this.id));
  } else {
    xhr.open('POST', encodeURI(url));
  }
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.onload = (function(_this) {
    return function() {
      var key, res, val;
      if (xhr.status === 200) {
        res = JSON.parse(xhr.responseText);
        for (key in res) {
          val = res[key];
          _this[key] = val;
        }
        return _addSave(_this, url);
      }
    };
  })(this);
  return xhr.send(JSON.stringify(this));
};

_addSave = (function(_this) {
  return function(data, url) {
    if (Array.isArray(data)) {
      return data.map(function(row) {
        row.$save = _this.save.bind(row, url);
        return row;
      });
    } else {
      data.$save = _this.save.bind(data, url);
      return data;
    }
  };
})(this);
});