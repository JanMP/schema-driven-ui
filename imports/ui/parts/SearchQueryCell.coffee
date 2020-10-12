import {Meteor} from 'meteor/meteor'
import meteorApply from '../../helpers/meteorApply'
import React, {useEffect, useState} from 'react'
import connectWithFormField from './connectWithFormField'
import {Dropdown} from 'semantic-ui-react'
import _ from 'lodash'

optionCache =
  do ->
    cacheObj = {}
    
    add: ({value, text}) -> cacheObj = {cacheObj..., "#{value}": text}
    get: (value) -> if cacheObj[value] then {value, text:cacheObj[value]}


export default SearchQueryCell = ({row, columnKey, schemaBridge, onChangeField, measure}) ->

  value = row?[columnKey]

  unless (options = schemaBridge?.schema._schema?[columnKey]?.AutoTable)?
    throw new Error "[SearchQueryCell]: missing AutoTable options in schemaBridge for key: #{columnKey}"

  placeholder = options.placeholder ? 'Bitte auswählen'

  unless (method = options.method)?
    throw new Error "[SearchQueryCell]: AutoTable.method must be supplied in schemaBridge for key: #{columnKey}"
  
  [search, setSearch] = useState value
  [selectOptions, setSelectOptions] = useState []

  getSelectOptions = (selectValue) ->
    return unless selectValue?
    if (result = optionCache?.get selectValue)?
      setSelectOptions [result]
      return
    meteorApply
      method: method
      data: search: selectValue
    .then (result) ->
      unless result.length
        result = [
          value: value
          text: "#{value} [keine Beschreibung vorhanden]"
        ]
      if result.length is 1
        optionCache?.add result[0]
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
    if selectOptions? then measure?()
    return
  , [selectOptions]

  handleSearchChange = (e, d) -> setSearch d.searchQuery
  handleChange = (e, d) ->
    onChangeField _id: row._id, changeData: "#{columnKey}": d.value

  <Dropdown
    style={{ minWidth: '100%' }}
    placeholder={placeholder}
    search
    selection
    fluid
    options={selectOptions}
    onSearchChange={handleSearchChange}
    value={value}
    onChange={handleChange}
  />



