import {Meteor} from 'meteor/meteor'

import React, {useState, useEffect} from 'react'
import styled from 'styled-components'

import {BrowserRouter as Router, Route, Switch, NavLink} from 'react-router-dom'
import {Menu, Container, Icon, Message} from 'semantic-ui-react'

import {ToastContainer} from 'react-toastify'
import getRoutes from './getRoutes'

import AccountsMenuItem from './AccountsMenuItem'
import DevWarning from './DevWarning'


export default Desktop = ->

  routes =  getRoutes()

  unless routes?
    throw new Error 'AppRouter: no itmes prop'

  handleClick = (item) ->
    if item.openInNewWindow and not item.disabled
      -> window.open item.path, 'fnord', (item.windowSize ? "width=640, height=480")
    else ->

  menuItems =
    routes
    .filter (item) -> item.showInMenu
    .map (item, index) ->
      <Menu.Item
        key={index}
        as={NavLink}
        to={if item.disabled or item.openInNewWindow then {} else item.path}
        activeClassName="active"
        disabled={item.disabled}
        onClick={handleClick item}
      >
        {
          if item.customMenuItemContent?
            item.customMenuItemContent {item}
          else
            <>
              {
                if item.icon?
                  <Icon
                    name={item.icon.name ? ''}
                    color={item.icon.color ? 'black'}
                    disabled={item.disabled}
                  />
                
              }
              {item.label ? ""}
            </>
        }
      </Menu.Item>

  routesList =
    routes
    .filter (route) -> route.path?
    .map (route, index) ->
      <Route key={index} path={route.path} exact={route.exactPath} component={route.component}/>

  <>
    <div className="menu-container">
      <Menu>
      {menuItems }
      <AccountsMenuItem />
    </Menu>
    </div>
    <div className="content-container">
      <DevWarning />
      <Switch>
        {routesList }
      </Switch>
    </div>
    <div className="footer-container">
    </div>
    <ToastContainer
      autoClose={5000}
      hideProgressBar
      pauseOnVisibilityChange
    />
  </>
