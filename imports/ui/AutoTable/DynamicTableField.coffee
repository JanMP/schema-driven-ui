import React, {useEffect} from 'react'
import meteorApply from '/imports/helpers/meteorApply'
import AutoForm from '/imports/ui/uniforms-react/AutoFormWrapper'
import AutoField from '/imports/ui/uniforms-react/CustomAutoField'
import DynamicField from '/imports/ui/parts/DynamicField'

#use our uniforms DynamicField in AutoTable
export default DynamicTableField = ({row, columnKey, schema}) ->

  unless (methodName = schema._schema[columnKey]?.AutoTable?.method)?
    return null

  onChange = (d) ->
    meteorApply
      method: methodName
      data: {row..., "#{columnKey}": d}
    .catch console.error


  <DynamicField
    schema={schema}
    fieldName={columnKey}
    label={false}
    value={row[columnKey]}
    onChange={onChange}
  />
