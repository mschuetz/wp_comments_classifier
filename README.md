wp_comments_classifier
======================

I wrote this utility because I was unable to find a working spam filter for wordpress.
It uses rdbi to connect to a variety of databases which also means that you need to install the approprivate database driver manually as I haven't specified them as package dependencies.
I.e. after you've determined what database you're using:
	gem install rdbi-driver-(mysql|postgresql|sqlite3)

Then create a configuration like the following:
	{
		"rdbi_driver": "MySQL",
		"classifier_debug": false,
		"host": "localhost",
		"username": "user",
		"password": "password",
		"database": "databasename"
	}

and run
	classify_wp_comments config.json