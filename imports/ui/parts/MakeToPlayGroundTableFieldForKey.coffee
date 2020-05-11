import React from 'react'
import {Button, Icon} from 'semantic-ui-react'
import meteorApply from '/imports/helpers/meteorApply'
import {toast} from 'react-toastify'
import { useHistory } from 'react-router-dom'


export default MakeToPlayGroundTableFieldForKey = ({key}) -> ({row, columnKey, schema}) ->

  history = useHistory()
  
  id = row[key]

  unless id?
    throw new Error "[MakeToPlaygroundTableFieldForKey] no id found for key #{key}"


  handleClick = ->
    meteorApply
      method: 'faelle.openInPlaygroundWorkspace'
      data: {id}
    .then -> history.push "/spielplatz/#{id}"
    .catch (error) -> toast.error "#{error}"


  <Button circular icon='child' onClick={handleClick} disabled={not id?} />
