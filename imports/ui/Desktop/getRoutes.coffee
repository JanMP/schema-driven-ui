import React, {useState, useEffect} from 'react'
import {useCurrentUserIsInRole} from '../../helpers/roleChecks'
import {Message} from 'semantic-ui-react'
import AccessDenied from './AccessDenied'

export default getRoutes = ({menuDefinitions}) ->
  
  menuDefinitions.map (route) ->
    routePermitted =
      if route.role?
        useCurrentUserIsInRole route.role
      else
        true
    component =
      if routePermitted
        route.component
      else
        -> <AccessDenied requiredRole={route.role} />
    #return
    label: route.label
    path: route.path
    showInMenu: (not route.showInMenu? or route.showInMenu) and (route.label? or route.path?) and (routePermitted or not route.hideIfDisabled)
    disabled:  not routePermitted
    exactPath: route.exactPath ? true
    component:  component ? -> <Message negative> No Component </Message>
    icon: route.icon
    customMenuItemContent: route.customMenuItemContent
    openInNewWindow: route.openInNewWindow ? false
    windowSize: route.windowSize
