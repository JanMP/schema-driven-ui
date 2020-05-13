import {Mongo} from 'meteor/mongo'
import React, {useState, useEffect} from 'react'
import meteorApply from 'meteor/janmp:schema-driven-ui/imports/helpers/meteorApply'
import AutoTable from './AutoTable'
import FormModal from './FormModal'
import {Button, Icon, Modal, Table} from 'semantic-ui-react'
import {useTracker} from 'meteor/react-meteor-data'
import ErrorBoundary from './ErrorBoundary'
import {toast} from 'react-toastify'
import {useCurrentUserIsInRole} from '/imports/api/roleChecks'
import getColumnsToExport from './getColumnsToExport'
import Papa from 'papaparse'
import downloadAsFile from '/imports/helpers/downloadAsFile'
import _ from 'lodash'

export default MeteorDataAutoTable = (props) ->
  {
  sourceName, listSchema,
  usePubSub, rowsCollection, rowCountCollection
  title, titleIcon, subTitle
  query
  perPage
  canEdit = false
  formSchema
  hasSubmitted
  canSearch = false
  canAdd = false
  onAdd
  canDelete = false
  deleteConfirmation = "Soll der Eintrag wirklich gelöscht werden?"
  onDelete
  canExport = false
  onExportTable
  onRowClick
  autoFormChildren
  disabled = false
  readOnly = false
  useSort = true
  getRowMethodName, getRowCountMethodName
  rowPublicationName, rowCountPublicationName
  submitMethodName, deleteMethodName, fetchEditorDataMethodName
  exportRowsMethodName
  viewTableRole, editRole, exportTableRole
  redrawTrigger = ->
  } = props

  if usePubSub and not (rowsCollection? and rowCountCollection?)
    throw new Error 'usePubSub is true but rowsCollection or rowCountCollection not given'

  if sourceName?
    getRowMethodName ?= "#{sourceName}.getRows"
    getRowCountMethodName ?= "#{sourceName}.getCount"
    rowPublicationName ?= "#{sourceName}.rows"
    rowCountPublicationName ?= "#{sourceName}.count"
    submitMethodName ?= "#{sourceName}.submit"
    fetchEditorDataMethodName ?= "#{sourceName}.fetchEditorData"
    deleteMethodName ?= "#{sourceName}.delete"
    exportRowsMethodName ?= "#{sourceName}.getExportRows"

  listSchema ?= sourceSchema
  formSchema ?= listSchema
  hasSubmitted ?= ->

  if onRowClick and canEdit
    throw new Error 'both onRowClick and canEdit set to true'

  perPage ?= 20
  onRowClick ?= ->

  [rows, setRows] = useState []
  [totalPages, setTotalPages] = useState 0

  [isLoading, setIsLoading] = useState false
  [loaderContent, setLoaderContent] = useState 'Lade Daten...'
  [loaderIndeterminate, setLoaderIndeterminate] = useState false

  [activePage, setActivePage] = useState 1
  [sortColumn, setSortColumn] = useState undefined
  [sortDirection, setSortDirection] = useState undefined

  [model, setModel] = useState {}
  [modalOpen, setModalOpen] = useState false
  
  [confirmationModalOpen, setConfirmationModalOpen] = useState false
  [idForConfirmationModal, setIdForConfirmationModal] = useState ''

  [search, setSearch] = useState ''

  mayEdit = useCurrentUserIsInRole editRole
  mayExport = (useCurrentUserIsInRole exportTableRole) and rows?.length

  if sortColumn? and sortDirection?
    sort = "#{sortColumn}": if sortDirection is 'ascending' then 1 else -1

  redrawTriggerValue = useTracker ->
    redrawTrigger()

  getRows = ->
    return if usePubSub
    setIsLoading true
    meteorApply
      method: getRowMethodName
      data: {search, query, sort, limit, skip}
    .then (returnedRows) ->
      setRows returnedRows
      setIsLoading false
    .catch (error) ->
      console.error error
      setIsLoading false

  getTotalPages = ->
    return if usePubSub
    meteorApply
      method: getRowCountMethodName
      data: {search, query}
    .then (result) ->
      setTotalPages Math.ceil (result?[0]?.count or 0)/perPage
    .catch console.error

  useEffect ->
    if query?
      getTotalPages()
    return
  , [search, query, sourceName, redrawTriggerValue]

  useEffect ->
    if activePage > totalPages then setActivePage (Math.max 1, totalPages)
    return
  , [activePage, totalPages]

  useEffect ->
    setActivePage 1
    return
  , [sourceName]

  useEffect ->
    if query?
      setLoaderContent 'Lade Daten...'
      setLoaderIndeterminate false
      setIsLoading false
      getRows()
    else
      setLoaderContent 'Kein gültiger Query'
      setLoaderIndeterminate true
      setIsLoading true
    return
  , [activePage, search, query, sortColumn, sortDirection, sourceName, redrawTriggerValue]

  limit = perPage
  skip = (activePage - 1) * perPage

  subLoading = useTracker ->
    return unless usePubSub
    handle = Meteor.subscribe rowPublicationName, {search, query, sort, skip, limit}
    not handle.ready()
  , [search, query, sort, skip, limit]
  useEffect ->
    setIsLoading subLoading
  , [subLoading]
  
  countSubLoading = useTracker ->
    return unless usePubSub
    handle = Meteor.subscribe rowCountPublicationName, {query, search}
    not handle.ready()
  , [query, search]

  subRowCount = useTracker ->
    return unless usePubSub
    rowCountCollection.findOne({})?.count or 0
  useEffect ->
    setTotalPages Math.ceil subRowCount/perPage
  , [subRowCount]

  subRows = useTracker ->
    return unless usePubSub
    rowsCollection.find({}, {sort}).fetch()[0...limit]
  useEffect ->
    unless _.isEqual subRows, rows
      setRows subRows
    return
  , [subRows]

  onChangePage = (e, d) -> setActivePage d.activePage

  onChangeSort = (d) ->
    setSortColumn d.newSortColumn
    setSortDirection d.newSortDirection

  submit = (d) ->
    meteorApply
      method: submitMethodName
      data: d
    .then ->
      hasSubmitted d
    .then ->
      getRows()
    .then ->
      setModalOpen false
    .catch (error) -> console.error error

  openModal = (formModel) ->
    setModel formModel
    setModalOpen true

  loadEditorData = ({id}) ->
    unless id?
      throw new Error 'loadEditorData: no id'
    meteorApply
      method: fetchEditorDataMethodName
      data: {id}
    .catch console.error

  onChangeSearch = (d) ->
    setSearch d

  onAdd ?= -> openModal {}

  deleteEntry = ({id}) ->
    setConfirmationModalOpen false
    meteorApply
      method: deleteMethodName
      data: {id}
    .then ->
      toast.success "Der Eintrag wurde gelöscht"

  onDelete ?=
    unless canDelete
      -> console.error 'onDelete has been called despite canDelete false'
    else
      ({id}) ->
        if deleteConfirmation?
          setIdForConfirmationModal id
          setConfirmationModalOpen true
        else
          deleteEntry {id}
        

  if canEdit
    onRowClick =
      ({rowData, index}) ->
        if formSchema is listSchema
          openModal rows[index]
        else
          loadEditorData id: rowData._id
          .then openModal
   
  if canExport
    onExportTable ?= ->
      meteorApply
        method: exportRowsMethodName
        data: {search, query, sort}
      .then (rows) ->
        toast.success "Exportdaten vom Server erhalten"
        Papa.unparse rows, columns: getColumnsToExport schema: listSchema
      .then (csvString) ->
        downloadAsFile
          dataString: csvString
          fileName: title ? sourceName
      .catch (error) ->
        console.error error
        toast.error "Fehler (siehe console.log)"

  <>
    {
      if canEdit and mayEdit
        <FormModal
          schema={formSchema}
          onSubmit={submit}
          model={model}
          open={modalOpen}
          onClose={-> setModalOpen false}
          children={autoFormChildren}
          disabled={disabled}
          readOnly={readOnly}
        />
    }
    {
      if canDelete and deleteConfirmation?
        <Modal
          open={confirmationModalOpen}
          onClose={-> setConfirmationModalOpen false}
          basic
        >
          <Modal.Content>
            <p>{deleteConfirmation ? 'fnord'}</p>
          </Modal.Content>
          <Modal.Actions>
            <Button basic inverted color="red" onClick={-> setConfirmationModalOpen false} >
              <Icon name="times"/> Abbrechen
            </Button>
            <Button basic inverted color="green" onClick={-> deleteEntry id: idForConfirmationModal} >
              <Icon name="checkmark"/> OK
            </Button>
          </Modal.Actions>
        </Modal>
    }
    <AutoTable
      {{
        schema: listSchema, rows, onRowClick,
        sortColumn, sortDirection, onChangeSort, useSort
        activePage, totalPages, onChangePage,
        canSearch, search, onChangeSearch
        canAdd, onAdd
        canDelete, onDelete
        canEdit
        mayEdit
        canExport, onExportTable
        mayExport
        isLoading, loaderContent, loaderIndeterminate
        title, titleIcon, subTitle
      }...}
    />
  </>

    