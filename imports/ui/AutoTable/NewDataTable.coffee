import React, {useEffect, useState, useRef} from "react"
import {Button, Grid, Dimmer, Icon, Input, Loader, Modal} from 'semantic-ui-react'
import AutoTableAutoField from "./AutoTableAutoField"
import {
  Column, defaultTableRowRenderer, Table, CellMeasurer, CellMeasurerCache,
  InfiniteLoader
} from 'react-virtualized'
import Draggable from 'react-draggable'
import {useDebounce} from '@react-hook/debounce'
import {useThrottle} from '@react-hook/throttle'
import useSize from '@react-hook/size'
import _ from 'lodash'


newCache = -> new CellMeasurerCache
  fixedWidth: true
  minHeight: 30
  defaultHeight: 200

resizableHeaderRenderer = ({onResizeRows, isLastOne}) ->
  ({columnData, dataKey, disableSort, label, sortBy, sortDirection}) ->
  
    onDrag = (e, {deltaX}) ->
      onResizeRows {dataKey, deltaX}
    
    <React.Fragment key={dataKey}>
      <div className="ReactVirtualized__Table__headerTruncatedText sort-click-target">
        {label}{
          if sortBy is dataKey
            <Icon name={if sortDirection is 'ASC' then 'sort up' else 'sort down'} />
        }
      </div>
      {<Draggable
        axis="x"
        defaultClassName="DragHandle"
        defaultClassNameDragging="DragHandleActive"
        onDrag={onDrag}
        position={x: 0}
        zIndex={999}
      >
        <span/>
      </Draggable> unless isLastOne}
    </React.Fragment>


cellRenderer = ({schemaBridge, onChangeField, cache, mayEdit}) ->
  ({dataKey, parent, rowIndex, columnIndex, cellData, rowData}) ->
    options = schemaBridge.schema._schema[dataKey].AutoTable ? {}
    cache.clear {rowIndex, columnIndex}
    <CellMeasurer
      cache={cache}
      columnIndex={columnIndex}
      key={dataKey}
      parent={parent}
      rowIndex={rowIndex}
    >
      {({measure}) ->
        <AutoTableAutoField
          row={rowData}
          columnKey={dataKey}
          schemaBridge={schemaBridge}
          onChangeField={onChangeField}
          measure={measure}
          mayEdit={mayEdit}
        />}
    </CellMeasurer>


deleteButtonCellRenderer = ({onDelete = ->}) ->
  ({dataKey, parent, rowIndex, columnIndex, cellData, rowData}) ->

    onClick = (e) ->
      e.stopPropagation()
      e.nativeEvent.stopImmediatePropagation()
      if (id = rowData?._id ? rowData?.id)?
        onDelete {id}

    <div style={textAlign: 'right'}>
      <Button
        circular
        basic
        negative
        size="mini"
        icon="trash"
        onClick={onClick}
      />
    </div>


SearchInput = ({value, onChange}) ->

  [isValid, setIsValid] = useState true
  [displayValue, setDisplayValue] = useState value
  [debouncedValue, setDebouncedValue] = useDebounce value, 500

  useEffect ->
    onChange debouncedValue
  , [debouncedValue]
  
  handleSearchChange = (newValue) ->
    try
      new RegExp newValue unless newValue is ''
      setIsValid true
      setDebouncedValue newValue
    catch error
      setIsValid false
    finally
      setDisplayValue newValue

  <Input
    error={not isValid}
    value={displayValue}
    onChange={(e, d) -> handleSearchChange d.value}
    icon='search'
  />


export default NewDataTable = ({
  name,
  schemaBridge,
  rows, limit, totalRowCount,
  loadMoreRows = (args...) -> console.log "loadMoreRows default stump called with arguments:", args...
  useSort, sortColumn, sortDirection,
  onChangeSort = (args...) -> console.log "onChangeSort default stump called with arguments:", args...
  canSearch, search,
  onChangeSearch = (args...) -> console.log "onChangeSearch default stump called with arguments:", args...
  isLoading
  canAdd, onAdd = (args...) -> console.log "onAdd default stump called with arguments:", args...
  canDelete, onDelete = (args...) -> console.log "onDelete default stump called with arguments:", args...
  canEdit, mayEdit,
  onChangeField = (args...) -> console.log "onChangeField default stump called with arguments:", args...
  onRowClick
  canExport, onExportTable = (args...) -> console.log "onExportTable default stump called with arguments:", args...
  mayExport
  overscanRowCount = 10
}) ->

  schema = schemaBridge.schema

  deleteColumnWidth = 50

  cacheRef = useRef newCache()

  headerContainerRef = useRef null
  [headerContainerWidth, headerContainerHeight] = useSize headerContainerRef

  contentContainerRef = useRef null
  [contentContainerWidth, contentContainerHeight] = useSize contentContainerRef

  tableRef = useRef null
  oldRows = useRef null

  columnKeys =
    schema._firstLevelSchemaKeys
    .filter (key) ->
      options = schema._schema[key].AutoTable ? {}
      if key in ['id', '_id']
        not (options.hide ? true) # don't include ids by default
      else
        not (options.hide ? false)

  initialColumnWidths = columnKeys.map (key, i, arr) ->
    schema._schema[key].AutoTable?.columnWidth ? 1/(if arr.length then arr.length else 20)

  getColumnWidthsFromLocalStorage = ->
    if global.localStorage
      try
        JSON.parse(global.localStorage.getItem name)?.columnWidths
      catch error
        console.error error

  saveColumnWidthsToLocalStorage = (newWidths) ->
    if global.localStorage
      currentEntry = (try JSON.parse global.localStorage.getItem name) ?{}
      global.localStorage.setItem name, JSON.stringify {currentEntry..., columnWidths: newWidths}

  [columnWidths, setColumnWidths] = useState getColumnWidthsFromLocalStorage() ? initialColumnWidths
  totalColumnsWidth = contentContainerWidth - if canDelete then deleteColumnWidth else 0

  [debouncedResetTrigger, setDebouncedResetTrigger] = useThrottle 0, 30

  onResizeRows = ({dataKey, deltaX}) ->
    prevWidths = columnWidths
    ratioDeltaX = deltaX/totalColumnsWidth
    i = _.findIndex columnKeys, (key) -> key is dataKey
    prevWidths[i] += ratioDeltaX
    prevWidths[i+1] -= ratioDeltaX
    setColumnWidths prevWidths
    saveColumnWidthsToLocalStorage prevWidths
    setDebouncedResetTrigger debouncedResetTrigger+1

  sort = ({event, defaultSortDirection, sortBy, sortDirection}) ->
    if 'sort-click-target' in event?.nativeEvent?.srcElement?.classList
      onChangeSort
        sortColumn: sortBy
        sortDirection: sortDirection

  useEffect ->
    if (newColumnWidths = getColumnWidthsFromLocalStorage())?
      setColumnWidths newColumnWidths
  , [name]

  useEffect ->
    cacheRef.current.clearAll()
    tableRef?.current?.forceUpdateGrid?()
  , [contentContainerWidth, contentContainerHeight, debouncedResetTrigger]

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
    columnKeys.map (key, i, arr) ->
      schemaForKey = schema._schema[key]
      options = schemaForKey.AutoTable ? {}
      isLastOne = i is arr.length-1
      className = if options.overflow then 'overflow'
      headerRenderer = resizableHeaderRenderer({onResizeRows, isLastOne}) #unless isLastOne
      <Column
        className={className}
        key={key}
        dataKey={key}
        label={schemaForKey.label}
        width={columnWidths[i] * totalColumnsWidth}
        cellRenderer={cellRenderer {schemaBridge, onChangeField, mayEdit, cache: cacheRef.current}}
        headerRenderer={headerRenderer}
      />


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
                  <SearchInput
                    size="small"
                    value={search}
                    onChange={onChangeSearch}
                  />
              }
            </div>
          </Grid.Column>
          <Grid.Column>
            <div style={textAlign: 'right'}>
              {
                if canExport
                  <Button  basic circular size="small" icon='download' onClick={onExportTable} disabled={not mayExport}/>
              }
              {
                if canAdd
                  <Button circular basic size="small" icon="plus" onClick={onAdd} disabled={not mayEdit}/>
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
            rowCount={rows?.length ? 0}
            rowGetter={getRow}
            rowClassName={({index}) -> if index%%2 then 'uneven' else 'even'}
            onRowsRendered={onRowsRendered}
            ref={tableRef}
            overscanRowCount={overscanRowCount}
            onRowClick={onRowClick}
            sort={sort}
            sortBy={sortColumn}
            sortDirection={sortDirection}
          >
            {columns}
            {if canDelete then <Column
              dataKey="no-data-key"
              label=""
              width={deleteColumnWidth}
              cellRenderer={deleteButtonCellRenderer {onDelete}}
            />}
          </Table>
        }
      </InfiniteLoader>
    
  </div>