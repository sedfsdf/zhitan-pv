# 智碳光伏管理系统 - 管理员登录指南

## 默认管理员账户

### 方式一：使用默认管理员账户登录

根据项目配置，系统提供了以下默认账户：

#### 管理员账户（admin）
- **用户名**: `admin`
- **密码**: `admin123`（RuoYi框架默认密码）
- **角色**: 系统管理员（拥有所有权限）

#### 访客账户（guestUser）
- **用户名**: `guestUser`  
- **密码**: `guest@123456`
- **角色**: 普通用户（查看权限）

### 方式二：如果默认密码无法登录

如果您的系统已经修改过密码或者默认密码无法登录，请按照以下步骤重置密码：

## 重置Admin密码的方法

### 方法1：通过数据库直接重置密码

系统使用BCrypt加密算法存储密码。您可以通过以下SQL语句将admin密码重置为 `admin123`：

```sql
-- 将admin密码重置为：admin123
UPDATE sys_user 
SET password = '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sLdH62SN4.S6' 
WHERE user_name = 'admin';
```

执行步骤：
1. 登录到MySQL数据库服务器
2. 选择pvadmin数据库：`USE pvadmin;`
3. 执行上述SQL语句
4. 使用 `admin/admin123` 登录系统

### 方法2：重置为其他自定义密码

如果您想设置其他密码，可以使用以下SQL（示例为重置为 `123456`）：

```sql
-- 将admin密码重置为：123456
UPDATE sys_user 
SET password = '$2a$10$x0SN7Mj8YNFvsjTwWaueHeevIgKwiZKpAg/j.Z7YgcDJLC8g/CDWW' 
WHERE user_name = 'admin';
```

常用密码的BCrypt加密值：

| 密码 | BCrypt加密值 |
|------|-------------|
| admin123 | $2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sLdH62SN4.S6 |
| 123456 | $2a$10$x0SN7Mj8YNFvsjTwWaueHeevIgKwiZKpAg/j.Z7YgcDJLC8g/CDWW |
| admin | $2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi |

### 方法3：使用Java代码生成BCrypt密码

如果需要生成其他密码的BCrypt加密值，可以使用以下Java代码：

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

## 登录地址

- 前端访问地址：`http://your-server-ip:80` 或 `http://your-domain.com`
- 后端接口地址：`http://your-server-ip:8080` 

## 数据库连接信息

如需直接操作数据库，请查看配置文件：

```bash
# 查看数据库配置
cat ruoyi-admin/src/main/resources/application-druid.yml
```

默认数据库信息通常为：
- 数据库名：`pvadmin`
- 用户表：`sys_user`
- 用户名字段：`user_name`
- 密码字段：`password`

## 常见问题

### Q1: 登录提示"用户不存在/密码错误"怎么办？
**A**: 
1. 首先确认数据库中sys_user表是否有admin用户
2. 尝试使用上述SQL重置密码
3. 检查系统日志是否有错误信息

### Q2: 密码重置后还是无法登录？
**A**: 
1. 确认数据库连接正常
2. 清除浏览器缓存和Cookies
3. 检查Redis缓存是否正常
4. 查看后端日志 `logs/sys-info.log`

### Q3: 如何修改密码？
**A**: 
登录成功后，点击右上角头像 → 个人中心 → 修改密码

## 安全建议

1. **首次登录后立即修改默认密码**
2. 使用强密码（包含大小写字母、数字、特殊字符）
3. 定期更换密码
4. 不要将admin密码分享给不必要的人员
5. 生产环境建议关闭或删除测试账号（guestUser）

## 技术支持

如果以上方法都无法解决问题，请：
1. 检查系统日志文件
2. 查看数据库连接状态
3. 提交issue到项目仓库
4. 联系技术支持（参考README.md中的联系方式）

---

**注意**: 此文档基于RuoYi框架和系统SQL初始化脚本生成，实际密码可能因部署环境而异。
