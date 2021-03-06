FROM docker4gis/postgis-gdal:11-3.0.1

RUN apk update; apk add --no-cache \
	python py3-psycopg2 sudo

ENV OGR_FDW_VERSION 1.0.8
COPY conf/ogr_fdw /tmp/ogr_fdw
RUN /tmp/ogr_fdw/install.sh

COPY conf/odbc_fdw /tmp/odbc_fdw
RUN /tmp/odbc_fdw/install.sh

COPY conf/tds /tmp/tds
RUN /tmp/tds/install.sh

COPY conf/plsh /tmp/plsh
RUN /tmp/plsh/install.sh

COPY conf/pgjwt /tmp/pgjwt
RUN /tmp/pgjwt/install.sh

COPY conf/postgres /etc/postgresql

COPY conf/pgxn /tmp/pgxn
RUN /tmp/pgxn/install.sh

COPY conf/safeupdate /tmp/safeupdate
RUN /tmp/safeupdate/install.sh

COPY conf/.plugins/runner /tmp/runner
RUN /tmp/runner/install.sh

COPY conf/.plugins/pg /tmp/pg
RUN /tmp/pg/install.sh

COPY conf/.plugins/mail /tmp/mail
RUN /tmp/mail/install.sh

COPY conf/.plugins/bats /tmp/bats
RUN /tmp/bats/install.sh

COPY conf/entrypoint /entrypoint
COPY conf/init.sh /tmp/init.sh
COPY conf/conf.sh /tmp/conf.sh
COPY conf/onstart.sh /tmp/onstart.sh
COPY conf/subconf.sh /tmp/subconf.sh

COPY conf/util/schema.sh /usr/local/bin/schema.sh

COPY conf/mail /tmp/mail
COPY conf/web /tmp/web

ENTRYPOINT ["/entrypoint"]
CMD ["postgis"]

COPY conf/.docker4gis /.docker4gis
COPY build.sh /.docker4gis/build.sh
COPY run.sh /.docker4gis/run.sh
ONBUILD COPY conf /tmp/conf
ONBUILD RUN touch /tmp/conf/args; \
	cp /tmp/conf/args /.docker4gis
