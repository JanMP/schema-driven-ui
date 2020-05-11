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

Package.onUse(function(api) {
  api.versionsFrom('1.10.1');
  api.use('coffeescript@2.4.1');
  api.use('ecmascript');
  api.mainModule('schema-driven-ui.js');
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('ecmascript');
  api.use('tinytest');
  api.use('janmp:schema-driven-ui');
  api.mainModule('schema-driven-ui-tests.js');
});
