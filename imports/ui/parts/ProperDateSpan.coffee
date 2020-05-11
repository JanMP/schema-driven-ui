import React from 'react'

export default ProperDateSpan = ({row, columnKey, schema}) ->
  
  return null unless (d = row?[columnKey])?

  fixedDate = "#{d[6..7]}.#{d[4..5]}.#{d[0..3]}, #{d[8..9]}:#{d[10..11]}"
  

  <span>{fixedDate}</span>