import _ from 'lodash'


conjunctions =
  $and:
    text: 'alle Bedingungen erfüllt'
  $or:
    text: 'mindestens eine Bedingung erfüllt'
  $nor:
    text: 'keine der Bedingungen erfüllt'

logicConjunctionSelectOptions =
  _(conjunctions)
  .keys()
  .map (key) ->
    value = conjunctions[key]
    return
      value: key
      text: value.text
      context: value.context?.key ? null
  .value()

export getConjunctionData = ({bridge, path, type}) ->
  if type is 'logicBlock'
    return logicConjunctionSelectOptions
  else
    fields = bridge.getSubfields path
    pathWithName = (name) -> if path then "#{path}.#{name}" else name
    return contextConjunctionSelectOptions =
      _(fields)
      .filter (name) ->
        (bridge.getType pathWithName name) in [Array, Object]
      .map (name) ->
        label = bridge.schema._schema[name]?.label ? name
        text = switch type = bridge.getType pathWithName name
          when Array then "für mindestens einen Eintrag im Underdokument #{label}"
          when Object then "für das Unterdokument #{label}"
          else "FEHLER"
        return
          value: name
          context: name
          isArrayContext: type is Array
          text: text
      .value()

export getConjunctionSelectOptions = ({bridge, path, type}) ->
  getConjunctionData({bridge, path, type}).map (conjunction) -> _.pick conjunction, ['value', 'text']
