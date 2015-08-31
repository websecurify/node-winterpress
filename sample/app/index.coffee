'use strict'

# ---
# ---
# ---

path = require 'path'
express = require 'express'

# ---
# ---
# ---

app = express()

# ---

app.use '/', express.static path.join __dirname, '..', 'contents'

# ---
# ---
# ---

server = app.listen 3000, (err) ->
	throw err if err
	
	# ---
	
	host = server.address().address
	port = server.address().port
	
	# ---
	
	console.log "app listening at http://#{host}:#{port}"
	
# ---
