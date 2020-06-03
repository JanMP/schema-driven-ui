## AutoTable Settings in SimpleSchema

Import this file before defining your SimpleSchema, to ensure it will accept the settings specific to AutoTable.

    import SimpleSchema from 'simpl-schema'
    SimpleSchema.extendOptions ['AutoTable', 'uniforms', 'QueryEditor']

The options used by AutoTable will be:

Key | Type | Default |Description
----|------|---------|-----------
hide|Boolean|false*|Don't display in Table. Default true for `ìd` or `_id`
