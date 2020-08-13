import React, {useEffect} from 'react'
import meteorApply from '../../helpers/meteorApply'
import AutoForm from '../uniforms-react/AutoFormWrapper'
import AutoField from '../uniforms-react/CustomAutoField'
import DynamicField from '../parts/DynamicField'

#use our uniforms DynamicField in AutoTable
export default DynamicTableField = ({row, columnKey, schema, onChangeField}) ->


  onChange = (d) ->
    onChangeField
      _id: row?._id ? row?.id
      modifier: "#{columnKey}": d

  <DynamicField
    key={"#{row?._id}#{columnKey}"}
    schema={schema}
    fieldName={columnKey}
    label={false}
    value={row[columnKey]}
    onChange={onChange}
    validate="onChange"
  />
