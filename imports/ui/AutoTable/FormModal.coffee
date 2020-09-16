import React from 'react'

import AutoForm from '../uniforms-react/AutoForm'
import AutoField from '../uniforms-react/AutoField'

import { Modal } from 'semantic-ui-react'

export default FormModal = ({trigger, schemaBridge, onSubmit, model, open, onClose, header, children, disabled = false, readOnly = false}) ->
  <Modal trigger={trigger} open={open} onClose={onClose} dimmer='blurring'>
    {if header? then <Modal.Header> {header} </Modal.Header>}
    <Modal.Content style={padding: '3rem'}>
      <AutoForm schema={schemaBridge} onSubmit={onSubmit} model={model} children={children} disabled={disabled} readOnly={readOnly}/>
    </Modal.Content>
  </Modal>
