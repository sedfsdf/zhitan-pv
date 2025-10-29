# 智碳光伏管理系统 - Admin账户恢复指南汇总

## 📌 概述

本文档是为帮助您快速找回或重置系统管理员账户密码而创建的汇总指南。

## 🔑 默认管理员账户信息

根据系统配置和RuoYi框架标准，系统的默认管理员账户为：

```
用户名: admin
密码:   admin123
```

这是RuoYi框架的标准默认密码，适用于大多数基于RuoYi框架的项目。

## 📚 相关文档位置

为了方便您查找和使用，我们创建了以下文档和工具：

### 1. 中文说明文档
**文件**: `管理员登录说明.txt`  
**描述**: 简明易懂的中文说明，包含登录信息和快速解决方案  
**适用**: 快速查看登录信息

### 2. 详细登录指南
**文件**: `README_LOGIN.md`  
**描述**: 详细的登录说明和密码重置方法（包含多种方式）  
**适用**: 需要详细了解密码重置步骤

### 3. 快速启动指南
**文件**: `QUICK_START.md`  
**描述**: 完整的系统启动、检查和故障排除指南  
**适用**: 首次部署或系统问题排查

### 4. Shell密码重置脚本
**文件**: `reset-admin-password.sh`  
**描述**: 交互式Shell脚本，一键重置admin密码  
**使用方法**:
```bash
chmod +x reset-admin-password.sh
./reset-admin-password.sh
```
**特点**: 
- 交互式操作，友好提示
- 支持自定义数据库连接信息
- 提供多种密码选项
- 自动验证执行结果

### 5. SQL密码重置脚本
**文件**: `sql/reset-admin-password.sql`  
**描述**: 直接在MySQL中执行的SQL脚本  
**使用方法**:
```bash
mysql -u root -p pvadmin < sql/reset-admin-password.sql
```
**特点**:
- 无需额外工具
- 显示重置前后的用户信息
- 包含常用密码的BCrypt加密值

## 🚀 快速重置密码的三种方法

### 方法1: 使用Shell脚本（推荐）⭐

最简单的方法，适合大多数用户：

```bash
cd /path/to/project
chmod +x reset-admin-password.sh
./reset-admin-password.sh
```

按照提示输入数据库信息，选择要设置的密码即可。

### 方法2: 直接执行SQL

如果您熟悉MySQL操作：

```sql
-- 登录MySQL
mysql -u root -p

-- 选择数据库
USE pvadmin;

-- 重置密码为 admin123
UPDATE sys_user 
SET password = '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sLdH62SN4.S6' 
WHERE user_name = 'admin';

-- 确认结果
SELECT user_name, nick_name, status FROM sys_user WHERE user_name='admin';
```

### 方法3: 使用SQL脚本文件

适合批量操作或自动化场景：

```bash
mysql -u root -p pvadmin < sql/reset-admin-password.sql
```

## 🔐 常用密码的BCrypt加密值

如果您需要手动设置密码，可以使用以下加密值：

| 明文密码 | BCrypt加密值 |
|---------|-------------|
| admin123 | `$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sLdH62SN4.S6` |
| 123456 | `$2a$10$x0SN7Mj8YNFvsjTwWaueHeevIgKwiZKpAg/j.Z7YgcDJLC8g/CDWW` |
| admin | `$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi` |

## 🛠️ 生成自定义BCrypt密码

如果您需要设置其他密码，可以使用以下Java代码生成BCrypt加密值：

```java
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        String password = "your_password_here";
        String encodedPassword = encoder.encode(password);
        System.out.println("原密码: " + password);
        System.out.println("加密后: " + encodedPassword);
    }
}
```

或者使用在线BCrypt生成器（确保使用强度为10）。

## 📋 数据库信息

### 默认配置

- **数据库名**: `pvadmin`
- **用户表**: `sys_user`
- **用户名字段**: `user_name`
- **密码字段**: `password`（BCrypt加密）

### 查看配置

数据库连接配置位于：
```
ruoyi-admin/src/main/resources/application-druid.yml
```

## ⚠️ 重要提示

1. **首次登录后立即修改密码**
   - 登录系统后，点击右上角头像
   - 选择"个人中心"
   - 点击"修改密码"

2. **使用强密码**
   - 至少8位字符
   - 包含大小写字母、数字和特殊字符
   - 避免使用常见密码

3. **定期更换密码**
   - 建议3-6个月更换一次
   - 不要重复使用旧密码

4. **保护密码安全**
   - 不要将密码分享给他人
   - 不要在公共场合输入密码
   - 使用密码管理器记录密码

5. **生产环境注意事项**
   - 禁用或删除测试账号（guestUser）
   - 关闭不必要的端口
   - 启用HTTPS
   - 配置防火墙规则

## 🐛 常见问题排查

### 问题1: 重置密码后仍无法登录

**可能原因**:
- Redis缓存未清除
- 浏览器缓存
- 账户被锁定

**解决方案**:
```bash
# 清除Redis缓存
redis-cli FLUSHALL

# 检查账户状态
mysql -u root -p -e "SELECT user_name, status FROM pvadmin.sys_user WHERE user_name='admin';"
# status应该为'0'（正常），如果是'1'则执行：
mysql -u root -p -e "UPDATE pvadmin.sys_user SET status='0' WHERE user_name='admin';"
```

### 问题2: 数据库连接失败

**检查步骤**:
```bash
# 1. 检查MySQL服务
systemctl status mysql

# 2. 测试数据库连接
mysql -u root -p -e "SHOW DATABASES;"

# 3. 检查pvadmin数据库是否存在
mysql -u root -p -e "USE pvadmin; SHOW TABLES;"
```

### 问题3: admin用户不存在

**解决方案**:
```sql
-- 检查用户是否存在
SELECT * FROM sys_user WHERE user_name='admin';

-- 如果不存在，重新导入SQL初始化脚本
-- 备份现有数据后执行：
source sql/pvadmin1.sql;
```

## 📞 技术支持

如果以上方法都无法解决您的问题：

1. 查看系统日志：
   - `logs/sys-info.log` - 系统日志
   - `logs/sys-error.log` - 错误日志

2. 检查服务状态：
   ```bash
   # 后端服务
   ps -ef | grep ruoyi-admin
   
   # MySQL
   systemctl status mysql
   
   # Redis
   systemctl status redis
   ```

3. 提交Issue到项目仓库

4. 参考若依框架官方文档：http://doc.ruoyi.vip/

## 📖 扩展阅读

- [README.md](./README.md) - 项目总体介绍
- [README_LOGIN.md](./README_LOGIN.md) - 详细登录指南
- [QUICK_START.md](./QUICK_START.md) - 快速启动指南
- [管理员登录说明.txt](./管理员登录说明.txt) - 中文简明说明

## 📝 更新记录

| 日期 | 版本 | 说明 |
|-----|------|------|
| 2025-03-04 | 1.0.0 | 初始版本，创建完整的管理员账户恢复文档体系 |

---

**注意**: 本文档基于RuoYi框架标准和项目实际配置编写。如果您的系统有特殊配置，请根据实际情况调整。

**安全提醒**: 请妥善保管本文档，其中包含系统的敏感信息。在生产环境部署后，建议删除或加密本文档。
