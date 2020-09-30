import {Meteor} from 'meteor/meteor'
import { ReactiveAggregate } from 'meteor/tunguska:reactive-aggregate'
import {userWithIdIsInRole} from '../../helpers/roleChecks'

export default publishTableData = ({viewTableRole, sourceName, collection,
getRowsPipeline, getRowCountPipeline})  ->
  if Meteor.isServer
  
    unless collection?
      throw new Error 'no collection given'

    Meteor.publish "#{sourceName}.rows", ({search, query, sort, limit, skip}) ->
      return @ready() unless userWithIdIsInRole id: @userId, role: viewTableRole
      @autorun (computation) ->
        pipeline = getRowsPipeline {pub: this, search, query, sort, limit, skip}
        ReactiveAggregate this, collection,
          pipeline,
          clientCollection: "#{sourceName}.rows"
          debounceCount: Infinity
          debounceDelay: 500
   
    Meteor.publish "#{sourceName}.count", ({search, query = {}}) ->
      return @ready() unless userWithIdIsInRole id: @userId, role: viewTableRole
      pipeline = getRowCountPipeline {pub: this, search , query}
      @autorun (computation) ->
        ReactiveAggregate this, collection,
          pipeline,
          clientCollection: "#{sourceName}.count"
          dbounceDelay: 500
