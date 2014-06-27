# build TaiOA project power by Grunt.js
# =============================================================================
#
# Designate build mode
# -----------------------------------------------------------------------------
#   grunt --m [mode name or alias]
#   grunt --mode [mode name or alias]
#
# Render demo pages
# -----------------------------------------------------------------------------
# render all demo pages in given template directory
#   grunt demo
#
# render specific demo page in given template directory
#   grunt demo:about
#
# =============================================================================

# dependiences
lodash = require './node_modules/lodash/lodash'

# project and configuration data
pkg = require './package.json'
build_config = require './config.json'

module.exports = (grunt) ->
  'use strict';

  # public variables
  # ---------------------------------------------------------------------------
  mode = null

  # build configuration
  # ---------------------------------------------------------------------------
  grunt.initConfig
    pkg: pkg
    dev_dirs: build_config.dev_dirs
    run_dirs: build_config.run_dirs

    # mode name will be override in parse_mode_alias task
    mode: grunt.option('m') || grunt.option('mode') || ''

    # config data for building
    build_config: build_config

    copy:

      # copy guide_template to build dir
      guide_template:
        expand: true
        cwd: '<%= dev_dirs.bower %>kss-node-template/'
        src: 'template/**/*'
        dest: '<%= dev_dirs.build %>'

      # copy assets to styleguid document dir
      guide_assets:
        expand: true
        cwd: '<%= run_dirs.main %>'
        src: 'assets/**/*'
        dest: '<%= dev_dirs.styleguide %>'

      # copy iconic fonts to assets dir
      iconic_fonts:
        expand: true
        cwd: '<%= dev_dirs.bower %>open-iconic/font/'
        src: 'fonts/**/*'
        dest: '<%= run_dirs.assets %>'

      # copy markdown style to document dir
      markdown_style:
        expand: true
        cwd: '<%= dev_dirs.bower %>github-markdown-css'
        src: 'github-markdown.css'
        dest: '<%= dev_dirs.document %>styles/'

    replace:

      # replace iconic font url in stylesheet
      iconic:
        src: [ '<%= dev_dirs.bower %>open-iconic/font/css/open-iconic.styl' ]
        dest: '<%= dev_dirs.stylus %>plugins/'
        replacements: [
          {
            from: '../fonts/'
            to: '../<%= dev_dirs.assets %>fonts/'
          }
        ]

      # replace template name to project name
      guide_template:
        overwrite: true
        src: [ '<%= dev_dirs.build %>template/index.html' ]
        replacements: [
          {
            from: 'kss-node Styleguide'
            to: 'PYOA Style Guide'
          }
        ]

    clean:

      # clean styleguide template in build
      guide: [
        '<%= dev_dirs.build %>template'
      ]

    jade:

      # default options
      options:
        debug: false
        pretty: true

    styleguide:

      # default options
      options:
        framework:
          name: 'kss'
        template:
          src: '<%= dev_dirs.build %>template'
      build:
        options:
          name: 'PYOA Style Guide'
        files:
          '<%= dev_dirs.styleguide %>': 'stylus/styles.styl'

    markdown:
      options:
        template: '<%= dev_dirs.markdown %>template.jst'
        templateContext:
          doc_name: 'PYOA 文档'

        # add build time stamp
        preCompile: (src, context) ->
          time_str = '\n\r*该文档生成于  <%= grunt.template.today("yyyy年mm月dd日 hh:MM:ss") %>*'

          return src + grunt.template.process time_str
        markdownOptions:
          gfm: true
          highlight: 'auto'
      document:
        expand: true
        cwd: '<%= dev_dirs.markdown %>'
        src: '*.md'
        dest: '<%= dev_dirs.document %>'
        ext: '.html'

    watch:

      # default options
      options:
        debounceDelay: 30000

      # auto re-generate styleguide
      guide:
        files: [
          '<%= dev_dirs.stylus %>**/*.styl'
        ]
        tasks: [
          'styleguide:build'
        ]

  # check out grunt config
  # console.log grunt.config 'markdown.document'


  # load npm tasks
  # ---------------------------------------------------------------------------
  grunt.loadNpmTasks 'grunt-markdown'
  grunt.loadNpmTasks 'grunt-styleguide'
  grunt.loadNpmTasks 'grunt-text-replace'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'


  # load custom tasks
  # ---------------------------------------------------------------------------
  grunt.loadTasks 'tasks/'

  # register tasks
  # ---------------------------------------------------------------------------
  grunt.registerTask 'default', [
    'parse_alias_mode'
    'demo_page'
  ]

  # generate style guide
  grunt.registerTask 'guide', [
    'clean:guide'
    'copy:iconic_fonts'
    'copy:guide_template'
    'replace:iconic'
    'replace:guide_template'
    'styleguide:build'
    'copy:guide_assets'
    'watch:guide'
  ]

  # generate html document
  grunt.registerTask 'doc', [
    'markdown:document'
    'copy:markdown_style'
  ]