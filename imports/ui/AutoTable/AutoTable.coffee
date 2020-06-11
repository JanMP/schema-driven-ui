import React, { useState } from 'react'
import { Button, Grid, Dimmer, Header, Icon, Input, Loader, Modal, Segment, Table } from 'semantic-ui-react'
import AutoTableAutoField from './AutoTableAutoField'
import Pagination from './Pagination'
import ErrorBoundary from './ErrorBoundary'

import _ from 'lodash'

Trigger = ({onClick, disabled}) ->
  <Button
    secondary
    icon="plus"
    onClick={onClick}
    disabled={disabled}
  />

DeleteButton = ({id, onDelete, disabled}) ->
  handleClick = (e) ->
    e.stopPropagation()
    onDelete {id}

  <Button
    basic
    color="red"
    icon="trash"
    onClick={handleClick}
    disabled={disabled}
  />

export default AutoTable = ({
  schema, rows, onRowClick,
  sortColumn, sortDirection, onChangeSort, useSort = false
  activePage, totalPages, onChangePage, usePagination = true
  canSearch, search, onChangeSearch = ->
  canAdd, onAdd = ->
  canDelete, onDelete = ->
  canEdit
  mayEdit
  canExport, onExportTable = ->
  mayExport
  isLoading, loaderContent = null, loaderIndeterminate = false
  title, subTitle, titleIcon
}) ->

  handleSort = (key) -> ->
    newSortDirection =
      if key is sortColumn
        if sortDirection is 'ascending' then 'descending' else 'ascending'
      else
        'ascending'
    newSortColumn = key
    onChangeSort {newSortColumn, newSortDirection}

  columnKeys =
    schema._schemaKeys
    .filter (key) ->
      return false if key.includes?('.') #dont include subschemas as additional columns
      options = schema._schema[key].AutoTable ? {}
      if key in ['id', '_id']
        not (options.hide ? true) # don't include ids by default
      else
        not (options.hide ? false) # include everything else if not hidden

  body =
    rows?.map (row, index) ->
      return unless row?
      <Table.Row
        key={row.id ? row._id ? index}
        onClick={-> onRowClick rowData: row, index: index}
        style={if mayEdit then {cursor: 'pointer'} else {}}
      >
        {
          columnKeys.map (key) ->
            <Table.Cell key={key}>
              <AutoTableAutoField row={row} columnKey={key} schema={schema}/>
            </Table.Cell>
        }
        {
          if canDelete
            <Table.Cell>
              <DeleteButton id={row.id ? row._id} onDelete={onDelete} disabled={not mayEdit}/>
            </Table.Cell>
        }
      </Table.Row>

  headerCells = columnKeys.map (key, index) ->
    <Table.HeaderCell
      key={index}
      sorted={if useSort and key is sortColumn then sortDirection else null}
      onClick={if useSort then handleSort key}
    >
      {schema._schema[key].label}
    </Table.HeaderCell>


  <ErrorBoundary>
    {
      if title?
        <Header as='h3' attached='top'>
          {if titleIcon? then <Icon name={titleIcon}/>}
          <Header.Content>{title}</Header.Content>
          {if subTitle? then <Header.Subheader>{subTitle}</Header.Subheader>}
        </Header>
    }
      <Dimmer inverted active={isLoading}>
        <Loader inverted content={loaderContent} indeterminate={loaderIndeterminate}/>
      </Dimmer>
        <Grid>
          <Grid.Row columns={3} style={marginBottom: '.6rem'}>
            <Grid.Column>
              {
                if usePagination and totalPages > 1
                  <Pagination
                    activePage={activePage}
                    totalPages={totalPages}
                    onPageChange={onChangePage}
                  />
              }
            </Grid.Column>
            <Grid.Column>
              <div style={textAlign: 'center'}>
                {
                  if canSearch
                    <Input
                      value={search}
                      onChange={(e, d) -> onChangeSearch d.value}
                      icon='search'
                    />
                }
              </div>
            </Grid.Column>
            <Grid.Column>
              <div style={textAlign: 'right'}>
                {
                  if canExport
                    <Button icon='download' onClick={onExportTable} disabled={not mayExport}/>
                }
                {if canAdd then <Trigger onClick={onAdd} disabled={not mayEdit}/>}
              </div>
            </Grid.Column>
          </Grid.Row>
        </Grid>
    
      <div style={overflowX: 'auto'}>
        <Table
          striped sortable celled
          selectable={mayEdit}
        >
          <Table.Header><Table.Row>
            {headerCells}
            {if canDelete then <Table.HeaderCell collapsing/>}
          </Table.Row></Table.Header>
          <Table.Body>
            {body}
          </Table.Body>
        </Table>
      </div>
  </ErrorBoundary>
