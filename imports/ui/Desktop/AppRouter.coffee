
import React, {useState, useEffect} from 'react'
import {BrowserRouter as Router, Route, Switch, NavLink } from 'react-router-dom'
import Desktop from './Desktop'
import getRoutes from './getRoutes'


export default AppRouter = ->

  routes = getRoutes()

  routesWithoutDesktop =
    routes
    .filter (route) -> route.openInNewWindow
    .map (route, index) ->
      <Route key={index} path={route.path} exact={route.exactPath} component={route.component}/>

  routesWithDesktop =
    routes
    .filter (route) -> not route.openInNewWindow
    .map (route, index) ->
      <Route key={index} path={route.path} exact={route.exactPath} component={Desktop}/>

  <Router>
    <Switch>
      {routesWithoutDesktop}
      {routesWithDesktop}
      <Route path="*" component={Desktop}/>
    </Switch>
  </Router>