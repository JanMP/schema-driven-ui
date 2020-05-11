import React from 'react'
import {Container, Header, Icon, Label, Segment} from 'semantic-ui-react'

export default AccessDenied = ({requiredRole}) ->

  <Container>
    <Segment size='huge' textAlign='center'>
      <Header as='h1' icon>
        <Icon name='ban' color='red'/>
        Kein Zugang
        <Header.Subheader>
          Benötigte Zugangsberechtigung: <Label color='red'>{requiredRole}</Label>
        </Header.Subheader>
      </Header>
    </Segment>
  </Container>
