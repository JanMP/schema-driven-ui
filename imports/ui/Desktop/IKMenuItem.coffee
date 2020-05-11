import React, {useState} from 'react'
import {Dropdown, Menu} from 'semantic-ui-react'
import {useTracker} from 'meteor/react-meteor-data'
import {SelectedIK} from '/imports/api/SelectedIK'
import meteorApply from '/imports/helpers/meteorApply'

IKs = new Mongo.Collection 'IKs'

textForIK = ({ik}) ->
  if ik? then "IK: #{ik}" else "Alle IK"


export default IKMenuItem = ->

  setSelected = ({ik}) ->
    meteorApply
      method: 'selectedIK.set'
      data: {ik}

  selected = useTracker -> SelectedIK.findOne(userId: Meteor.userId())?.ik
    
  menuItems = useTracker ->
    iks = IKs.find().map (doc) -> doc._id
    [undefined, iks...].map (ik) ->
      <Dropdown.Item active={ik is selected} key={ik ? 'null'} text={textForIK {ik}} onClick={-> setSelected {ik}} />


  <Menu.Menu position='right'>
    <Dropdown item text={textForIK ik: selected}>
      <Dropdown.Menu children={menuItems} />
    </Dropdown>
  </Menu.Menu>