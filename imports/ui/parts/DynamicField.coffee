import React from 'react'
import AutoForm from '../uniforms-react/AutoFormWrapper'
import AutoField from '../uniforms-react/CustomAutoField'
import connectField from 'uniforms/connectField'
import _ from 'lodash'

#Todo: find a better place in the file structure for this
export default DynamicField = ({schema, fieldName, label, value, onChange, validate}) ->
    
  value ?= null
  onChange ?= (value) -> console.log 'onChange:', value

  onClick = (e) ->
    e.stopPropagation()
    e.nativeEvent.stopImmediatePropagation()

  handleChange = (model) ->
    modelValue = model[fieldName]
    unless _.isEqual value, modelValue
      onChange modelValue

  <div onClick={onClick}>
    <AutoForm
      schema={schema.pick fieldName}
      model={"#{fieldName}": value}
      onChangeModel={handleChange}
      validate={validate}
    >
      <AutoField name={fieldName} label={label}/>
    </AutoForm>
  </div>
