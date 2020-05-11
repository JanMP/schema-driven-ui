import _ from 'lodash'

output =
  fallId: 471
  HD:
    'ICD-Kode': 'E87.6'
    w : 0.333
  ND: [
    'ICD-Kode': 'J90'
    w : 0.444
  ,
    'ICD-Kode': 'F12'
    w : 0.555
  ]
  survived: 0.666

console.log JSON.stringify output, null, 2

fehlerOutput =
  fallId: 471
  error: 'Fehlermeldung'
  HD:
    'ICD-Kode': null
    w : null
  ND: []
  survived: null

console.log JSON.stringify fehlerOutput, null, 2
