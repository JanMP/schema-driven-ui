import {Meteor} from 'meteor/meteor'
import {Accounts} from 'meteor/accounts-base'
import SimpleSchema from 'simpl-schema'
import React, {Fragment, useState} from 'react'
# import { withRouter } from 'react-router-dom'
import { Button, Dimmer, Dropdown, Form, Header, Icon, Menu, Message, Modal } from 'semantic-ui-react'
import withCurrentUser from '../parts/withCurrentUser'
import FormModal from '../AutoTable/FormModal'
import ErrorModal from '../AutoTable/ErrorModal'

export default withCurrentUser ({currentUser}) ->

  [signupModalOpen, setSignupModalOpen] = useState false
  [loginModalOpen, setLoginModalOpen] = useState false
  [errorModalOpen, setErrorModalOpen] = useState false
  [errorMsg, setErrorMsg] = useState 'Everything will be fine.'
  [dimmerActive, setDimmerActive] = useState false

  callback = ({mode}) ->
    (error, result) ->
      setDimmerActive false
      if error
        setErrorMsg error.message
        setErrorModalOpen true
      else
        switch mode
          when 'signup' then setSignupModalOpen false
          else setLoginModalOpen false

  signup = ({username, email, password}) ->
    setDimmerActive true
    setSignupModalOpen false
    Accounts.createUser {username, email, password}, callback mode: 'signup'

  login = ({email, password}) ->
    setDimmerActive true
    setLoginModalOpen false
    Meteor.loginWithPassword email, password, callback mode: 'login'

  loginSchema = new SimpleSchema
    email:
      type: String
      label: 'E-Mail'
    password:
      type: String
      label: 'Passwort'
      uniforms:
        type: 'password'

  signupSchema = new SimpleSchema
    email:
      type: String
      label: 'E-Mail'
      regEx: SimpleSchema.RegEx.EmailWithTLD
    username:
      type: String
      label: 'Benutzername'
      min: 3
      max: 80
    password:
      type: String
      label: 'Passwort'
      uniforms:
        type: 'password'
      regEx: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$/
      max: 80
    passwordRepeat:
      type: String
      label: 'Passwort wdh.'
      custom: ->
        'passwordRepeat misatch' unless @value is @field('password').value
      uniforms:
        type: 'password'

  <Fragment>
    <Menu.Menu position='right'>
      <Dropdown item text={if currentUser? then currentUser.username else 'Login'}>
        <Dropdown.Menu>
          {
            if currentUser?
              <Dropdown.Item text='Logout' onClick={-> Meteor.logout()}/>
            else
              <Fragment>
                <Dropdown.Item text='Login' onClick={-> setLoginModalOpen true}/>
                <Dropdown.Item text='Als neuer Benutzer eintragen' onClick={-> setSignupModalOpen true}/>
              </Fragment>
          }
        </Dropdown.Menu>
      </Dropdown>
    </Menu.Menu>

    <Dimmer active={dimmerActive} page>
      <Header as='h2' icon inverted>
        <Icon name='sign-in' />
        Anmeldung läuft...
      </Header>
    </Dimmer>

    <FormModal
      header={'Als neuer Benutzer eintragen'}
      open={signupModalOpen}
      onClose={-> setSignupModalOpen false}
      schema={signupSchema}
      onSubmit={signup}
    />

    <FormModal
      header={'Login'}
      open={loginModalOpen}
      onClose={-> setLoginModalOpen false}
      schema={loginSchema}
      onSubmit={login}
    />

    <ErrorModal
      text={errorMsg}
      open={errorModalOpen}
      onClose={-> setErrorModalOpen false}
    />
  </Fragment>
