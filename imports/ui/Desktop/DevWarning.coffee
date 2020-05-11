import React from 'react'
import {Container, Header, Icon, Label, Segment} from 'semantic-ui-react'
import {useCurrentUserIsInRole} from '/imports/api/roleChecks'

export default DevWarning = ->
  return null if Meteor.isProduction or useCurrentUserIsInRole 'dev_view'

  <Container style={marginBottom: '1rem'}>
    <Segment textAlign="center" color='red' inverted>
      <Header as='h1'>App läuft im Development Mode</Header>
      <div style={lineHeight: '10rem', fontSize: '10rem'}>🚧</div>
      <Header as='h2'>Ich arbeite gerade direkt am Server. Dementsprechend funktioniert solange nicht unbedingt immer alles so, wie es sollte.</Header>
    </Segment>
  </Container>

  
