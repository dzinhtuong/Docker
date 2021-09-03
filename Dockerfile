FROM ubuntu:18.04

# setup the environment adnd install essental package
RUN apt-get update && \
	apt-get install -y apache2 python-dev python-pip libapache2-mod-wsgi && \
	apt-get clean && \ 
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*


# Copy source to work dir container
COPY . /var/www/flaskapp/

# Run the dependent package to wed app
RUN pip install -r /var/www/flaskapp/requirements.txt

# Enable mod_wsgi and disable default config apache
RUN a2dissite 000-default.conf
RUN a2enmod wsgi

# Set environment Apache
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# Copy new config and enable it
COPY flaskapp.conf /etc/apache2/sites-available/
RUN a2ensite flaskapp.conf

# Expose port
EXPOSE 80

# Set related dir
WORKDIR /var/www/flaskapp

# Set entrypoint to run first
ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["-D", "FOREGROUND"]
