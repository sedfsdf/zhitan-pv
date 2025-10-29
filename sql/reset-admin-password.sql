-- ========================================================================
-- 智碳光伏管理系统 - Admin密码重置SQL脚本
-- ========================================================================
-- 
-- 使用方法:
--   1. 登录MySQL: mysql -u root -p
--   2. 选择数据库: USE pvadmin;
--   3. 执行本脚本: source /path/to/reset-admin-password.sql;
--   或者直接: mysql -u root -p pvadmin < reset-admin-password.sql
--
-- ========================================================================

-- 选择数据库
USE pvadmin;

-- 显示当前admin用户信息
SELECT '========== 重置前admin用户信息 ==========' AS '';
SELECT 
    user_id AS '用户ID',
    user_name AS '用户名',
    nick_name AS '昵称',
    email AS '邮箱',
    phonenumber AS '手机号',
    status AS '状态(0正常1停用)',
    login_ip AS '最后登录IP',
    login_date AS '最后登录时间'
FROM sys_user 
WHERE user_name = 'admin';

-- 重置admin密码为: admin123
-- BCrypt加密值: $2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sLdH62SN4.S6
UPDATE sys_user 
SET password = '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sLdH62SN4.S6',
    status = '0',  -- 确保账户状态为正常
    update_time = NOW()
WHERE user_name = 'admin';

-- 显示更新结果
SELECT '========== 密码重置成功！ ==========' AS '';
SELECT '用户名: admin' AS '';
SELECT '新密码: admin123' AS '';
SELECT '请立即登录系统并修改密码！' AS '';

-- 显示重置后admin用户信息
SELECT '========== 重置后admin用户信息 ==========' AS '';
SELECT 
    user_id AS '用户ID',
    user_name AS '用户名',
    nick_name AS '昵称',
    email AS '邮箱',
    phonenumber AS '手机号',
    status AS '状态(0正常1停用)',
    update_time AS '更新时间'
FROM sys_user 
WHERE user_name = 'admin';

-- ========================================================================
-- 其他常用密码的BCrypt加密值（如需使用，请手动修改上面的UPDATE语句）
-- ========================================================================
-- 密码: admin123
-- BCrypt: $2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE/sLdH62SN4.S6
--
-- 密码: 123456
-- BCrypt: $2a$10$x0SN7Mj8YNFvsjTwWaueHeevIgKwiZKpAg/j.Z7YgcDJLC8g/CDWW
--
-- 密码: admin
-- BCrypt: $2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi
-- ========================================================================

-- 如需重置为其他密码，使用以下模板:
-- UPDATE sys_user 
-- SET password = '这里填入BCrypt加密后的密码',
--     status = '0',
--     update_time = NOW()
-- WHERE user_name = 'admin';
