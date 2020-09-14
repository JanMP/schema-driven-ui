import React from 'react'
import AutoForm from '../uniforms-react/AutoForm'
import AutoField from '../uniforms-react/AutoField'
import {connectField} from 'uniforms'
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
