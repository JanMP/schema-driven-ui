Package.describe({
  name: 'janmp:schema-driven-ui',
  version: '0.6.0',
  // Brief, one-line summary of the package.
  summary: 'data tables, a mongodb query react component, desktop like workspace, wip',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Npm.depends({
  // "react": "16.13.1",
  // "papaparse": "5.0.0",
  // "react-toastify": "5.4.0",
  // "semantic-ui-calendar-react": "0.15.3",
  // "semantic-ui-css": "2.4.1",
  // "semantic-ui-react": "0.88.2",
  // "uniforms": "2.5.0",
  // "uniforms-bridge-simple-schema-2": "2.5.0",
  // "uniforms-semantic": "2.5.0",
})

Package.onUse(function(api) {
  api.versionsFrom('1.12');
  api.use('coffeescript@1.0.17');
  api.use('coagmano:stylus@1.0.3');
  api.use('ecmascript');
  api.use('typescript');
  api.use('alanning:roles@1.0.6');
  api.use('mdg:validated-method@0.2.3');
  api.use('momentjs:moment@2.8.4');
  api.use('peerlibrary:reactive-publish@0.1.0')
  api.use('tunguska:reactive-aggregate@1.0.4');
  api.mainModule('schema-driven-ui.js');
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('ecmascript');
  api.use('tinytest');
  api.use('janmp:schema-driven-ui');
  api.mainModule('schema-driven-ui-tests.js');
});
