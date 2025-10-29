#!/bin/bash

###############################################################################
# 智碳光伏管理系统 - Admin密码重置工具
# 
# 使用方法:
#   chmod +x reset-admin-password.sh
#   ./reset-admin-password.sh
#
# 功能: 将admin账户密码重置为 admin123
###############################################################################

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印标题
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  智碳光伏管理系统 - 密码重置工具${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

# 数据库配置（请根据实际情况修改）
DB_HOST="localhost"
DB_PORT="3306"
DB_NAME="pvadmin"
DB_USER="root"
DB_PASS=""

# 提示用户输入数据库信息
echo -e "${YELLOW}请输入数据库连接信息（直接回车使用默认值）:${NC}"
read -p "数据库主机 [localhost]: " input_host
DB_HOST=${input_host:-$DB_HOST}

read -p "数据库端口 [3306]: " input_port
DB_PORT=${input_port:-$DB_PORT}

read -p "数据库名称 [pvadmin]: " input_db
DB_NAME=${input_db:-$DB_NAME}

read -p "数据库用户 [root]: " input_user
DB_USER=${input_user:-$DB_USER}

read -sp "数据库密码: " input_pass
DB_PASS=$input_pass
echo ""
echo ""

# 密码选项
echo -e "${YELLOW}请选择要重置的密码:${NC}"
echo "1. admin123 (推荐，RuoYi框架默认密码)"
echo "2. 123456"
echo "3. admin"
echo "4. 自定义密码（需要提供BCrypt加密值）"
read -p "请选择 [1-4]: " password_choice

# 根据选择设置密码
case $password_choice in
    1)
        NEW_PASSWORD='$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sLdH62SN4.S6'
        PASSWORD_TEXT="admin123"
        ;;
    2)
        NEW_PASSWORD='$2a$10$x0SN7Mj8YNFvsjTwWaueHeevIgKwiZKpAg/j.Z7YgcDJLC8g/CDWW'
        PASSWORD_TEXT="123456"
        ;;
    3)
        NEW_PASSWORD='$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi'
        PASSWORD_TEXT="admin"
        ;;
    4)
        read -p "请输入BCrypt加密后的密码: " custom_password
        NEW_PASSWORD=$custom_password
        PASSWORD_TEXT="自定义密码"
        ;;
    *)
        echo -e "${RED}无效的选择，使用默认密码 admin123${NC}"
        NEW_PASSWORD='$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sLdH62SN4.S6'
        PASSWORD_TEXT="admin123"
        ;;
esac

echo ""
echo -e "${YELLOW}即将执行以下操作:${NC}"
echo "  - 数据库: $DB_HOST:$DB_PORT/$DB_NAME"
echo "  - 用户: $DB_USER"
echo "  - 重置账户: admin"
echo "  - 新密码: $PASSWORD_TEXT"
echo ""
read -p "确认执行？(y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo -e "${RED}操作已取消${NC}"
    exit 0
fi

# 构建SQL语句
SQL="UPDATE sys_user SET password = '${NEW_PASSWORD}' WHERE user_name = 'admin';"

# 执行SQL
echo ""
echo -e "${YELLOW}正在执行密码重置...${NC}"

if [ -z "$DB_PASS" ]; then
    # 无密码连接
    mysql -h$DB_HOST -P$DB_PORT -u$DB_USER $DB_NAME -e "$SQL" 2>/dev/null
else
    # 有密码连接
    mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS $DB_NAME -e "$SQL" 2>/dev/null
fi

# 检查执行结果
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}=========================================${NC}"
    echo -e "${GREEN}  密码重置成功！${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo ""
    echo -e "${GREEN}登录信息:${NC}"
    echo "  用户名: admin"
    echo "  密码: $PASSWORD_TEXT"
    echo ""
    echo -e "${YELLOW}请立即登录系统并修改密码！${NC}"
    echo ""
else
    echo ""
    echo -e "${RED}=========================================${NC}"
    echo -e "${RED}  密码重置失败！${NC}"
    echo -e "${RED}=========================================${NC}"
    echo ""
    echo -e "${YELLOW}可能的原因:${NC}"
    echo "  1. 数据库连接信息错误"
    echo "  2. MySQL服务未启动"
    echo "  3. 数据库用户权限不足"
    echo "  4. sys_user表不存在或admin用户不存在"
    echo ""
    echo -e "${YELLOW}建议:${NC}"
    echo "  1. 检查MySQL服务: systemctl status mysql"
    echo "  2. 手动测试数据库连接: mysql -h$DB_HOST -u$DB_USER -p"
    echo "  3. 查看错误日志获取详细信息"
    echo ""
    exit 1
fi

# 可选：显示当前admin用户信息
echo -e "${YELLOW}当前admin用户信息:${NC}"
if [ -z "$DB_PASS" ]; then
    mysql -h$DB_HOST -P$DB_PORT -u$DB_USER $DB_NAME -e "SELECT user_id, user_name, nick_name, email, phonenumber, status, create_time FROM sys_user WHERE user_name='admin'\G" 2>/dev/null
else
    mysql -h$DB_HOST -P$DB_PORT -u$DB_USER -p$DB_PASS $DB_NAME -e "SELECT user_id, user_name, nick_name, email, phonenumber, status, create_time FROM sys_user WHERE user_name='admin'\G" 2>/dev/null
fi

echo ""
echo -e "${GREEN}操作完成！${NC}"
