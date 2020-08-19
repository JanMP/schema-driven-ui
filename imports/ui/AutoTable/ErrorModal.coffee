import React from 'react'
import {Button, Header, Icon, Modal} from 'semantic-ui-react'

export default ErrorModal = ({icon = 'ban', text = 'Wrong!', open, onClose}) ->
  <Modal
    open={open}
    onClose={onClose}
  >
  
    <Header icon as="h1">
      <Icon name={icon} color='red'/>
      {text}
    </Header>
 
    <Modal.Actions>
      <Button
        content="😢Och..."
        onClick={onClose}
      />
    </Modal.Actions>
  </Modal>
