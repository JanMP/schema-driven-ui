# Custom Forms build with React
This is a reimplementation of the forms provided by uniforms, but build with semantic-ui-react components.

In some cases other components.

## Used Packages
The following npm packages are required to work for the custom implementations:
- react
- semantic-ui-react
- semantic-ui-calendar-react
- uniforms
- moment

## Special Features
On some components special additions have been made.

### 1. Error Popup
Normaly errors will be displayed in a summary at the of a form, this component won't disable the summary, 
but replace the normal display of errors with a red border and input field. 
With a Popup which is triggered when the user hovers over them, the red input field will still remain, but no inline error will be displayed.

To us the popup the `CustomBaseField` has the method `renderPopup(trigger)`.
The trigger is the actual component you want to display in the form.

Example:
```Javascript 
class CustomField extends CustomBaseField{

    renderField(){
        return(
            <SomeInputField/>
        );
    }

    render(){
        return (
            <div>
                {this.renderPopup(this.renderField())}
            </div>
        );
    }
}
```

### 2. `readOnly`
`readOnly` provides a way for both the whole form and a single component to be made a `ReadOnlyField`.

The `ReadOnlyField` will just display the Value, that was passed to it via the props.

Either use it on a form like this:
```JavaScript
<AutoForm readOnly/> // This not a complete Form, just an example on how to use the property
```
This will make the whole form readOnly, as this prop is passed down to its child components.

Or like this, on a single component:
```JavaScript
<AutoField readOnly/> // Not a complete AutoField
```

It's also usable in a schema.
```JavaScript
const schema = {
    someField: {
        type:String,
        uniforms: {
            readOnly: true
        }
    }
};
```

By default the prop is set to `false`. A form which does not set `readOnly` will be displayed as a normal form with input fields.

### 3. `disableErrorSummary`
Normally, when a validation error occurs, at the end of the form a error summary is displayed.
When `disableErrorSummer` is set to true, this summary will not be displayed anymore.

This can only be used on the whole form.
```JavaScript
<AutoForm disableErrorSummer/> // Not a complete Form
```


### 4. `CustomListField`

`CustomListField` can take multiple custom properties, which it passes down to its child components `CustomListAddField` and `CustomListDelField`.
`addIcon` specifies an add Icon for the whole form and displays it on the top left of the list field.
`deleteIcon` does the same to the cross which is normally displayed next to an entry of the list field.

These icons can be specified like this, but also on the components themself.

#### `CustomListAddField`
This is an addition to the ListField. This makes it possible to add more of the fields specified in the schema.
But the icon could not be changed. With the custom implementation this is possible.

If the `icon` property is not defined, it will display the default icon of uniforms.

Then there also is the `limit` property. It limits the ListField to only allow up to the limits count of subfields.

```JavaScript 
export default class CustomListField extends CustomBaseField {

    renderCustomIcon(){
        return (
            <i class="something else"/>
        );
    }

    render(){
        return (
            <CustomListAddField icon={this.renderCustomIcon()} limit={10}>
        );
    }
}
```

#### `CustomListDelField`
The same can be done with the CustomListDelField. It can also take an `icon` property.
