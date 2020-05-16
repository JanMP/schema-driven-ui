import React from 'react'
import AutoForm from '../uniforms-react/AutoFormWrapper'
import AutoField from '../uniforms-react/CustomAutoField'
import connectField from 'uniforms/connectField'

#Todo: find a better place in the file structure for this
export default DynamicField = ({schema, fieldName, label, value, onChange}) ->
    
  value ?= null
  onChange ?= (value) -> console.log 'onChange:', value

  <AutoForm
    schema={schema.pick fieldName}
    model={"#{fieldName}": value}
    onChangeModel={(model) -> onChange model[fieldName]}
  >
    <AutoField name={fieldName} label={label}/>
  </AutoForm>
