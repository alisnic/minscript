wrap = (moduleName, js)->
  "(function(exports){
    #{js}
  })(typeof exports === 'undefined'? this['#{moduleName}']={}: exports);"

exports.wrap = wrap