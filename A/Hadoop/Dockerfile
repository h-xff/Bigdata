FROM centos:7.9.2009

RUN mkdir -p /opt/software && mkdir -p /opt/module

#更换国内阿里云yum源
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
RUN yum makecache

#安装语言包
RUN yum -y install kde-l10n-Chinese glibc-common vim
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
RUN echo "LANG=zh_CN.UTF-8" >> /etc/locale.conf

#安装sshd
RUN yum install -y openssh-server openssh-clients vim net-tools lrzsz
RUN sed -i '/^HostKey/'d /etc/ssh/sshd_config
RUN echo 'HostKey /etc/ssh/ssh_host_rsa_key' >> /etc/ssh/sshd_config

#生成ssh-key
RUN ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key

#更改root用户登录密码
RUN echo 'root:123456' | chpasswd

#声明22端口 
EXPOSE 22

CMD [ "/usr/sbin/init"]
