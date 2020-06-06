import React, {useState, useEffect} from 'react'
import markdownWithData from './markdownWithData'
import mark from 'markdown-it-mark'
import footnote from 'markdown-it-footnote'
import emoji from 'markdown-it-emoji'
import deflist from 'markdown-it-deflist'
import ins from 'markdown-it-ins'
import sub from 'markdown-it-sub'
import sup from 'markdown-it-sup'
import abbr from 'markdown-it-abbr'
import {default as anchor} from 'markdown-it-anchor'
import {default as tocDoneRight} from 'markdown-it-toc-done-right'
import customBlock from 'markdown-it-custom-block'

#TODO REDESIGN options für die TOC https://www.npmjs.com/package/markdown-it-toc-done-right
tocOptions =
  containerClass: 'help-nav'
  level: [1, 2]
  listType: 'ul'

customBlocks =
  helpContent: (content) -> "<div class='help-content'>#{content}</div>"

md =
  require('markdown-it')
    html: true
    linkify: true
    typographer: true
    quotes: '„“‚‘'
  .use mark
  .use footnote
  .use emoji
  .use deflist
  .use ins
  .use sub
  .use sup
  .use abbr
  .use anchor
  .use tocDoneRight, tocOptions
  .use customBlock, customBlocks

export default MarkDownDisplay = ({markdown= '', data, formatters, helpWithData, style, contentClass, contentWrapper}) ->

  contentWrapper ?= (x) -> x

  wrappedMarkdown = contentWrapper markdown

  markdownToRender = markdownWithData {markdown: wrappedMarkdown, data, formatters, helpWithData}

  <div
    dangerouslySetInnerHTML={__html: md.render markdownToRender}
    style={style}
    className={contentClass}
  />
