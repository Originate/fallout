# Fallout

Fallout allows you to create React components that automatically render when the relevent data changes. Some may call this "Flux-like" and I'll leave it for you the developer to label this as you see fit.

At it's core, Fallout provides an Immutable structure for the data backing the application. If you are comfortable with Immutable.js you can work with the data store directly, however, some helpers have been provided such that you don't have to use the Immutable library directly.

All changes to the data store are made in actions and that is the only place the data should be directly manipulated.

## Usage

Create some actions. These actions will be exposed to your components
as properties on `this.actions`. In the example below you would have
access to `this.actions.example.incrementCounter`. Within your actions
you will have access to the store in `this.store`.

```
Fallout.defineActionSet('example', {
  incrementCounter: function() {
    data = this.store.checkOut();
    data.counter += 1;
    this.store.checkIn(data);
  }
});
```

Create a component and mixin the `Fallout.Mixin`. Create a property
on your class definition called `watch` which can be either a
function that returns an object or just an object. The object should
have properties, each of which should have an array of keys as a value.
The array specifies the path to the data you need in the data store.
Each property defined in `watch` will be exposed on the component state
as the specified name. If you would like to use the actual Immutable
version of the data, you can access it on the component state by
preceding the specified name with an '_'.

```
var Example = React.createClass({
  mixins: [Fallout.Mixin],
  watch: {counter: ['counter']},
  onClick: function() {
    this.actions.example.incrementCounter();
  },
  render: function() {
    return (<div>
      <p>{this.state.counter || 0}</p>
      <button onClick={this.onClick}>Increment</button>
    </div>);
  }
});
```

When accessing the data in the store via actions, there are two functions to help you out.
You can checkout a standard `Object` representation of your data using
`data = this.store.checkOut()`.
You can then manipulate the object as you see fit and when done use
`this.store.checkIn(data)`.

You can work with the immutable data in the store directly if you prefer.
The object `store.data` is an `Immutable.Map`. To use it directly you'll need to reassign
the `store.data`, for example `this.store.data = this.store.data.set('counter', 2)`.
If you do this, you are also responsible for letting the system know there has been a change
and must manually call `this.store.emitChange()`.

## Development

When working on this library you can run all tests with `npm test` and you can build the project with `gulp`. You can use `node index.js` to get a Node REPL that has the Fallout library loaded and available to use in `Fallout`.

