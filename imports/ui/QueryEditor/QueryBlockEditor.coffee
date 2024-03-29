import React, {useState, useEffect} from 'react'
import QuerySentenceEditor from './QuerySentenceEditor'
import { getConjunctionData, getConjunctionSelectOptions } from './conjunctions'
import { Button, Icon, Select } from 'semantic-ui-react'
import {getNewSentence, getNewBlock} from './queryEditorHelpers'
import _ from 'lodash'
import PartIndex from './PartIndex'


export default QueryBlockEditor = React.memo ({rule, partIndex, bridge, path, onChange, onRemove, onMove, isRoot}) ->
  
  isRoot ?= false
  partIndex ?= ''
 
  # data handling
  myContext = rule.conjunction?.context
  isBlock = rule.type in ['contextBlock', 'logicBlock']

  conjunctionData = getConjunctionData {bridge, path, type: rule.type}
  conjunctionSelectOptions = getConjunctionSelectOptions {bridge, path, type: rule.type}

  cantGetInnerPathType = false

  conjunction = rule?.conjunction?.value ? null
  
  [blockTypeClass, setBlockTypeClass] = useState ''

  useEffect ->
    c =
      switch conjunction
        when '$and' then 'and'
        when '$or' then 'or'
        when '$nor' then 'nor'
        else
          'folder'
    setBlockTypeClass c
    return
  , [conjunction]

  innerPath = switch
    when myContext? and path then "#{path}.#{myContext}"
    when myContext? then myContext
    else path

  # if we can't get a type for innerPath that means there is something wrong with this branch of the rule
  # (most likely because the subdocument was changed above) so we just saw this branch off
  try
    if path and (bridge.getType innerPath) is Array
      innerPath = "#{innerPath}.$"
  catch
    cantGetInnerPathType = true

  useEffect ->
    if cantGetInnerPathType then onRemove()
    return
  , [cantGetInnerPathType]

  childHasContextConjunctionSelectOptions =
    getConjunctionData({bridge, path: innerPath, type: 'contextBlock'}).length > 0

  childWouldHaveSubject = getNewSentence({bridge, path: innerPath}).content.subject?
 
  returnRule = (mutateClone) ->
    clone = _(rule).cloneDeep()
    mutateClone clone
    onChange _(clone).cloneDeep()

  selectValueObject = (d) ->
    _(conjunctionData).find value: d.value

  changeConjunction = (e, d) -> returnRule (r) -> r.conjunction = selectValueObject d

  changePart = (index) -> (d) -> returnRule (r) -> r.content[index] = d

  removePart = (index) -> -> returnRule (r) -> r.content.splice index, 1

  addLogicBlock = -> returnRule (r) -> r.content.push getNewBlock {bridge, path: innerPath, type: 'logicBlock'}

  addContextBlock = -> returnRule (r) -> r.content.push getNewBlock {bridge, path: innerPath, type: 'contextBlock'}

  addSentence = -> returnRule (r) -> r.content.push getNewSentence {bridge, path: innerPath}

  addPart = (index) -> (d) -> returnRule (r) -> r.content.splice index, 0, d

  #drag and drop
  acceptDrop = (monitor) ->
    not partIndex.isDescendantOf monitor.getItem().partIndex

  atTop =
    isBlock and rule.content.length > 0

  mainStyle = {}
  showTop = false
  showBottom = false

  if isBlock
    children = rule.content.map (part, index) ->
      <div key={index}>
        <QueryBlockEditor
          rule={part}
          partIndex={partIndex.addLeaf index}
          bridge={bridge}
          path={innerPath}
          onChange={changePart index}
          onRemove={removePart index}
          onMove={onMove}
        />
      </div>


  if isBlock
    <>
      <div className={"query-block #{blockTypeClass}"}>
        <div className="block-header"
          style={
            display: 'flex'
            justifyContent: 'space-between'
          }
        >
          <div>
            <Select
              value={conjunction}
              options={conjunctionSelectOptions}
              onChange={changeConjunction}
            />
          </div>
          <div>
            <Button
              circular
              color="green"
              icon="filter"
              onClick={addLogicBlock}
            />
            <Button
              circular
              color="blue"
              icon="folder"
              onClick={addContextBlock}
              disabled={not childHasContextConjunctionSelectOptions}
            />
            <Button
              circular
              secondary
              icon="file"
              onClick={addSentence}
              disabled={not childWouldHaveSubject}
            />
            {<Button color="red" basic icon="trash" style={marginLeft: '5px'} onClick={onRemove}/> unless isRoot}
          </div>
        </div>
        <div>{children}</div>
      </div>
    </>
  else if rule.type is 'sentence'
    <QuerySentenceEditor
      rule={rule}
      partIndex={partIndex}
      bridge={bridge}
      path={innerPath}
      onChange={onChange}
      onRemove={onRemove}
      onMove={onMove}
    />
