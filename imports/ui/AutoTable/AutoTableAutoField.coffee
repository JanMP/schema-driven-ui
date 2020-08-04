import React from 'react'
import { Icon } from 'semantic-ui-react'
import DynamicTableField from './DynamicTableField'


export default AutoTableAutoField = ({row, columnKey, schema, onChangeField}) ->
  fieldSchema = schema._schema[columnKey]
  if (component = fieldSchema.AutoTable?.component)?
    component {row, columnKey, schema}
  else if fieldSchema.AutoTable?.editable
    <DynamicTableField {{row, columnKey, schema, onChangeField}...}/>
  else if fieldSchema.AutoTable?.markup
    <div dangerouslySetInnerHTML={__html: row[columnKey]} />
  else
    switch fieldType = fieldSchema.type.definitions[0].type
      when Boolean
        <Icon name={if row[columnKey] then 'check' else 'close'} />
      else
        row[columnKey] ? null