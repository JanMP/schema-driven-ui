import { Meteor } from 'meteor/meteor'
import { withTracker } from 'meteor/react-meteor-data'

export default withCurrentUser =
  withTracker (props) -> currentUser: Meteor.user()
