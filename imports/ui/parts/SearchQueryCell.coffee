import {Meteor} from 'meteor/meteor'
import meteorApply from '../../helpers/meteorApply'
import React, {useEffect, useState} from 'react'
import connectWithFormField from './connectWithFormField'
import {Dropdown} from 'semantic-ui-react'
import _ from 'lodash'

optionCache =
  do ->
    cacheObj = {}
    
    add: ({value, text}) ->
      console.log "optionCache.add #{JSON.stringify {value, text}, null}"
      console.log "result", cacheObj = {cacheObj..., "#{value}": text}
    get: (value) ->
      console.log "optionCache.get #{value}"
      console.log result = cacheObj[value]
      result

console.log optionCache
optionCache.add value: "fnord", text: "You may not look at the Fnord!"
console.log optionCache.get "fnord"


export default SearchQueryField = ({row, columnKey, schema, onChangeField, measure}) ->

  value = row?[columnKey]

  unless (options = schema?._schema?[columnKey]?.AutoTable)?
    throw new Error "[SearchQueryCell]: missing AutoTable options in schema for key: #{columnKey}"

  placeholder = options.placeholder ? 'Bitte auswählen'

  unless (method = options.method)?
    throw new Error "[SearchQueryCell]: AutoTable.method must be supplied in schema for key: #{columnKey}"
  
  [search, setSearch] = useState value
  [selectOptions, setSelectOptions] = useState []

  getSelectOptions = (selectValue) ->
    if selectValue? and (result = optionCache?.get selectValue)?
      console.log "use result: #{JSON.stringify result}"
      setSelectOptions [result]
      return
    console.log "[SearchQueryCell]: call method"
    meteorApply
      method: method
      data: search: selectValue
    .then (result) ->
      if result.length is 1
        optionCache?.add result[0]
      unless result.length
        result = [
          value: value
          text: "#{value} [keine Beschreibung vorhanden]"
        ]
      setSelectOptions result
    .catch console.error

  useEffect ->
    setSearch value
    getSelectOptions value
    return
  , [method, value]

  useEffect ->
    getSelectOptions search
    return
  , [search]

  useEffect ->
    measure?()
    return
  , [selectOptions]

  handleSearchChange = (e, d) -> setSearch d.searchQuery
  handleChange = (e, d) ->
    onChange d.value

  <Dropdown
    style={{ minWidth: '12rem' }}
    placeholder={placeholder}
    search
    selection
    fluid
    options={selectOptions}
    onSearchChange={handleSearchChange}
    value={value}
    onChange={handleChange}
  />


