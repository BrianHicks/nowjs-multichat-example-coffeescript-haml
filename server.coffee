fs = require 'fs'
haml = require 'haml'
http = require 'http'
now = require 'now'
coffee = require 'coffee-script'

# render static files
appfile = haml.render fs.readFileSync 'client.haml', 'utf8'
appjs = coffee.compile fs.readFileSync 'client.coffee', 'utf8'

# server
server = require('http').createServer( (req, res) ->
  # url handling
  switch req.url
    when "/"
      res.writeHead 200,
        'Content-Type': 'text/html'
      res.write appfile

    when "/client.js"
      res.writeHead 200,
        'Content-Type': 'text/javascript'
      res.write appjs

    else
      res.writeHead 404,
        'Content-Type': 'text/html'
      res.write "File not found: " + req.url

  res.end()
)
server.listen 1337

everyone = now.initialize server

# nowjs
now.on 'connect', ->
  this.now.room = 'room 1'
  now.getGroup(this.now.room).addUser(this.user.clientId)
  console.log 'Joined: ' + this.now.name

now.on 'disconnect', ->
  console.log 'Left: ' + this.now.name

everyone.now.changeRoom = (newRoom) ->
  now.getGroup(this.now.room).removeUser(this.user.clientId)
  now.getGroup(newRoom).addUser(this.user.clientId)
  this.now.room = newRoom
  this.now.receiveMessage "SERVER", "You're now in " + this.now.room

everyone.now.distributeMessage = (message) ->
  now.getGroup(this.now.room).now.receiveMessage this.now.name, message
