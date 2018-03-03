FROM debian:stretch

# Update the repo info
RUN apt-get update

# install and configure supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

# change installation dialogs policy to noninteractive
# otherwise debconf raises errors: unable to initialize frontend: Dialog
ENV DEBIAN_FRONTEND noninteractive

# change policy for starting services while installing
# otherwise policy-rc.d denies execution of start
# http://askubuntu.com/questions/365911/why-the-services-do-not-start-at-installation
# finally the approach is to not start services when building image
# the database will be fead from file, instead of creating tables
# RUN echo "exit 0" > /usr/sbin/policy-rc.d

# install mysql server
RUN apt-get install -y default-mysql-server

#install tango-db
RUN apt-get install -y tango-db

#install tango-test DS
RUN apt-get install -y tango-test

# install taurus dependencies
RUN apt-get install -y python3-numpy \ # OK
                       #python-enum34 \ # non necessario
                       python3-guiqwt \ # OK
                       python3-h5py \   # OK
                       python3-lxml \   # OK
                       python3-pint \   # OK
                       python3-ply \    # OK
                       python3-pytango \# OK
                       #python-qt4 \    # NON TROVATO installazione da sorgente
                       python3-qtpy \    # Probabilmente non va bene
                       python3-pip
                       qt4-dev-tools # forse non serve
                       libqt4-dev
#----SIP ------
#tar xvf sip...
#cd sip
#python3 configure.py
#sudo make
#sudo make install
#---PyQt4------
#tar xvf PyQt4
#cd PyQt4
#python3 configure.py
#sudo make
#sudo make install
#

# installazione sip

#RUN apt-get install python-pip python-qt4
RUN apt-get install
                       #python-qwt5-qt4 \ # NON TROVATO, non c'è per python3
                       python3-spyderlib \ # OK
                       python3-pymca5 \ # OK
                       qt4-designer \ # OK
                       python-sphinx-rtd-theme \ # lasciato stare per ora
                       graphviz # OK
# DA QUA
RUN pip3 install pyqtgraph # OK

# install some utilities
RUN apt-get install -y git \
                       python3-pip \
                       vim \
                       ipython \
                       procps

# instal virtual monitor
RUN apt-get install -y xvfb

# configure virtual monitor env variable
ENV DISPLAY=:1.0

# configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/

# copy & untar mysql tango database and change owner to mysql user
ADD tangodb-tiny.tar /var/lib/mysql/
RUN chown -R mysql /var/lib/mysql/tango

# define tango host env var
ENV TANGO_HOST=taurus-test:10000

# add EPICS repo 
COPY epicsdebs /epicsdebs
COPY epics.list /etc/apt/sources.list.d/
RUN apt-get update

# install epics
RUN apt-get install -y epics-dev

# install pyepics
RUN pip3 install pyepics

# copy test epics IOC database
ADD testioc.db /

# add USER ENV (necessary for spyderlib in taurus.qt.qtgui.editor)
ENV USER=root

# start supervisor as deamon
CMD ["/usr/bin/supervisord"]
