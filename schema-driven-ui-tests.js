// Import Tinytest from the tinytest Meteor package.
import { Tinytest } from "meteor/tinytest";

// Import and rename a variable exported by schema-driven-ui.js.
import { name as packageName } from "meteor/janmp:schema-driven-ui";

// Write your tests here!
// Here is an example.
Tinytest.add('schema-driven-ui - example', function (test) {
  test.equal(packageName, "schema-driven-ui");
});
