'use strict'

# ---
# ---
# ---

path = require 'path'

# ---
# ---
# ---

@build_folder = '.build/'
@wintersmith_config = {}

# ---
# ---
# ---

load_npm_task = (grunt, task) ->
	return grunt.loadNpmTasks task unless grunt.file.exists path.join __dirname, '..', 'node_modules', task
	
	# ---
	
	cwd = do process.cwd
	
	# ---
	
	process.chdir path.join __dirname, '..'
	
	# ---
	
	grunt.loadNpmTasks task
	
	# ---
	
	process.chdir cwd
	
# ---
# ---
# ---

@init_config = (grunt, config) ->
	config.copy ?= {}
	
	config.copy.winterpress_copy_app_to_build =
		files: [
			{expand: true, cwd: '', src: 'app/**/*', dest: @build_folder, filter: 'isFile'}
		]
		
	# ---
	
	config.express ?= {}
	
	config.express.winterpress_start_app_from_build =
		options:
			script: path.join(@build_folder, 'index.js')
			
	# ---
	
	config.watch ?= {}
	
	config.watch.winterpress_app_copy_and_start =
		files: ['app/**/*']
		tasks:  ['copy:winterpress_copy_app_to_build', 'express:winterpress_start_app_from_build']
		options: spawn: false
		
	config.watch.winterpress_contents_and_build =
		files: ['contents/**/*']
		tasks: ['winterpress:build_contents']
		options: spawn: true
		
	config.watch.winterpress_templates_and_build =
		files: ['templates/**/*']
		tasks: ['winterpress:build_contents']
		options: spawn: true
		
	# ---
	
	config.focus ?= {}
	
	config.focus.winterpress_app_contents_and_templates =
		include: ['winterpress_app_copy_and_start', 'winterpress_contents_and_build', 'winterpress_templates_and_build']
		
@init_tasks = (grunt, config) ->
	load_npm_task grunt, 'grunt-focus'
	load_npm_task grunt, 'grunt-contrib-copy'
	load_npm_task grunt, 'grunt-contrib-watch'
	load_npm_task grunt, 'grunt-express-server'
	
	# ---
	
	grunt.registerTask 'winterpress:build_index', do (self=@) -> ->
		fs = require 'fs'
		
		# ---
		
		contents = fs.readFileSync path.join __dirname, '..', 'data', 'index.js'
		
		# ---
		
		grunt.file.write path.join(self.build_folder, 'index.js'), contents
		
	grunt.registerTask 'winterpress:build_contents', do (self=@) -> ->
		done = @async()
		
		# ---
		
		wintersmith = require 'wintersmith'
		
		# ---
		
		env = wintersmith self.wintersmith_config
		
		# ---
		
		env.build path.join(self.build_folder, 'contents'), done
		
	# ---
	
	grunt.registerTask 'winterpress:build', ['winterpress:build_contents', 'winterpress:build_index', 'copy:winterpress_copy_app_to_build']
	grunt.registerTask 'winterpress:run', ['winterpress:build', 'express:winterpress_start_app_from_build', 'focus:winterpress_app_contents_and_templates']
	
# ---
