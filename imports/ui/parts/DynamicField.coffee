import React, {useEffect, useState} from 'react'
import AutoForm from '../uniforms-react/AutoForm'
import AutoField from '../uniforms-react/AutoField'
import {connectField} from 'uniforms'
import SimpleSchema2Bridge from 'uniforms-bridge-simple-schema-2'
import _ from 'lodash'

#Todo: find a better place in the file structure for this
export default DynamicField = ({schemaBridge, fieldName, label, value, onChange, validate, mayEdit}) ->
    
  value ?= null
  onChange ?= (value) -> console.log 'onChange:', value

  schemaBridgeForFieldName = new SimpleSchema2Bridge schemaBridge?.schema.pick fieldName

  onClick = (e) ->
    e.stopPropagation()
    e.nativeEvent.stopImmediatePropagation()

  handleChange = (model) ->
    modelValue = model[fieldName]
    unless _.isEqual value, modelValue
      onChange modelValue

  <div onClick={onClick}>
    <AutoForm
      schema={schemaBridgeForFieldName}
      model={"#{fieldName}": value}
      onChangeModel={handleChange}
      validate={validate}
    >
      <AutoField name={fieldName} label={label} disabled={not mayEdit}/>
    </AutoForm>
  </div>
