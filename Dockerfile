ARG IMAGE=intersystems/irishealth:2020.1.0.215.0.20264
ARG IMAGE=intersystemsdc/iris-community:2020.1.0.209.0-zpm
FROM $IMAGE

USER root
        
WORKDIR /opt/messagebank
RUN mkdir /ghostdb/ && mkdir /voldata/ && mkdir /voldata/irisdb/ && chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/messagebank /ghostdb/ /voldata/ /voldata/irisdb/
USER ${ISC_PACKAGE_MGRUSER}

COPY Installer.cls .
COPY src src
COPY export.ro /ICS/
COPY iris.script /tmp/iris.script

RUN iris start IRIS \
    && iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly

HEALTHCHECK --interval=10s --timeout=3s --retries=2 CMD wget --timeout 1 --quiet http://localhost:52773/csp/user/cache_status.cxw -O - || exit 1

USER root
COPY v*copy.sh ./
RUN rm -f $ISC_PACKAGE_INSTALLDIR/mgr/alerts.log $ISC_PACKAGE_INSTALLDIR/mgr/IRIS.WIJ $ISC_PACKAGE_INSTALLDIR/mgr/journal/* && cp -Rpf /voldata/* /ghostdb/ && rm -fr /voldata/* \
  && chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/messagebank/v*copy.sh && chmod +x /opt/messagebank/v*copy.sh
CMD ["-b", "/opt/messagebank/vkcopy.sh"]
