module.exports = function (grunt) {
    'use strict';

    // Set encoding
    grunt.file.defaultEncoding = 'utf8';

    // Force unix line endings
    grunt.util.linefeed = '\n';

    // Project configuration.
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        config: grunt.file.readJSON("grunt/csscomb.json"),
        lintFile: 'app/assets/CSS-Lint-Report/<%= grunt.template.date(\"mm-dd\") %>.txt',

        // Concat CSS & JS files
        concat: {
            options: {
                stripBanners: true
            },
            css: {
                src: ['<%= pkg.csspath %>/application.scss'],
                dest: '<%= pkg.csspath %>/application.scss'
            },
            js: {
                src: ['<%= pkg.jspath %>/application.js'],
                dest: '<%= pkg.jspath %>/application.js'
            }
        },

        // Add banner to head of CSS files
        usebanner: {
            css: {
                options: {
                    position: 'top',
                    banner: '/* \n' +
                    ' * <%= pkg.name %> v<%= pkg.version %> * \n' +
                    ' * Changed: <%= grunt.template.date(\"dddd, mmmm dS, yyyy, \'at\' h:MM:ss TT\") %> * \n' +
                    '*/ \n',
                    linebreak: true
                },
                files: {
                    src: [
                        '<%= pkg.csspath %>/application.*',
                        '<%= pkg.jspath %>/application.*'
                    ]
                }
            },

            // Add info to CSS lint report
            // report: {
            //     options: {
            //         position: 'top',
            //         banner: "<%= pkg.name %> | <%= pkg.title %> | v<%= pkg.version %>\n" +
            //         "\n *** AUTO GENERATED FILE ***" +
            //         "Browsers Supported: <%= pkg.config.autoprefixerBrowsers %> \n" +
            //         "\n *** AUTO GENERATED FILE ***",
            //         linebreak: true
            //     },
            //     files: {
            //         src: [
            //             '<%= lintFile %>'
            //         ]
            //     }
            // }
        },

        clean: {
            dist: '<%= pkg.assetspath %>/CSS-Lint-Report/**'
        },

        // Add vendor prefixes to CSS * P.S. Rails gem does this already. Can't hurt to double check..? *
        autoprefixer: {
            options: {
                browsers: '<%= pkg.config.autoprefixerBrowsers %>',
                map: false,
                cascade: true,
                dif: false,
                remove: true,
                safe: false
            },
            css: {
                expand: true,
                flatten: false,
                src: '<%= pkg.csspath %>/*.css'
            },
        },

        // Check that CSS code styles are up to par and there are no obvious mistakes
        // csslint: {
        //     options: {
        //         csslintrc: '<%= pkg.csslintpath %>',
        //         formatters: [
        //           {
        //               id: 'text', dest: '<%= lintFile %>'
        //           }
        //         ]
        //     },
        //     css: [
        //       '<%= pkg.csspath %>/*.css'
        //     ]
        // },

        // Reformat CSS based on code conventions in ./grunt/csscomb.json
        csscomb: {
            options: {
                config: '<%= pkg.csscombpath %>'
            },
            css: {
                expand: true,
                cwd: '<%= pkg.csspath %>/',
                src: [
                    '*.scss',
                    '**/*.scss',
                    '!application.scss',
                    '!*.min.css',
                    '!*.css.map'
                ],
                dest: '<%= pkg.csspath %>/',
                ext: '.scss'
            }
        },

        // Watch for changes on CSS/Scss files and run task
        watch: {
            test: {
                files: [
                    '<%= pkg.csspath %>/**',
                ],
                tasks: ['autoprefixer', 'csscomb']
            }
        }
    });

    // Load all grunt plugins listed in package.json
    require('load-grunt-tasks')(grunt, { scope: 'devDependencies' });

    // CSS Lint
    //grunt.registerTask('lint', ['csslint']);

    // CSS Comb
    grunt.registerTask('comb', ['csscomb']);

    // Default Task
    grunt.registerTask('default');

    // Full Distribution Task.
    grunt.registerTask('dist', ['autoprefixer', 'csscomb', 'concat', 'usebanner']);
};
