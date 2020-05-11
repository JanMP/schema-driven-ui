import React from 'react'
import {connectField} from 'uniforms'
import {useTracker} from 'meteor/react-meteor-data'
import {Roles} from 'meteor/alanning:roles'
import {Dropdown} from 'semantic-ui-react'
import {levelsWithLabels, maySetLevel} from '/imports/api/setRole'
import roleDefinitions from '/imports/api/roleDefinitions'
import _ from 'lodash'

export default UserLevelToggle = connectField ({value, label, onChange}) ->

  {levelId, options} = value

  handleChange = (e, d) -> onChange {options, levelId: d.value}

  <div>
   <Dropdown
      value={levelId}
      options={options}
      onChange={handleChange}
      selection
   />
  </div>