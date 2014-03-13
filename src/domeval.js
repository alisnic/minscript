(function () {
  var tags = document.querySelectorAll('script');
  var scripts = Array.prototype.filter.call(tags, function(s) {
    return s.getAttribute('type') === 'text/minscript';
  });

  Array.prototype.forEach.call(scripts, function (s) {
    MinScript.eval(s.textContent);
  });
})();
