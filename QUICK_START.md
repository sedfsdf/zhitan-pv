# 智碳光伏管理系统 - 快速启动指南

## 📋 目录
- [系统概述](#系统概述)
- [管理员登录](#管理员登录)
- [系统架构](#系统架构)
- [部署检查](#部署检查)
- [常见问题](#常见问题)

## 系统概述

智碳光伏管理系统是基于RuoYi框架（Spring Boot + Vue）开发的光伏发电监测管理平台。

- **后端技术**: Spring Boot 2.5、Spring Security、JWT、MyBatis、Redis、MySQL
- **前端技术**: Vue 3、Vite、Element Plus、Pinia、ECharts
- **时序数据库**: InfluxDB
- **数据库**: MySQL 8.0+

## 管理员登录

### 默认账户信息

系统预置了以下账户供您登录：

| 账户类型 | 用户名 | 密码 | 说明 |
|---------|--------|------|------|
| **超级管理员** | `admin` | `admin123` | 拥有所有权限，可管理整个系统 |
| 访客账户 | `guestUser` | `guest@123456` | 仅有查看权限 |

### 登录地址

- **前端登录页面**: `http://your-server-ip:80` 或 `http://your-domain.com`
- **后端API接口**: `http://your-server-ip:8080`
- **Swagger文档**: `http://your-server-ip:8080/swagger-ui.html` (开发环境)

### 登录步骤

1. 打开浏览器，访问系统前端地址
2. 输入用户名：`admin`
3. 输入密码：`admin123`
4. 输入验证码（系统自动生成的数学计算题）
5. 点击"登录"按钮

### 忘记密码？

如果默认密码无法登录，请参考 [README_LOGIN.md](./README_LOGIN.md) 文档进行密码重置。

## 系统架构

### 项目模块

```
zhitan-pv
├── ruoyi-admin          # Web服务入口模块
├── ruoyi-framework      # 框架核心（安全、配置、工具）
├── ruoyi-system         # 系统业务模块（光伏、设备、监测、统计、报警）
├── ruoyi-quartz         # 定时任务模块
├── ruoyi-generator      # 代码生成模块
├── ruoyi-common         # 公共工具模块
├── ruoyi-vue            # Vue3前端项目
└── sql                  # 数据库初始化脚本
```

### 核心功能

1. **实时监测** - 实时数据、电站状态、设备状态监控
2. **统计分析** - 发电统计、同比环比分析
3. **尖峰平谷** - 电价分时统计与图表
4. **电能质量** - 负荷、三相不平衡、功率因数分析
5. **智能报警** - 设备故障预警与报警管理
6. **运维管理** - 电站、设备、点检、备件管理
7. **移动端** - 微信小程序支持

## 部署检查

### 1. 检查后端服务状态

```bash
# 检查Java进程
ps -ef | grep ruoyi-admin

# 检查端口占用
netstat -tunlp | grep 8080
```

### 2. 检查数据库连接

```bash
# 登录MySQL
mysql -u root -p

# 检查数据库
SHOW DATABASES;
USE pvadmin;
SHOW TABLES;

# 检查admin用户
SELECT user_id, user_name, nick_name, status FROM sys_user WHERE user_name='admin';
```

### 3. 检查Redis服务

```bash
# 检查Redis服务状态
systemctl status redis
# 或
redis-cli ping  # 应该返回 PONG
```

### 4. 检查前端服务

```bash
# 检查Nginx状态（如果使用Nginx）
systemctl status nginx

# 检查80端口
netstat -tunlp | grep 80
```

### 5. 查看系统日志

```bash
# 查看后端日志
tail -f logs/sys-info.log
tail -f logs/sys-error.log

# 查看Nginx访问日志（如果使用）
tail -f /var/log/nginx/access.log
```

## 常见问题

### Q1: 无法访问系统页面？

**检查清单**:
- [ ] 确认服务器防火墙已开放80和8080端口
- [ ] 确认后端服务已启动（检查8080端口）
- [ ] 确认前端服务已启动（检查80端口）
- [ ] 尝试访问：`http://localhost:8080/swagger-ui.html` 测试后端

**解决方案**:
```bash
# 开放防火墙端口（CentOS/RHEL）
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

# Ubuntu/Debian
ufw allow 80/tcp
ufw allow 8080/tcp
```

### Q2: 登录后提示"登录超时，请重新登录"？

**原因**: Redis服务未启动或连接失败

**解决方案**:
```bash
# 启动Redis
systemctl start redis
systemctl enable redis

# 检查Redis配置
# 编辑 ruoyi-admin/src/main/resources/application.yml
# 确认 spring.redis.host 和 spring.redis.port 配置正确
```

### Q3: 数据库连接失败？

**检查配置文件**:
```bash
# 查看数据库配置
cat ruoyi-admin/src/main/resources/application-druid.yml
```

**修正配置**:
```yaml
spring:
  datasource:
    druid:
      master:
        url: jdbc:mysql://localhost:3306/pvadmin?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
        username: root
        password: your_mysql_password
```

### Q4: 登录验证码不显示？

**原因**: 前端无法连接后端API

**解决方案**:
1. 检查后端是否正常运行
2. 检查前端配置文件中的API地址
3. 浏览器F12查看Network，确认验证码请求是否成功

### Q5: 前端能访问但看不到数据？

**可能原因**:
- 数据库中没有数据
- 权限配置问题
- InfluxDB未配置或数据未采集

**解决方案**:
1. 先检查是否能登录系统
2. 登录后检查"系统管理"→"菜单管理"是否有数据
3. 检查数据库表中是否有初始数据

## 系统配置文件位置

| 配置项 | 文件路径 |
|-------|---------|
| 后端主配置 | `ruoyi-admin/src/main/resources/application.yml` |
| 数据库配置 | `ruoyi-admin/src/main/resources/application-druid.yml` |
| 前端环境配置 | `ruoyi-vue/.env.development` / `.env.production` |
| Redis配置 | `application.yml` → `spring.redis` |

## 密码安全

### 首次登录后必做

1. **修改默认密码**
   - 登录系统
   - 点击右上角头像 → 个人中心
   - 点击"修改密码"
   - 输入新密码并保存

2. **禁用访客账户**（生产环境）
   ```sql
   -- 停用访客账户
   UPDATE sys_user SET status = '1' WHERE user_name = 'guestUser';
   ```

3. **设置强密码策略**
   - 至少8位字符
   - 包含大小写字母、数字和特殊字符
   - 定期更换密码（建议3-6个月）

## 技术支持

如果您在部署或使用过程中遇到问题：

1. 查看项目文档：[README.md](./README.md)
2. 查看登录指南：[README_LOGIN.md](./README_LOGIN.md)
3. 查看系统日志文件
4. 在GitHub/Gitee提交Issue
5. 联系技术支持（见README.md）

## 相关文档

- [README.md](./README.md) - 项目介绍
- [README_LOGIN.md](./README_LOGIN.md) - 详细登录和密码重置指南
- [若依官方文档](http://doc.ruoyi.vip/) - RuoYi框架文档

---

**提示**: 本系统基于若依(RuoYi)框架开发，更多框架相关问题可参考若依官方文档。
