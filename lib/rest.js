
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
      if (xhr.status === 200) {
        return _this[opts.data] = JSON.parse(xhr.responseText);
      }
    };
    return xhr.send();
  };
})(this);
});