FROM kbase/kbase:sdkbase.latest
MAINTAINER KBase Developer
# -----------------------------------------

# Insert apt-get instructions here to install
# any required dependencies for your module.

# RUN apt-get update

# -----------------------------------------

COPY ./ /kb/module
RUN mkdir -p /kb/module/work
RUN chmod -R 777 /kb/module

RUN add-apt-repository ppa:openjdk-r/ppa \
	&& sudo apt-get update \
	&& sudo apt-get -y install openjdk-8-jdk \
	&& echo java versions: \
	&& java -version \
	&& javac -version \
	&& echo $JAVA_HOME \
	&& ls -l /usr/lib/jvm \
	&& cd /kb/runtime \
	&& rm java \
	&& ln -s /usr/lib/jvm/java-8-openjdk-amd64 java \
	&& ls -l

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

WORKDIR /kb/module

# get most up to date jars, note will be cached so change this RUN to update
RUN cd /kb/dev_container/modules/jars \
    && git pull \
    && . /kb/dev_container/user-env.sh \
    && make deploy \
    && echo "this is only here to force an update: 1"

RUN make all

ENTRYPOINT [ "./scripts/entrypoint.sh" ]

CMD [ ]
