import React from 'react'
import { Icon } from 'semantic-ui-react'
import DynamicTableField from './DynamicTableField'

style =
  padding: "4px 0"

export default AutoTableAutoField = ({row, columnKey, schemaBridge, onChangeField, measure, mayEdit}) ->
  fieldSchema = schemaBridge.schema._schema[columnKey]
  inner =
    if (component = fieldSchema.AutoTable?.component)?
      try
        component {row, columnKey, schemaBridge, onChangeField, measure, mayEdit}
      catch error
        console.error error
        console.log 'the previous error happened in AutoTableField with params', {row, columnKey, schemaBridge, component}
    else if fieldSchema.AutoTable?.editable
      <DynamicTableField {{row, columnKey, schemaBridge, onChangeField, mayEdit}...}/>
    else if fieldSchema.AutoTable?.markup
      <div dangerouslySetInnerHTML={__html: row[columnKey]} />
    else
      switch fieldType = fieldSchema.type.definitions[0].type
        when Date
          <span>{row[columnKey]?.toLocaleString()}</span>
        when Boolean
          <Icon name={if row[columnKey] then 'check' else 'close'} />
        when Array
          row[columnKey]?.map (entry, i) ->
            <div key={i} style={whiteSpace: 'normal', marginBottom: '.2rem'}>{entry}</div>
        else
          row[columnKey] ? null

  <div style={style}>{inner}</div>
    