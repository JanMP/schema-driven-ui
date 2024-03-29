import React, {useState} from 'react'
import {Button, Header, Icon, Modal, Popup} from 'semantic-ui-react'
import meteorApply from '../../helpers/meteorApply'
import {toast} from 'react-toastify'
import _ from 'lodash'

export default MeteorMethodButton = ({method, data, options, handler, label, icon
onSuccess, successMsg, onError, errorMsg, style, disabled, primary, secondary, basic,
color, fluid, size, confirmation, tooltip}) ->
  
  unless method? or handler?
    throw new Error 'MeteorMethodButton requires a method prop or handler prop'

  if method? and handler?
    throw new Error 'MeteorMethodButton may only have either one of method or handler props'
  
  label ?= unless icon? then "run #{method}"
  data ?= {}
  options ?= {}

  onSuccess ?= (result) -> if successMsg? then toast.success successMsg
  onError ?= (error) -> toast.error "#{errorMsg ? error}"

  [loading, setLoading] = useState false
  [modalOpen, setModalOpen] = useState false

  doIt = ->
    setModalOpen false
    setLoading true
    (
      if handler?
        new Promise (resolve) -> resolve handler()
      else
        meteorApply {method, data, options}
    )
    .then (result) ->
      onSuccess result
      setLoading false
    .catch (error) ->
      onError error
      setLoading false
  
  handleClick = (e) ->
    e.stopPropagation()
    if confirmation?
      setModalOpen true
    else
      doIt()

  popupStyle = if disabled then color: 'red' else {}

  Tooltip = ->
    <Popup
      content={tooltip ? 'fnord'}
      disabled={not tooltip?}
      style={popupStyle}
      trigger={
        <span>
          <Button
            style={style}
            onClick={handleClick}
            loading={loading}
            disabled={disabled}
            primary={primary}
            secondary={secondary}
            basic={basic}
            color={color}
            fluid={fluid}
            icon={icon}
            size={size}
            content={label}
          />
        </span>
      }
    />

  ConfirmationModal = ->
    <Modal
      trigger={<Tooltip/>}
      open={modalOpen}
      onClose={-> setModalOpen false}
    >
      <Modal.Content>
        <p>{confirmation ? 'fnord'}</p>
      </Modal.Content>
      <Modal.Actions>
        <Button color="red" onClick={-> setModalOpen false} >
          <Icon name="times"/> Abbrechen
        </Button>
        <Button color="green" onClick={doIt} >
          <Icon name="checkmark"/> OK
        </Button>
      </Modal.Actions>
    </Modal>


  if confirmation?
    <ConfirmationModal />
  else
    <Tooltip />
