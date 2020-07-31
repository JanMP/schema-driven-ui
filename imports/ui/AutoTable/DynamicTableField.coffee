import React, {useEffect} from 'react'
import meteorApply from '../../helpers/meteorApply'
import AutoForm from '../uniforms-react/AutoFormWrapper'
import AutoField from '../uniforms-react/CustomAutoField'
import DynamicField from '../parts/DynamicField'

#use our uniforms DynamicField in AutoTable
export default DynamicTableField = ({row, columnKey, schema}) ->

  unless (methodName = schema._schema[columnKey]?.AutoTable?.method)?
    return null

  onChange = (d) ->
    meteorApply
      method: methodName
      data:
        _id: row?._id
        modifier: "#{columnKey}": d
    .catch console.error


  <DynamicField
    key={"#{row?._id}#{columnKey}"}
    schema={schema}
    fieldName={columnKey}
    label={false}
    value={row[columnKey]}
    onChange={onChange}
  />
