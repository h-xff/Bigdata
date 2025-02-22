#!/bin/bash

# 集群节点列表（直接使用IP或主机名）
ZK_NODES=(
    "master"
    "slave1"
    "slave2"
)

# Zookeeper安装目录（需与各节点一致）
ZOOKEEPER_HOME="/opt/module/zookeeper"
ZK_SCRIPT="/opt/module/zookeeper/bin/zkServer.sh"

# SSH配置
SSH_PORT=22
SSH_TIMEOUT=10

# 辅助函数：执行带环境变量加载的SSH命令
ssh_run() {
    local host=$1
    local command=$2
    # 强制在远程节点加载环境变量
    full_command="source /etc/profile; $command"
    
    echo "[$host] Executing: $full_command"
    
    # 使用无密码登录（生产环境必需）
    # 如果需要密码认证，取消注释下面行并设置SSH_PASSWORD
    # sshpass -p "$SSH_PASSWORD" ssh -o ConnectTimeout=$SSH_TIMEOUT $host "$full_command"
    
    # 无密码登录方式
    ssh -o ConnectTimeout=$SSH_TIMEOUT $host "$full_command" 
    
    # 返回执行结果状态码
    return $?
}

# 启动集群
start() {
    for host in "${ZK_NODES[@]}"; do
        # 执行启动命令（自动加载环境变量）
        if ssh_run $host "$ZK_SCRIPT start"; then
            echo "[$host] Zookeeper started successfully"
        else
            echo "[$host] Failed to start Zookeeper"
            exit 1
        fi
    done
    echo "全部节点已启动"
}

# 停止集群
stop() {
    for host in "${ZK_NODES[@]}"; do
        if ssh_run $host "$ZK_SCRIPT stop"; then
            echo "[$host] Zookeeper stopped successfully"
        else
            echo "[$host] Failed to stop Zookeeper"
            exit 1
        fi
    done
    echo "全部节点已停止"
}

# 查看状态
status() {
    for host in "${ZK_NODES[@]}"; do
        echo "[$host] Zookeeper status:"
        # 执行状态查询（自动加载环境变量）
        ssh_run $host "$ZK_SCRIPT status"
        echo "-----------------------------------------"
    done
}

# 执行命令
case "$1" in
    start) start ;;
    stop) stop ;;
    status) status ;;
    *) echo "Usage: $0 {start|stop|status}" ;;
esac

exit 0
