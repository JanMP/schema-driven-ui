import {Roles} from 'meteor/alanning:roles'
import {useTracker} from 'meteor/react-meteor-data'


export currentUserIsInRole = (role) -> Roles.userIsInRole Meteor.userId(), role

#for use in React Components
export useCurrentUserIsInRole = (role) -> useTracker -> currentUserIsInRole role

#throws if not in role, for use in Meteor.method
export currentUserMustBeInRole = (role) ->
  unless currentUserIsInRole role
    throw new Meteor.Error "user must be in role #{role}"