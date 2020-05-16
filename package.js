Package.describe({
  name: 'janmp:schema-driven-ui',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Npm.depends({
  "papaparse": "5.0.0",
  "react": "16.5.0",
  "react-dom": "16.5.0",
  "react-toastify": "5.4.0",
  "semantic-ui-calendar-react": "0.15.3",
  "semantic-ui-css": "2.4.1",
  "semantic-ui-react": "0.88.2",
  "uniforms": "2.5.0",
  "uniforms-bridge-simple-schema-2": "2.5.0",
  "uniforms-semantic": "2.5.0",
})

Package.onUse(function(api) {
  api.versionsFrom('1.10.1');
  api.use('coffeescript@2.4.1');
  api.use('ecmascript');
  api.use('alanning:roles');
  api.use('mdg:validated-method');
  api.use('momentjs:moment');
  api.use('tunguska:reactive-aggregate');
  api.mainModule('schema-driven-ui.js');
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('ecmascript');
  api.use('tinytest');
  api.use('janmp:schema-driven-ui');
  api.mainModule('schema-driven-ui-tests.js');
});
