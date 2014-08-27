module.exports = (grunt) ->
  'use strict';

  # dependencies
  lodash = require 'lodash'
  dateformat = require 'dateformat'

  grunt.registerMultiTask 'git_log', 'Get git commit msg.', (options) ->
    this.requiresConfig 'git_log'

    options = options || {}
    done = this.async()

    # task specified options
    # =========================================================================

    git_args = ['log']
    git_args_str = ''
    git_command_options = null

    # user specified options
    # =========================================================================
    default_options = grunt.config 'git_log.options'
    task_options = lodash.defaults options, @data, default_options

    dest = task_options.dets || ''
    processor = task_options.processor || null

    # branch 
    git_args.push task_options.branch if task_options.branch

    # join git arguments
    lodash.each  task_options.arguments, (value, key) ->
      value = if value then '=' + value else value
      git_args.push "#{key}#{value}"

    # group git command optinos
    git_command_options =
      cmd: 'git'
      args: git_args

    git_args_str = git_args.join ' '
    grunt.log.writeln "\nExecuting command: git #{git_args_str}\n"

    grunt.util.spawn git_command_options, (err, result) ->

      if err
        grunt.log.error err
        return done false

      # write to dest file
      if dest
        grunt.file.write dest, result
        grunt.log.ok 'Git log written to #{dest}.'

      # custom processor
      else if processor
        processor result

      # just log to console
      else 
        grunt.log.write result

      done()