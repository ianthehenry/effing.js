{ guard } = require './functions'

magicInitialValue = {}
module.exports = (baseFunction) ->
  latestLeasedFunction = magicInitialValue
  return lease: ->
    latestLeasedFunction = leasedFunction = guard baseFunction, ->
      latestLeasedFunction == magicInitialValue ||
      leasedFunction == latestLeasedFunction
