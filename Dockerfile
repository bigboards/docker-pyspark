FROM bigboards/jupyterhub-__arch__

MAINTAINER bigboards <hello@bigboards.io>

RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.4.1-bin-hadoop2.6.tgz | tar -xz -C /opt
RUN cd /opt && ln -s ./spark-1.4.1-bin-hadoop2.6 spark

RUN mkdir /usr/local/share/jupyter/kernels/pyspark
ADD pyspark.kernel /usr/local/share/jupyter/kernels/pyspark/kernel.json

# Install Java.
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  pip3 install jupyter-console

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

RUN mkdir -p /tmp/jupyterhub/spark/local && chmod 777 /tmp/jupyterhub/spark/local
RUN apt-get update \
    && apt-get install build-essential gfortran libatlas-base-dev python-pip python-dev pkg-config libpng-dev libjpeg8-dev libfreetype6-dev \
    && pip install --upgrade pip numpy scipy pandas scikit-learn matplotlib

WORKDIR /srv/jupyterhub/

EXPOSE 8000

CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
