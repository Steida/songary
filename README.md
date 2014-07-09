# Songary App.

Build with [Este.js](https://github.com/steida/este) dev stack.

1. Clone repo.
2. ```bower install```
3. ```npm install```
4. ```gulp```

For production, run ```gulp -p```

## Learn from code

How? Just read it, there is a plethora of comments. 

Techniques demonstrated on this isomorphic app
  - client/mobile/offline first
  - React components read data from and propagate changes to stores.
  - Only stores can deal with models.
  - Storages controls stores state.
  - One way data flow, from react component to store to storage.
  - Async routing with Promises
