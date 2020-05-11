###
  thenable Papa Parse for $21-file
###
import {Meteor} from 'meteor/meteor'
import {Faelle, Fall, Icd, Ops, Fab} from '/imports/api/Faelle'
import _ from 'lodash'
import Papa from 'papaparse'

collections = {Fall, Icd, Ops, Fab}

export default papaParseFile = ({file, folder, batchId, windowsEncoded}) -> #returns promise
  
  collection = collections[_.capitalize file.name.split('.')[0]]

  transform = (value, headerName) ->
    return null unless value?
    if headerName is 'Entlassungsgrund'
      if value.length is 2 then value = "0#{value}"
    if headerName is 'Aufnahmegrund'
      if value.length is 3 then value = "0#{value}"
    if collection.schema._schema[headerName]?.type.singleType in [Number, 'SimpleSchema.Integer']
      Number value
    else
      value

  config =
    header: true
    dynamicTyping: false
    skipEmptyLines: true
    transform: transform
    encoding: if windowsEncoded then 'ISO-8859-1'

  new Promise (resolve, reject) ->
    complete =  ({data, errors, meta}) ->
      if errors.length then reject(errors) else resolve(data)
    config = {(config ? {})..., transform, complete}
    Papa.parse file, config
  .then (parsedRows) ->
    parsedRows.map (row) -> {row..., {folder: folder, batchId: batchId}...}