import React from 'react'
import {Header, Icon, Modal} from 'semantic-ui-react'

export default ErrorModal = ({icon = 'ban', text = 'Wrong!', open, onClose}) ->
  <Modal
    basic
    open={open}
    onClose={onClose}
  >
    <Header icon as='h1'>
      <Icon name={icon} color='red'/>
      {text}
    </Header>
  </Modal>
