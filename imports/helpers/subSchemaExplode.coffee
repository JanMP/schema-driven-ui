import _ from 'lodash'
export default subSchemaExplode = (definitionObject, options) ->
  options ?= {}
  {optional, required} = options
  if optional? and required?
    throw new Error 'only one of optional or required may be defined in subSchemaExpolode options'
  if required?
    optional = not required
  optional ?= false

  key = _.keys(definitionObject)[0]
  isArray = _.isArray definitionObject[key]
  value = if isArray then definitionObject[key][0] else definitionObject[key]
  header =
    if isArray
      "#{key}":
        type: Array
        optional: optional
      "#{key}.$":
        type: Object
        optional: optional
    else
      "#{key}":
        type: Object
        optional: optional
  body =
    _.mapKeys value, (v, subKey) -> "#{key}#{if isArray then '.$.' else '.'}#{subKey}"
  {header..., body...}