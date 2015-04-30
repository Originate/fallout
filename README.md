# Fallout

Fallout allows you to create React components that automatically render when the relevent data changes. Some may call this "Flux-like" and I'll leave it for you the developer to label this as you see fit.

At it's core, Fallout provides an Immutable structure for the data backing the application. If you are comfortable with Immutable.js you can work with the data store directly, however, some helpers have been provided such that you don't have to use the Immutable library directly.

All changes to the data store are made in actions and that is the only place the data should be directly manipulated.

## Setup

Since Fallout uses `Immutable.js`, you must have it available. It will look for it using standard
module systems and finally on `window`.

```
<script src='https://cdnjs.cloudflare.com/ajax/libs/immutable/3.7.1/immutable.min.js'></script>
<script src='/fallout.js'></script>
```

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
The object `store.data` is an `Immutable.Map`. To change the data in the store you can
use the `store.setData` function, for example `this.store.setdata this.store.data.set('counter', 2)`.

## Intializing

You likely will want your store to start in some initial state with some default values.
You can initialize the store by giving it a standard `Object` or by directly assigning an
Immutable `Map` to the store's data via `setData`.

`Fallout.store.initialize({key: 'value'});`

*OR*

`Fallout.store.setData Immutable.Map({key: 'value'});`

## Testing

When testing your actions, you'll likely want to reset your store before each test.

```
beforeEach(function() {
  Fallout.store.listeners = [];
  Fallout.store.initialize({});
});
```

For each test you should set the store to the applicable state, fire your action, and verify the
final state of the store.

You should not need to `mock` the store as it has no resource dependencies that would need mocking.

You can and should handle mocking any dependencies your actions use such as API access.

## Development

When working on this library you can run all tests with `npm test` and you can build the project with `gulp`. You can use `node index.js` to get a Node REPL that has the Fallout library loaded and available to use in `Fallout`.

