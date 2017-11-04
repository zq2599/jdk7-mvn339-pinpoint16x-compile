# Docker image of compile and build pinpoint 1.6.x
# VERSION 0.0.1
# Author: bolingcavalry

#基础镜像使用kinogmt/centos-ssh:6.7，支持ssh登录
FROM kinogmt/centos-ssh:6.7

#作者
MAINTAINER BolingCavalry <zq2599@gmail.com>

#定义工作目录
ENV WORK_PATH /usr/local/work

#定义jdk1.7的文件名
ENV JDK_RPM_FILE jdk-7u71-linux-x64.rpm

#定义JAVA_HOME
ENV JAVA_HOME /usr/java/jdk1.7.0_71

#定义编译pinpoint所需的环境变量
ENV JAVA_6_HOME $JAVA_HOME

#定义编译pinpoint所需的环境变量
ENV JAVA_7_HOME $JAVA_HOME

#定义编译pinpoint所需的环境变量
ENV JAVA_8_HOME $JAVA_HOME

#定义maven文件夹名称
ENV MAVEN_PACKAGE_NAME apache-maven-3.3.9

#把maven的bin加入PATH
ENV PATH $PATH:$WORK_PATH/$MAVEN_PACKAGE_NAME/bin

#定义pinpoint文件夹名称
ENV PINPOINT_PACKAGE_NAME pinpoint-1.6.x

#定义maven本地仓库路径
ENV MAVEN_REPOSITORY_PATH /root/.m2

#定义maven本地仓库文件夹名称
ENV MAVEN_REPOSITORY_PACKAGE_NAME repository


#创建工作目录
RUN mkdir -p $WORK_PATH

#yum更新
#RUN yum -y update

#把分割过的jdk1.7安装文件复制到工作目录
COPY ./jdkrpm-* $WORK_PATH/

#用本地分割过的文件恢复原有的jdk1.7的安装文件
RUN cat $WORK_PATH/jdkrpm-* > $WORK_PATH/$JDK_RPM_FILE

#本地安装jdk1.7，如果不加后面的yum clean all，就会报错：Rpmdb checksum is invalid
RUN yum -y localinstall $WORK_PATH/$JDK_RPM_FILE; yum clean all

#把maven文件夹复制到工作目录
COPY ./$MAVEN_PACKAGE_NAME $WORK_PATH/$MAVEN_PACKAGE_NAME

#把pinpoint文件夹复制到工作目录
COPY ./$PINPOINT_PACKAGE_NAME $WORK_PATH/$PINPOINT_PACKAGE_NAME

#创建maven仓库的目录
RUN mkdir -p $MAVEN_REPOSITORY_PATH

#把maven仓库文件夹复制到本地仓库
COPY ./$MAVEN_REPOSITORY_PACKAGE_NAME $MAVEN_REPOSITORY_PATH/$MAVEN_REPOSITORY_PACKAGE_NAME

#删除分割文件
RUN rm $WORK_PATH/jdkrpm-*

#删除jdk安装包文件
RUN rm $WORK_PATH/$JDK_RPM_FILE