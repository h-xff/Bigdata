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

# 一、下载指定版本的内核
echo "下载内核版本 5.4.226..."
wget http://mirrors.coreix.net/elrepo-archive-archive/kernel/el7/x86_64/RPMS/kernel-lt-5.4.226-1.el7.elrepo.x86_64.rpm
check_status

# 二、安装内核
echo "安装下载的内核..."
rpm -ivh kernel-lt-5.4.226-1.el7.elrepo.x86_64.rpm
check_status

# 三、查看当前安装的内核版本，如果是5.4的话就继续，如果不是则结束并提示错误
current_kernel=$(rpm -qa | grep kernel | grep -E "kernel-lt|kernel" | sort | tail -n 1)
echo "当前安装的内核版本：$current_kernel"

if [[ "$current_kernel" == *"5.4"* ]]; then
    echo "内核版本 5.4 安装成功，继续设置默认内核..."
else
    echo "安装的内核版本不是 5.4，脚本将停止执行。"
    exit 1
fi

# 四、查看当前启动内核顺序，将5.4设置为第一个
echo "查看当前启动内核顺序..."
cat /etc/grub2.cfg | grep menuentry | awk -F "\'" '{print $2}'

echo "将内核 5.4 设置为默认启动内核..."
grub2-set-default 0
check_status

# 五、提示用户重启系统以启用新内核
echo "内核升级完成，系统将在重启后生效。请手动重启服务器以启用新内核,reboot。"

