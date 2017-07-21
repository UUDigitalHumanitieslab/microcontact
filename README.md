Microcontact
============

Configuration
-------------
There are default settings in `microcontact.settings`. It is recommended that you take some time to review these settings and override them where necessary, especially for production use. See the "Database" section below for comments on the `DATABASES` setting in particular.

For local development use, create a Python module in the project root that starts with `from microcontact.settings import *` and then selectively override settings. Your file will be automatically ignored by git if you call it `config.py`.

For production use, copy `microcontact/settings.py` to a separate file. Put this file elsewhere in the filesystem under restrictive access rights, then modify its contents. There are many settings that need to be overridden because of security considerations; please see the comments.

In either case, set the environment variable `DJANGO_SETTINGS_MODULE` to the path to your customized settings module in order to use it. For documentation, see the [Django documentation on settings][1].

Google Maps API key
-------------------
You need to obtain an API key for Google Maps in order for the frontend application to work. Save the key (with nothing else) in a file named `.gmapikey` in the project root directory. This file is ignored by Git.

Dependencies
------------
For the Python dependencies, create a Python 3 virtualenv and activate it. `pip install pip-tools` and then run `pip-sync`. For local development purposes, also `pip install pytest`.
Some dependencies might require `python-dev` to be installed first (primarly for Anaconda3 users).
Try either:
`sudo apt-get install python-dev`
or
`sudo apt-get install python3-dev`.
For the JavaScript dependencies, install NPM, Bower and Grunt, then run `npm install` and `bower install`. For deployment, you can run `bower install` with the `--production` flag in order to skip development-only packages.

For audio conversion, get ffmpeg. See instructions for Windows, OS X and Ubuntu [here][21].

Database
--------
The default configuration in `microcontact.settings` assumes a SQLite database. This is also the only database backend supported by the `requirements.txt`. If you choose a different backend, you will need to install additional libraries. For PostgreSQL, which we recommend, use `pip install psycopg2`. For most backends, including PostgreSQL, you will also need to create a dedicated database and a dedicated user with all privileges on that database. See the [Django settings reference][2] for instructions on setting `DATABASES`.

In order to bootstrap your local database before first running the application, run `python manage.py migrate`. Run this command again after defining new migrations. In order to define a new migration (after modifying the database schema), run `python manage.py makemigrations` and edit the generated file. See the [Django documentation on migrations][14] for details.

Local development
-----------------
Make sure that your virtual environment is activated, then run `grunt`. This will do many things:

  - Compile the CoffeeScript, Sass and Mustache sources to browser-ready static assets (these are hidden in `/.tmp` under the project root).
  - Run all unit tests once (this relies on you having installed `pytest`).
  - Run the Django-based backend server on port 5000.
  - Serve the static asserts on port 8000 through a Node.js `connect` server.
  - Forward all requests under `localhost:8000/api/` to `localhost:5000/`.
  - Open `localhost:8000/` (`/.tmp/index.html`) in your default browser (henceforth the "development browser tab").
  - Watch all sources for changes, automatically recompiling static assets, re-running unit tests and reloading the development browser tab where applicable.
  - Recompile and rerun the functional tests when changed. Note that the functional tests are not automatically rerun when you change source files. Functional tests are further discussed below.

All subprocesses log to the same single terminal that you run `grunt` from, so the output will be a mess at first. After that, however, you will be grateful for the combined output, as any server hiccups, test failures and compilation errors will automatically come to your attention from a single window. This process keeps running until you kill it with `ctrl-c`.

At your option, you may also run any of the tasks above separately. The required commands are listed below with pointers to further documentation. Refer to the `Gruntfile.coffee` for the definitions and configuration of the Grunt-based tasks.

  - `grunt handlebars` to precompile all Mustache templates except for the `index.mustache` to a single `templates.js` ([grunt-contrib-handlebars][13]).
  - `grunt coffee` to compile all CoffeeScript sources to JavaScript ([grunt-contrib-coffee][3]). `grunt coffee:compile` to limit compilation to the client side scripts or `grunt coffee:functional` to limit compilation to the functional tests.
  - `grunt newer:coffee`, `grunt newer:coffee:compile` or `grunt newer:coffee:functional` to do the same but only with changed sources ([grunt-newer][15]).
  - `grunt clean:develop compile-handlebars:develop` to generate the `index.html` ([grunt-compile-handlebars][4]). The `clean` step is necessary because `compile-handlebars` appends to output files instead of replacing them.
  - `grunt sass postcss` to compile the stylesheets from Sass to CSS ([grunt-sass][18], [grunt-postcss][19]).
  - `grunt symlink` to ensure that the `/bower_components` are accessible from within the `/.tmp` ([grunt-contrib-symlink][6]).
  - `grunt compile` to do all of the above.
  - `python manage.py runserver 5000` to run just the backend server ([django-admin][12]). Keeps running.
  - `grunt connect:develop:keepalive` to serve just the static assets and open the index in your default browser ([grunt-contrib-connect][7], [http-proxy][8]). Be warned that it will still forward requests under `/api` to `localhost:5000`. Keeps running.
  - `grunt concurrent:server` to run both servers at the same time ([grunt-concurrent][9]). Keeps running.
  - `grunt watch` to automatically recompile, retest and reload when files change ([grunt-contrib-watch][10]). This includes the functional tests as described above. Note that if you start the static server before the watch task, livereload will not work until you manually refresh the development browser tab. Keeps running.
  - `grunt casperjs` to run all functional tests. This assumes that you already compiled the CoffeeScript sources. ([grunt-casperjs][16], [CasperJS][17])
  - `grunt newer:casperjs` to run only the functional tests that you edited and recompiled.

In order to remove generated files but not the `node_modules` or the `bower_components`, run `grunt clean:all` ([grunt-contrib-clean][11]).

If you want to verify the optimized assets (see below) during development, you can run a frontend server that serves from `/dist` instead of `/.tmp`. If you already have a backend server running, use `grunt connect:dist:keepalive`, otherwise use `grunt concurrent:dist`. The optimized assets server runs on port 8080 instead of port 8000, so you can run it alongside the development assets server.

Deployment
----------
An optimized version of the static assets can be obtained by running `grunt dist`. The optimized files are put in the `/dist` project subdirectory. In this case you do not need the `bower_components`; the external libraries are fetched from CDNs in their minified forms.

You are advised to run the Django-based backend as a WSGI application from your favourite HTTP server. See [Deploying Django][20].

Serve the WSGI application under `/api/` while serving the static assets under `/`.

####LDAP

#####Linux
On linux make sure that the following packages are installed:
libsasl2-dev, python-dev, libldap2-dev, libssl-dev

Directory reference
-------------------

    project root                 (whatever you called it)
    ├── .editorconfig            notation conventions, in-VCS
    ├── .functional-tests        functional tests compiled to JS, out-of-VCS
    ├── .gitignore
    ├── .tmp/                    generated static assets for dev., out-of-VCS
    ├── Gruntfile.coffee         task configuration, in-VCS
    ├── README.md                this file, in-VCS
    ├── bower.json               listing of JS deps, in-VCS
    ├── bower_components/        JS deps during development, out-of-VCS
    ├── client                   static asset sources, in-VCS
    │   ├── script
    │   │   ├── *.coffee
    │   │   └── *_test.coffee    unit tests belonging to *.coffee
    │   ├── style/
    │   └── template/
    ├── config.py                presumed to be written by you, out-of-VCS
    ├── dist/                    generated static assets for depl., out-of-VCS
    ├── functional-tests         functional test sources in Coffee, in-VCS
    ├── manage.py                backend manager, in-VCS
    ├── microcontact             the Django project package, in-VCS
    │   ├── *.py
    │   └── *_test.py            unit tests belonging to *.py
    ├── node_modules/            Node and Grunt dependencies, out-of-VCS
    ├── package.json             listing of Node/Grunt deps, in-VCS
    ├── requirements.in          top-level Python package requirements, in-VCS
    └── requirements.txt         generated pinned requirements, in-VCS


(c) 2016 Julian Gonggrijp
(c) 2017 Digital Humanities Lab, Utrecht University


[1]: https://docs.djangoproject.com/en/1.8/topics/settings/
[2]: https://docs.djangoproject.com/en/1.8/ref/settings/#databases
[3]: https://www.npmjs.com/package/grunt-contrib-coffee
[4]: https://www.npmjs.com/package/grunt-compile-handlebars
[6]: https://www.npmjs.com/package/grunt-contrib-symlink
[7]: https://www.npmjs.com/package/grunt-contrib-connect
[8]: https://www.npmjs.com/package/http-proxy
[9]: https://www.npmjs.com/package/grunt-concurrent
[10]: https://www.npmjs.com/package/grunt-contrib-watch
[11]: https://www.npmjs.com/package/grunt-contrib-clean
[12]: https://docs.djangoproject.com/en/1.8/ref/django-admin/
[13]: https://www.npmjs.com/package/grunt-contrib-handlebars
[14]: https://docs.djangoproject.com/en/1.8/topics/migrations/
[15]: https://www.npmjs.com/package/grunt-newer
[16]: https://www.npmjs.com/package/grunt-casperjs
[17]: http://docs.casperjs.org/
[18]: https://www.npmjs.com/package/grunt-sass
[19]: https://www.npmjs.com/package/grunt-postcss
[20]: https://docs.djangoproject.com/en/1.8/howto/deployment/
[21]: https://github.com/adaptlearning/adapt_authoring/wiki/installing-ffmpeg
