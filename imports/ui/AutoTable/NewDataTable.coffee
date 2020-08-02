import React, {useEffect, useRef} from "react"
import {Button, Grid, Dimmer, Icon, Input, Loader, Modal} from 'semantic-ui-react'
import AutoTableAutoField from "./AutoTableAutoField"
import {
  Column, defaultTableRowRenderer, Table, CellMeasurer, CellMeasurerCache,
  InfiniteLoader
} from 'react-virtualized'
import useSize from '@react-hook/size'
import _ from 'lodash'


newCache = -> new CellMeasurerCache
  fixedWidth: true
  minHeight: 30
  defaultHeight: 200

cellRenderer = ({schema, cache}) ->
  ({dataKey, parent, rowIndex, columnIndex, cellData, rowData}) ->
    options = schema._schema[dataKey].AutoTable ? {}
    cache.clear {rowIndex, columnIndex}
    <CellMeasurer
      cache={cache}
      columnIndex={columnIndex}
      key={dataKey}
      parent={parent}
      rowIndex={rowIndex}
    >
      <AutoTableAutoField row={rowData} columnKey={dataKey} schema={schema} />
    </CellMeasurer>

deleteButtonCellRenderer = ({onDelete = ->}) ->
  ({dataKey, parent, rowIndex, columnIndex, cellData, rowData}) ->

    onClick = (e) ->
      e.stopPropagation()
      e.nativeEvent.stopImmediatePropagation()
      if (id = rowData?._id ? rowData?.id)?
        onDelete {id}

    <Button
      circular
      warn
      icon="trash"
      onClick={onClick}
    />

export default NewDataTable = ({
  schema,
  rows, limit, totalRowCount, loadMoreRows
  sortColumn, sortDirection, onChangeSort, useSort
  canSearch, search, onChangeSearch = ->
  isLoading
  canAdd, onAdd = ->
  canDelete, onDelete = ->
  canEdit
  mayEdit
  onRowClick
  canExport, onExportTable = ->
  mayExport
}) ->

  cacheRef = useRef newCache()

  headerContainerRef = useRef null
  [headerContainerWidth, headerContainerHeight] = useSize headerContainerRef

  contentContainerRef = useRef null
  [contentContainerWidth, contentContainerHeight] = useSize contentContainerRef

  tableRef = useRef null
  oldRows = useRef null

  sort = ({defaultSortDirection, sortBy, sortDirection}) ->
    onChangeSort
      sortColumn: sortBy
      sortDirection: sortDirection

  useEffect ->
    cacheRef.current.clearAll()
    tableRef?.current?.forceUpdateGrid?()
  , [contentContainerWidth, contentContainerHeight]

  useEffect ->
    length = rows?.length ? 0
    oldLength = oldRows?.current?.length ? 0
    if length > oldLength
      cacheRef.current.clearAll() unless _.isEqual rows?[0...oldLength], oldRows?.current
    else
      cacheRef.current.clearAll() unless _.isEqual rows, oldRows?.current
    tableRef?.current?.forceUpdateGrid()
    oldRows.current = rows
    return
  , [rows]

  getRow = ({index}) -> rows[index] ? {}
  isRowLoaded = ({index}) -> rows?[index]?

  columns =
    schema._firstLevelSchemaKeys
    .filter (key) ->
      options = schema._schema[key].AutoTable ? {}
      if key in ['id', '_id']
        not (options.hide ? true) # don't include ids by default
      else
        not (options.hide ? false)
    .map (key) ->
      schemaForKey = schema._schema[key]
      options = schemaForKey.AutoTable ? {}
      className = if options.overflow then 'overflow'
      <Column
        className={className}
        key={key}
        dataKey={key}
        label={schemaForKey.label}
        width={200}
        cellRenderer={cellRenderer {schema, cache: cacheRef.current}}
      />


  # useEffect ->
  #   console.log schema
  # , [schema]

  <div ref={contentContainerRef} style={height: '100%'}>
    
    <div ref={headerContainerRef} style={margin: '10px'}>
      <Grid>
        <Grid.Row columns={3}>
          <Grid.Column>
            <Icon loading={isLoading} color={if isLoading then 'red' else 'green'} name="sync" size="large"/>
            {rows?.length}/{totalRowCount}
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
              {
                if canAdd
                  <Button size="small" secondary circular icon="plus" onClick={onAdd} disabled={not mayEdit}/>
              }
            </div>
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </div>
   
      <InfiniteLoader
        isRowLoaded={isRowLoaded}
        loadMoreRows={loadMoreRows}
        rowCount={totalRowCount}
      >
        {({onRowsRendered, registerChild}) ->
          registerChild tableRef
          <Table
            width={contentContainerWidth}
            height={contentContainerHeight - headerContainerHeight - 10}
            headerHeight={30}
            rowHeight={cacheRef.current.rowHeight}
            rowCount={rows?.length}
            rowGetter={getRow}
            onRowsRendered={onRowsRendered}
            ref={tableRef}
            overscanRowCount={10}
            onRowClick={onRowClick}
            sort={sort}
            sortBy={sortColumn}
            sortDirection={sortDirection}
          >
            {columns}
            {if canDelete then <Column
              dataKey="fnord"
              label=""
              width={50}
              cellRenderer={deleteButtonCellRenderer {onDelete}}
            />}
          </Table>
        }
      </InfiniteLoader>
    
  </div>