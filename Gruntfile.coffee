# building by Grunt.js
#
# =============================================================================

# dependiences
cson         = require 'cson'
lodash       = require 'lodash'
htmlencode   = require 'node-htmlencode'

# package and configuration data
pkg          = require './package.json'
build_config = cson.parseFileSync('./config.cson')

module.exports = (grunt) ->
  'use strict';

  # build configuration
  # ---------------------------------------------------------------------------
  grunt.initConfig
    pkg: pkg
    dirs: build_config.dirs

    # config data for building
    build_config: build_config

    version:
      build:
        options:
          pkg: 'package.json'
        src: [
          'bower.json'
          'config.cson'
        ]

    copy:

      # rename tentomon-debug.css override style.css in styleguide/public
      tentomon_style:
        expand: true
        cwd: '<%= dirs.styleguide %>public/'
        src: 'tentomon-debug.css'
        dest: '<%= dirs.styleguide %>public'
        rename: (path, name) ->
          console.log path
          name = 'style.css'

          return path + '/' + name

      # copy guide template to build directory
      guide_template:
        expand: true
        cwd: '<%= dirs.bower %>kss-node-template/'
        src: 'template/**/*'
        dest: '<%= dirs.build %>'

      # copy markdown style to document directory
      markdown_style:
        expand: true
        cwd: '<%= dirs.bower %>github-markdown-css/'
        src: 'github-markdown.css'
        dest: '<%= dirs.document %>styles/'

      # copy normalize.styl to stylus vender directory
      normalize:
        expand: true
        cwd: '<%= dirs.bower %>normalize.styl/'
        src: 'normalize.styl'
        dest: '<%= dirs.stylus %>vender/normalize/'

      # copy elastic-grid.styl to stylus vender directory
      elastic:
        expand: true
        cwd: '<%= dirs.bower %>elastic-grid.css/stylus/'
        src: '**/*.styl'
        dest: '<%= dirs.stylus %>vender/elastic/'

    replace:

      # replace template name to project name
      guide_template:
        overwrite: true
        src: [ '<%= dirs.build %>template/index.html' ]
        replacements: [
          {
            from: 'kss-node Styleguide'
            to: '<%= pkg.name %>'
          }
        ]

    clean:

      # clean dist stylesheet
      dist: [
        '<%= dirs.dist %>'
      ]

      # clean styleguide template in build
      build: [
        '<%= dirs.build %>'
      ]

      # clean styleguide
      styleguide: [
        '<%= dirs.styleguide %>'
      ]

      # clean vender
      vender: [
        '<%= dirs.vender %>'
      ]

      # clean document directory
      document: [
        '<%= dirs.document %>'
      ]

    stylus:
      options:
        banner: [
          '/*',
          '  ' + pkg.name + ' v' + pkg.version,
          '  ' + pkg.description,
          '',
          "  " + "Build on <%= grunt.template.today('yyyy-mm-dd hh:MM:ss') %> power by Grunt.js",
          '*/\n'
        ].join '\n'

      tentomon_debug:
        options:
          compress: false
        files:
          '<%= dirs.build %>tentomon-debug.css': '<%= dirs.stylus %>application.styl'

      tentomon_min:
        options:
          compress: true
        files:
          '<%= dirs.build %>tentomon-min.css': '<%= dirs.stylus %>application.styl'

    autoprefixer:
      options:
        browsers: ['last 2000 versions']
        cascade: true
        diff: false
        map: false

      tentomon_debug:
        expand: true
        flatten: true
        src: '<%= dirs.build %>tentomon-debug.css'
        dest: '<%= dirs.dist %>'

      tentomon_min:
        expand: true
        flatten: true
        src: '<%= dirs.build %>tentomon-min.css'
        dest: '<%= dirs.dist %>'

    styleguide:

      # default options
      options:
        framework:
          name: 'kss'
        template:
          src: '<%= dirs.build %>template'

      build:
        options:
          name: '<%= pkg.name %>'
        files:
          '<%= dirs.styleguide %>': '<%= dirs.stylus %>application.styl'

    git_log:

      # default options
      options:
        branch: 'dev'
        arguments:
          '--pretty': '%h %cd - %s'

      # get versioning form master branch
      build:
        processor: (result) ->
          result = String result

          # public result data
          grunt.config 'git_log.versioning', htmlencode.htmlEncode result

    markdown:
      options:
        template: '<%= dirs.markdown %>template.jst'
        templateContext:
          doc_name: '<%= pkg.name %>'
          versioning: ''
          render_date: '<%= grunt.template.today("yyyy年mm月dd日 hh:MM:ss") %>'

        # add build time stamp
        preCompile: (src, context) ->
          match_doc_name = /^(.+)[\r|\n]+\={3}/igm
          result = match_doc_name.exec src

          context.doc_name = result[1]
          context.versioning = grunt.config 'git_log.versioning'

          return src

        markdownOptions:
          gfm: true
          highlight: 'auto'

      document:
        expand: true
        cwd: '<%= dirs.markdown %>'
        src: '*.md'
        dest: '<%= dirs.document %>'
        ext: '.html'

    watch:

      # default options
      options:
        debounceDelay: 500

      doc:
        files: [
          '<%= dirs.markdown %>*.md'
        ]

        tasks: [
          'generate_doc'
        ]

      # auto re-generate styleguide
      guide:
        files: [
          '<%= dirs.stylus %>**/*.styl'
        ]

        tasks: [
          'generate_guide'
        ]

  # check out grunt config
  # console.log grunt.config 'markdown.document'


  # load npm tasks
  # ---------------------------------------------------------------------------
  grunt.loadNpmTasks 'grunt-version'
  grunt.loadNpmTasks 'grunt-markdown'
  grunt.loadNpmTasks 'grunt-styleguide'
  grunt.loadNpmTasks 'grunt-text-replace'
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  # load custom tasks
  # ---------------------------------------------------------------------------
  grunt.loadTasks build_config.dirs.tasks

  # register tasks
  # ---------------------------------------------------------------------------

  # copy plugins to stylus plugins directory
  grunt.registerTask 'copy:vender', [
    'copy:normalize'
    'copy:elastic'
  ]

  # compile project stylesheet
  grunt.registerTask 'css', [
    'copy:vender'
    'stylus:tentomon_debug'
    'stylus:tentomon_min'
    'autoprefixer:tentomon_debug'
    'autoprefixer:tentomon_min'
  ]

  grunt.registerTask 'generate_guide', [

    # copy guide template
    'copy:guide_template'

    # render style guide
    'replace:guide_template'
    'styleguide:build'

    # compile css for kss styleguide
    # and add vender prefix
    'css'

    # use stylesheet with vender prefix replace the old style.css
    'copy:tentomon_style'
  ]

  grunt.registerTask 'generate_doc', [
    'git_log:build'
    'markdown:document'
    'copy:markdown_style'
  ]

  # generate style guide
  grunt.registerTask 'guide', [
    'generate_guide'
    'watch:guide'
  ]

  # generate html document
  grunt.registerTask 'doc', [
    'generate_doc'
    'watch:doc'
  ]

  # update version
  grunt.registerTask 'v', [
    'version'
  ]
