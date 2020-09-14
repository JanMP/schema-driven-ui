import React, {useEffect} from 'react'
import meteorApply from '../../helpers/meteorApply'
import AutoForm from '../uniforms-react/AutoForm'
import AutoField from '../uniforms-react/AutoField'
import DynamicField from '../parts/DynamicField'

#use our uniforms DynamicField in AutoTable
export default DynamicTableField = ({row, columnKey, schema, onChangeField}) ->


  onChange = (d) ->
    onChangeField
      _id: row?._id ? row?.id
      changeData: "#{columnKey}": d

  <DynamicField
    key={"#{row?._id}#{columnKey}"}
    schema={schema}
    fieldName={columnKey}
    label={false}
    value={row[columnKey]}
    onChange={onChange}
    validate="onChange"
  />
