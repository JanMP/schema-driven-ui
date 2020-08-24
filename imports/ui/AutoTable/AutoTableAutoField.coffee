import React from 'react'
import { Icon } from 'semantic-ui-react'
import DynamicTableField from './DynamicTableField'

style =
  padding: "4px 0"

export default AutoTableAutoField = ({row, columnKey, schema, onChangeField}) ->
  fieldSchema = schema._schema[columnKey]
  inner =
    if (component = fieldSchema.AutoTable?.component)?
      try
        component {row, columnKey, schema}
      catch error
        console.log 'following error in AutoTableField', {row, columnKey, schema}
        console.error error
    else if fieldSchema.AutoTable?.editable
      <DynamicTableField {{row, columnKey, schema, onChangeField}...}/>
    else if fieldSchema.AutoTable?.markup
      <div dangerouslySetInnerHTML={__html: row[columnKey]} />
    else
      switch fieldType = fieldSchema.type.definitions[0].type
        when Boolean
          <Icon name={if row[columnKey] then 'check' else 'close'} />
        when Array
          row[columnKey]?.map (entry, i) -> <div key={i} style={whiteSpace: 'normal', marginBottom: '.2rem'}>{entry}</div>
        else
          row[columnKey] ? null

  <div style={style}>{inner}</div>
    