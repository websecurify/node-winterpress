'use strict'

# ---
# ---
# ---

module.exports = (grunt) ->
	config = {}
	
	# ---
	
	(require '../lib/grunt.coffee').init_config grunt, config
	
	# ---
	
	grunt.initConfig config
	
	# ---
	
	(require '../lib/grunt.coffee').init_tasks grunt, config
	
# ---
