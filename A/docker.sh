#!/bin/bash
# xfcloud


# 脚本需要root权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用 root 用户运行该脚本!"
    exit 1
fi

# 定义一个函数用于检查命令是否成功执行
check_status() {
    if [ $? -ne 0 ]; then
        echo "出错了！脚本将停止执行。"
        exit 1
    fi
}

# 一、安装依赖
echo "安装依赖包..."
yum install -y yum-utils device-mapper-persistent-data lvm2 wget perl
check_status

# 二、更换阿里云的YUM源
echo "更换YUM源为阿里云镜像..."
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
check_status
yum makecache
check_status

# 三、下载阿里云Docker仓库
echo "添加阿里云Docker CE仓库..."
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
check_status

# 四、安装指定版本的Docker
DOCKER_VERSION="20.10.20"
echo "安装Docker ${DOCKER_VERSION}..."
yum install -y docker-ce-${DOCKER_VERSION} docker-ce-cli-${DOCKER_VERSION} containerd.io
check_status

# 五、启动并设置Docker开机启动
echo "启动Docker服务并设置开机启动..."
systemctl start docker
check_status
systemctl enable docker
check_status

# 六、检查Docker是否安装成功
echo "检查Docker版本..."
docker --version
check_status

echo "Docker ${DOCKER_VERSION} 安装完成！"
