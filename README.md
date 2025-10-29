<p align="center">
    <img alt="logo" src="readme/logo-chinese.png" height="150" width="150">
</p>
<h1 align="center" style="margin: 30px 0 30px; font-weight: bold;">智碳光伏管理系统</h1>
<p align="center">基于若依框架前后端分离版本</p>
<p align="center">光伏平台后台展示&接口已完全开源，代码完备，功能齐全，运行正常</p>
<p align="center">数采和数据清洗部分网上开源的库很多，学习者可以参考友商集成</p>
<p align="center"><span style="color: red;">通过本项目，学习者可以掌握光伏监测管理行业的功能和业务，以及技术架构。</span></p>
<p align="center">
    <a href='https://gitee.com/wang-xiaoming007/zhitan-pv/stargazers'><img src='https://gitee.com/wang-xiaoming007/zhitan-pv/badge/star.svg?theme=dark' alt='star'></img></a>
    <a href='https://gitee.com/wang-xiaoming007/zhitan-pv/members'><img src='https://gitee.com/wang-xiaoming007/zhitan-pv/badge/fork.svg?theme=dark' alt='fork'></img></a>
</p>

## 平台简介

智碳光伏发电监测管理系统，基于Spring Boot + Vue前后端分离版本。是一种基于物联网、大数据及云计算技术的智能化管理平台，用于实时监控、分析和优化光伏电站的运行状态，旨在提升发电效率、保障系统安全、降低运维成本，并为电站的长期稳定运行提供数据支持。

* 前端采用Vue、Element UI。
* 后端采用Spring Boot、Spring Security、Redis & Jwt。
* 权限认证使用Jwt，支持多终端认证系统。
* 支持加载动态权限菜单，多方式轻松权限控制。
* 高效率开发，使用代码生成器可以一键生成前后端代码。

## 【注意】完整光伏监测管理平台包含三个部分，<span style="color: red;">本仓库只包含光伏监测平台展示端</span>
##### 监测平台展示端：<span style="color: red;">也即本项目光伏平台后台展示部分，代码完备，运行正常。通过本项目，学习者可以掌握光伏监测管理行业的功能和业务，以及技术架构。</span>
##### 数据采集程序：也即mqtt➡️时序库功能，市面上开源库非常多，可参考thingsjs等知名项目，或者自己用netty自己实现。
##### 数据清洗服务：也即时序库➡️关系库，学习者可以使用java自带的XXL job等计划任务工具自己按照业务功能，来实现数据清洗服务。

## 关于问题答疑

#####  因总是有人恶意举报我们仓库，顾我只留下了一个技术交流的微信
#####  我正在把演示demo、logo、截图等也换成了中性的名字，去掉了所有有可能涉及到涉嫌推广的字眼（我们也不知道git被举报的规则是什么。。。）
#####  所以大家如果有更深入的问题，提issue吧。
##

## 在线体验

- guestUser/guest@123456

演示地址：  
https://demo-pv.zhitancloud.com/

## UI展示

![输入图片说明](readme/img/login.png)
首页

![输入图片说明](readme/img/首页.jpg)
首页

![输入图片说明](readme/img/电站实时状态.jpg)
电站实时状态

![输入图片说明](readme/img/电站发电统计.jpg)
电站发电统计

![输入图片说明](readme/img/环比分析.jpg)
环比分析

![输入图片说明](readme/img/同比分析.jpg)
同比分析

![输入图片说明](readme/img/峰平谷-图表统计.jpg)
峰平谷分析

<p>
    <img src="readme/img/小程序-首页.jpg" width="18%">
    <img src="readme/img/小程序-电站监测.jpg" width="18%">
</p>
<p>
    <img src="readme/img/小程序-我的.jpg" width="20%">
    <img src="readme/img/小程序-实时监测.jpg" width="20%">
    <img src="readme/img/小程序-智能报警.jpg" width="20%">>
</p>
    小程序


## 内置功能

### 1. 实时监测
#### 1.1 实时数据
#### 1.2 电站实时状态
#### 1.3 设备实时状态
### 2. 统计分析
#### 2.1 电站发电统计
#### 2.2 设备发电统计
#### 2.3 同比分析
#### 2.4 环比分析
### 3. 尖峰平谷
#### 3.1 图表统计
#### 3.2 报表统计
### 4. 电能质量
#### 4.1 负荷分析
#### 4.2 三相不平衡分析
#### 4.3 功率因数分析
### 5. 智能报警
### 6. 运维管理
#### 6.1 电站管理
#### 6.2 设备管理
#### 6.3 设备类型管理
#### 6.4 设备点检
#### 6.5 备品备件
#### 6.6 峰平谷配置
### 7. 移动端（小程序）
#### 7.1 首页概览
#### 7.2 实时监测
#### 7.3 智能报警


## 后端启动故障排查（CentOS 9）

遇到前端可访问但后端接口无响应时，可以按如下顺序排查：

1. **确认服务进程是否运行**
   ```bash
   sudo systemctl status ruoyi.service
   ```
   - 如果状态为 `inactive`/`failed`，执行 `sudo systemctl restart ruoyi.service` 并观察输出。
   - 未配置 systemd 时，可用 `ps -ef | grep ruoyi-admin.jar` 查看 Java 进程是否存在。

2. **查看系统日志**
   ```bash
   sudo journalctl -u ruoyi.service -n 200 --no-pager
   ```
   - 若使用 `nohup` 启动，请检查启动目录下的 `nohup.out` 或自定义日志文件。
   - 常见报错包括：数据库/Redis 连接失败、端口占用、配置文件缺失等。

3. **确认端口监听情况**
   ```bash
   sudo ss -ltnp | grep 9050
   ```
   - 未发现监听说明服务启动失败。
   - 若端口被占用，可通过 `sudo lsof -i:9050` 定位并释放冲突进程。

4. **验证依赖服务是否正常**
   - MySQL：`mysql -h 127.0.0.1 -P 3306 -u pv -p`
   - Redis：`redis-cli -h 127.0.0.1 -p 6379 ping`
   - InfluxDB（若启用）：`curl http://127.0.0.1:8086/health`

   确保相关服务均已 `systemctl enable --now` 启动，账号密码与 `application-prod.yml` 保持一致。

5. **检查配置文件**
   - 确认 `application-prod.yml` 中的数据库、Redis、上传目录等信息正确。
   - `ruoyi.profile` 指向的目录必须存在且具备读写权限：
     ```bash
     sudo mkdir -p /data/ruoyi/uploadPath
     sudo chown deploy:deploy -R /data/ruoyi
     ```

6. **手动启动以捕获详细日志**
   ```bash
   cd /opt/zhitan-pv/ruoyi-admin/target
   java -jar ruoyi-admin.jar --spring.profiles.active=prod
   ```
   - 观察控制台输出（尤其是异常堆栈）快速定位问题。
   - 确认无误后再恢复 systemd/pm2 等后台运行方式。

7. **重新构建与部署**
   - 当发现 jar 文件缺失或版本过旧时，重新打包：
     ```bash
     mvn -pl ruoyi-admin -am clean package -DskipTests
     ```
   - 更新后执行 `sudo systemctl restart ruoyi.service`。

8. **网络与防火墙检查**
   - 本机验证接口：`curl http://127.0.0.1:9050/prod-api/actuator/health`
   - 若本机正常但外网访问失败，检查 `firewalld`/安全组端口是否放行。

完成上述检查后，一般即可定位并恢复后端服务，随后刷新前端页面即可恢复接口调用。

## 沟通交流。


扫码添加微信交流，加微信请备注：pv+姓名。

<p align="center">
  <img src="readme/img/image.png" width=50% height=50%>
</p>
