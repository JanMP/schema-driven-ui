import React, {useState, useEffect, useRef} from 'react'
import {Button, Grid, Header, Segment} from 'semantic-ui-react'
import AutoForm from '/imports/ui/uniforms-react/AutoFormWrapper'
import AutoField from '/imports/ui/uniforms-react/CustomAutoField'
import hash from 'object-hash'
import getSchemaLabels from '/imports/helpers/getSchemaLabels'
import _ from 'lodash'

commonRowStyle =
  display: 'flex'
  alignItems: 'center'

headerOnlyRowStyle =
  fontSize: '12px'
  display: 'flex'
  width: '100%'
  paddingRight: '14px'
  paddingLeft: '14px'

commonColumnStyle =
  marginRight: '1rem'

export default ScrollingFormList = ({
  schema, models, onChange,
  rowTemplate, headerTemplate, templateDefinition
  title, canAdd, canDelete, addModel = {}, fieldsToOmitInRowKey = []
}) ->

  if templateDefinition? and (rowTemplate? or headerTemplate?)
    console.warn 'if templateDefinition is given, rowTemplate and headerTemplate will be overwritten'

  hasTitleHeader = title? or canAdd?

  if templateDefinition?
    labels = getSchemaLabels schema: schema

    headerTemplate ?=
    <div style={display: 'flex'}>
      <div style={{commonRowStyle..., headerOnlyRowStyle...}}>
        {
          templateDefinition.map (column) ->
            <div key={column.name} style={{commonColumnStyle..., column.style...}}>
              <span>{labels[column.name]}</span>
            </div>
        }
      </div>
      {
        if canDelete
          <Button basic icon="trash" style={visibility: 'hidden', marginRight: '1.9rem'}/>
        else
          null
      }
    </div>

    rowTemplate ?=
    <div style={{commonRowStyle...}}>
      {
        templateDefinition.map (column) ->
          <div key={column.name} style={{commonColumnStyle..., column.style...}}>
            <AutoField label={null} name={column.name}></AutoField>
          </div>
      }
    </div>

  [show, setShow] = useState true
  toggle = -> setShow not show

  myModels = _.cloneDeep models

  onValidate = (index) -> (model, error, callback) ->
    unless _.isEqual myModels[index], model
      myModels.splice index, 1, {myModels[index]..., model...}
      onChange myModels
    callback()

  onDelete = (index) -> ->
    myModels.splice index, 1
    onChange myModels

  onAdd = (e) ->
    e.stopPropagation()
    if canAdd
      onChange [myModels..., addModel]

  headerClassName = "label-header#{if canDelete then ' can-delete' else ''}"

  containerStyle =
    boxShadow: '0px 6px 8px rgba(2,27,59,0.08)'
    display: 'flex', flexDirection: 'column'
    flex: if show then "1 1" else "0 1"


  <div
    className="scrolling-form-list"
    style={containerStyle}
  >
    {
      if hasTitleHeader
        <Header
          as='h3' attached='top'
          style={flex: "0 0", userSelect: 'none', cursor: 'ns-resize'}
          onClick={toggle}
        >
          <div style={display: 'flex', justifyContent: 'space-between' }>
            <span>{title}</span>
            {
              if canAdd
                <Button
                  icon='plus' secondary
                  style={marginRight: '1rem'}
                  onClick={onAdd}
                  disabled={not show}
                />
            }
          </div>
        </Header>
    }
    {
      if show
        <>
        <div
        className={headerClassName}
        children={headerTemplate}
        style={backgroundColor: 'white', fontWeight: 'bold'}
        />
        <Segment style={overflowY: 'scroll', flex: "1 1 210px", borderTop: 'none'} attached={hasTitleHeader} >
          {
            models.map (model, index) ->
              <div style={
                    display: 'flex'
                    justifyContent: 'space-between'
                    alignItems: 'flex-start'
                    marginBottom: '1rem'
                  }
                   key={hash _.omit model, fieldsToOmitInRowKey}
              >
                <AutoForm
                  style={flexGrow: 1}
                  schema={schema}
                  model={model}
                  onValidate={onValidate index}
                  children={rowTemplate}
                  autosave={true}
                  submitField={-> null}
                  validate="onChange"
                />
                {
                  if canDelete
                    <Button
                      icon='trash'
                      color='red'
                      basic
                      onClick={onDelete index}
                      style={
                          display: 'flex'
                          alignSelf: 'center'
                        }
                    />
                }
              </div>
          }
        </Segment>
        </>
    }
  </div>
