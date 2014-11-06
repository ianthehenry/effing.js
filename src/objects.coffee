module.exports =
  get: (key) -> (obj) -> obj[key]
  set: (obj, key) -> (val) -> obj[key] = val
