module.exports = (grunt) ->
  'use strict';

  grunt.registerMultiTask 'parse_ui_name', 'Parse ui name.', () ->

    # user specified options
    # =========================================================================
    default_options = grunt.config 'parse_ui_name.options'
    
    ui_key = default_options.key
    config_url = default_options.url
    config_content = grunt.file.read config_url

    
