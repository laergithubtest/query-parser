FROM python:3.6.3-jessie

RUN echo $(python --version)

RUN apt-get update && apt-get install -y git && apt-get install -y python-enchant
RUN apt-get install -y vim

ARG mongo_db_key
ENV MONGODB_KEY=$mongo_db_key

WORKDIR /root

ARG gitusername
ARG gitpassword

#RUN git clone "https://$gitusername:$gitpassword@github.com/laergithubtest/constants.git" && cd /root/constants/python/aida-common && git checkout master && git checkout -b deploy v2018.12.17.6
RUN git clone "https://$gitusername:$gitpassword@github.com/laergithubtest/constants.git" && cd /root/constants && git checkout master

WORKDIR /root/constants/python/aida-common
RUN /bin/bash install_requirements.sh
RUN python install.py

WORKDIR /root
ADD requirements.txt .
RUN pip install -r requirements.txt

WORKDIR /root
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.2.1/wait /wait
RUN chmod +x /wait

COPY code/ /root/query-parser

#EXPOSE 1232
