import objectPath from 'object-path'
import defaultFormatters from '../../helpers/defaultFormatters'
import _ from 'lodash'

export default markdownWithData = ({markdown, data, formatters, helpWithData}) ->
  
  formatters ?= defaultFormatters

  replacer = (match, pathStr, formatterStr) ->
    parentPath = pathStr.replace /(.*)\..*/g, '$1'
    valueForPathStr = (objectPath.get data, pathStr) ? (objectPath.get data, parentPath) ? data
    formatter = formatters[formatterStr] ? (x) -> x
    unless (_.isObject valueForPathStr) or (formatterStr? and not formatters[formatterStr]?)
      return formatter valueForPathStr
    formatterHelpDisplay = pathHelpDisplay = ''
    if helpWithData
      if formatterStr? and not formatters[formatterStr]?
        matchingFormatters =
          _(formatters)
          .keys()
          .filter (key) -> ///#{formatterStr}///.test key
          .value().join(' ')
        formatterHelpDisplay = "<div class='formatter-help'>#{matchingFormatters}</div>"
      if _.isObject valueForPathStr
        pathHelpDisplay = "<div class='path-help'><pre>#{JSON.stringify valueForPathStr, null, '　　'}</pre></div>"
      return "#{match}\n\n#{formatterHelpDisplay}#{pathHelpDisplay}\n\n"
    return '[keine Daten]'

  if data?
    markdown.replace /@@([-.äöüÄÖÜßa-zA-Z0-9]*)(?:(?: ?\| ?)([0-9a-zA-Z.]*))?/gm, replacer
  else
    markdown