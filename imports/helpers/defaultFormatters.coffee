export default defaultFormatters =
  datum: (value) ->
    return '[kein gültiger Wert für Umwandlung in Datum]' unless /^\d{12}$/.test value
    value.replace /^(\d{4})(\d{2})(\d{2})\d*/, "$3.$2.$1"
  uhrzeit: (value) ->
    return '[kein gültiger Wert für Umwandlung in Uhrzeit]' unless /^\d{12}$/.test value
    value.replace /^\d{8}(\d{2})(\d{2})/, "$1:$2"
  datumUndUhrzeit: (value) ->
    return '[kein gültiger Wert für Umwandlung in Datum und Uhrzeit]' unless /^\d{12}$/.test value
    value.replace /^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})/, "$3.$2.$1, $4:$5"