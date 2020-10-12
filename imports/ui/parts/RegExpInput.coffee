import React, {useState, useEffect} from 'react'
import classnames from 'classnames'
import {connectField} from 'uniforms'
import filterDOMProps from 'uniforms/filterDOMProps'
import { Input, Form } from 'semantic-ui-react'

export default connectField ({
  className,
  disabled,
  error,
  errorMessage,
  icon,
  iconLeft,
  iconProps,
  id,
  inputRef,
  label,
  name,
  onChange,
  placeholder,
  required,
  showInlineError,
  type,
  value,
  wrapClassName,
  props...
}) ->

  [stringValue, setStringValue] = useState value.toString().replace /\//g, ''
  [invalid, setInvalid] = useState false

  handleChange = (e, d) ->
    try
      re = new RegExp(d.value)
      setStringValue d.value
      setInvalid false
      onChange(re)
    catch error
      setStringValue d.value
      setInvalid true
  <div
     className={classnames(className, { disabled, error, required }, 'field')}
    {filterDOMProps(props)...}
  >
    {if label then <label htmlFor={id}>{label}</label>}
    <Input
      style={if invalid then outline: '1pt solid red'}
      placeholde="RegExp eingeben"
      value={stringValue}
      onChange={handleChange}
    />
    {if showInlineError and error? then <div className="ui red basic pointing label">{errorMessage}</div>}
  </div>