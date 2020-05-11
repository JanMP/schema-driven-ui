import {Meteor} from 'meteor/meteor'
import React, {Fragment} from 'react'
import {Button, Segment} from 'semantic-ui-react'

export default class ErrorBoundary extends React.Component
  constructor: (props) ->
    super props
    @state = hasError: false

  componentDidCatch: (error, info) ->
    @setState hasError: true
    # console.log 'Caught by ErrorBoundary:', error

  resetEditor: ->
    Meteor.call 'ruleEditorWorkspace.openFresh', -> location.reload()

  render: ->
    if @state.hasError
      null
    else
      @props.children
