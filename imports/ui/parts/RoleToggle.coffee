import React from 'react'
import {connectField} from 'uniforms'
import {Checkbox} from 'semantic-ui-react'
import {useTracker} from 'meteor/react-meteor-data'
import {Roles} from 'meteor/alanning:roles'
import {maySetRole} from '/imports/api/setRole'
import roleDefinitions from '/imports/api/roleDefinitions'
import _ from 'lodash'


export default RoleToggle = connectField ({value, label, onChange}) ->

  {isInRole, disabled, hidden} = value

  handleChange = -> onChange {isInRole: not isInRole, disabled, hidden}

  if hidden
    return null

 
  <div>
    <Checkbox
      checked={isInRole}
      label={label}
      onChange={handleChange}
      disabled={disabled}
    />
  </div>

