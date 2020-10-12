import {Meteor} from 'meteor/meteor'
import React, {useState, useEffect} from 'react'
import classnames from 'classnames'
import {connectField} from 'uniforms'
import filterDOMProps from 'uniforms/filterDOMProps'
import { Dropdown, Form } from 'semantic-ui-react'

import _ from 'lodash'

# TODO just kept for reference; delete when SearchQuearyField/Cell is done
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

  [selectOptions, setSelectOptions] = useState []

  handleChange = (e, d) ->
    if d.value isnt value then onChange?(d.value)

  getSelectOptions = (searchQuery) ->
    Meteor.call 'getIcdSelectOptions',
      search: searchQuery
    ,
      (error, result) -> if error then console.error error else setSelectOptions result

  useEffect ->
    getSelectOptions value
  , [value]

  <div
     className={classnames(className, { disabled, error, required }, 'field')}
    {filterDOMProps(props)...}
  >
    {if label then <label htmlFor={id}>{label}</label>}
    <Dropdown
      style={minWidth: '12rem'}
      placeholder="Bitte auswählen"
      search
      selection
      fluid
      options={selectOptions}
      onSearchChange={(e,d) -> getSelectOptions d.searchQuery}
      value={value}
      onChange={handleChange}
    />
    {if showInlineError and error? then <div className="ui red basic pointing label">{errorMessage}</div>}
  </div>
