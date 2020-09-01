import {Meteor} from 'meteor/meteor'
import React, {Fragment} from 'react'
import {Message} from 'semantic-ui-react'

export default class ErrorBoundary extends React.Component
  constructor: (props) ->
    super props
    @state =
      hasError: false
      error: "Everything is OK"

  componentDidCatch: (error, info) ->
    @setState {hasError: true, error}
    console.log 'Caught by ErrorBoundary:', error

  render: ->
    if @state.hasError
      <Message negative>
        <Message.Header>Es ist ein Problem aufgetreten:</Message.Header>
        <code>{@state.error?.message}</code>
      </Message>
    else
      @props.children
