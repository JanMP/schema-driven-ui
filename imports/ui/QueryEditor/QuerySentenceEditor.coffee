import React, { useRef, useEffect } from 'react'
import AutoForm from '../uniforms-react/AutoForm'
import AutoField from '../uniforms-react/AutoField'
import {SimpleSchema2Bridge as Bridge} from 'uniforms-bridge-simple-schema-2'
import DynamicField from '../parts/DynamicField'
import CodeListenSelect from '../parts/SearchQueryField'

import SimpleSchema from 'simpl-schema'
import { Button, Form, Icon, Input, Select } from 'semantic-ui-react'
import { getSubjectSelectOptions } from './subjects'
import { predicateSelectOptions } from './predicates'
import PartIndex from './PartIndex'
import _ from 'lodash'

import '../../helpers/simpleSchemaExtension.coffee.md'

Nothing = -> <span />

regexSchema =
  new SimpleSchema
    object:
      type: String

defaultListSchema =
  new SimpleSchema
    object:
      type: String
      uniforms:
        component: -> <span>keine Liste</span>

isList = (predicate) -> predicate in ['$in', '$nin']
isRegex = (predicate) -> predicate is '$regex'
isOther = (predicate) -> not ((isList predicate) or isRegex predicate)

shouldDeleteObject = ({oldPredicate, newPredicate}) ->
  both = (isSomething) -> (isSomething oldPredicate) and isSomething newPredicate
  not ((both isList) or (both isOther) or ((isOther oldPredicate) and isRegex newPredicate))


export default QuerySentenceEditor = React.memo ({rule, partIndex, bridge, path, onChange, onRemove}) ->
    
  subjectSelectOptions = getSubjectSelectOptions {bridge, path}
  haveContext = subjectSelectOptions.length > 0
  subjectFitsContext =
    _.some subjectSelectOptions, value: rule.content.subject?.value
  canDisplay = haveContext and subjectFitsContext

  # if we can't display anything usefull we just get ourselves erased
  useEffect ->
    unless canDisplay
      onRemove()
    return
  , [canDisplay]

  pathWithName = (name) -> if path then "#{path}.#{name}" else name

  returnRule = (mutateClone) ->
    clone = _(rule).cloneDeep()
    mutateClone clone
    onChange clone

  selectOptionsForValue = (d) -> _(d.options).find value: d.value

  changeSubject = (e, d) ->
    returnRule (r) ->
      r.content.object.value = null
      r.content.subject = selectOptionsForValue d

  changePredicate = (e, d) ->
    returnRule (r) ->
      r.content.predicate = selectOptionsForValue d
      if shouldDeleteObject oldPredicate: predicate,  newPredicate: d.value
        r.content.object.value = null

  changeObject = (d) ->
    returnRule (r) -> r.content.object.value = d

  # set up AutoForm to handle the object field, which depends on
  # both subject and predicate
  subject = rule.content.subject?.value
  object = rule.content.object?.value ? ''
  predicate = rule.content.predicate?.value


  objectSchema = # TODO check if removing the workaround is viable
    if path
      try
        bridge.schema.getObjectSchema(path).pick subject
      catch error
        console.log 'error on calling getObjectSchema'
        bridge.schema.pick subject
    else bridge.schema.pick subject

  switch predicate
    when '$regex'
      objectPath = 'object'
      autoFormSchema = regexSchema
    when '$in', '$nin'
      objectPath = 'object'
      autoFormSchema =
        if (inListField = objectSchema?._schema?[subject]?.QueryEditor?.inListField)?
          new SimpleSchema object: inListField
        else defaultListSchema
    else
      objectPath = subject
      autoFormSchema = objectSchema
  
  autoFormSchemaBridge = new Bridge autoFormSchema
        
  # check if our subject value fits our context
  # and set it to the first select option if it doesn't
  useEffect ->
    if haveContext and not subjectFitsContext
      subjectObject = subjectSelectOptions[0]
      returnRule (r) ->
        r.content.subject = subjectObject
        r.content.object.value = null
    return
  , [subjectFitsContext]

  SentenceForm =
    <div style={display: 'flex'}>
      <div>
        <Form className="inline" style={display: 'flex'}>
          <Form.Field>
            <Select
              value={subject}
              options={subjectSelectOptions}
              onChange={changeSubject}
              style={minWidth: '12em'}
            />
          </Form.Field>
          <Form.Field>
            <Select
              value={rule.content.predicate?.value}
              options={predicateSelectOptions}
              onChange={changePredicate}
              style={minWidth: '5em'}
            />
          </Form.Field>
        </Form>
      </div>
      <div>
        <DynamicField
          schemaBridge={autoFormSchemaBridge}
          fieldName={objectPath}
          label={false}
          value={object}
          onChange={changeObject}
          mayEdit={true}
        />
      </div>
    </div>


  <div className="query-sentence" style={display: 'flex', justifyContent: 'space-between'}>
    {if canDisplay then SentenceForm}
    <div style={flexGrow: 0, flexShrink: 1, marginLeft: '1rem'}>
      <Button color="red" basic icon="trash" onClick={onRemove}/>
    </div>
  </div>
