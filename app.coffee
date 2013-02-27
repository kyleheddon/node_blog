express = require('express')
app = module.exports = express.createServer()

app.configure ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(require('stylus').middleware({ src: __dirname + '/public' }))
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))
  app.use('/', express.static(__dirname + '/lib/assets'));


app.configure 'development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))


app.configure 'production', ->
  app.use(express.errorHandler())

socket = require 'socket.io'
io = socket.listen app

io.on 'connection', (client) ->
  client.broadcast.emit 'message', 'Client connected...'
  console.log 'Client connected...'
  client.on 'message', (message) ->
    console.log message
    setTimeout ->
      client.broadcast.emit 'message', message
      client.emit 'message', 'ahh'
    ,0


app.get '/', (req, res) ->
  res.render('index.jade')  

app.listen(3000)