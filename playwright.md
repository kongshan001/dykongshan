# playwright 浏览器自动化测试

> 浏览器自动化测试首选技能

## 1. 背景需求

Web 应用和游戏的测试需要自动化浏览器操作。

## 2. 目标

提供完整的浏览器自动化测试能力。

## 3. 设计方案

- 多浏览器：Chromium、Firefox、WebKit
- 跨平台：Windows、macOS、Linux
- API 测试：REST、GraphQL
- 移动端模拟：iOS、Android

## 4. 本地部署

```bash
npm install -D @playwright/test
npx playwright install --with-deps
```

## 5. 效果展示

- GitHub Stars：⭐ 1.8k+
- ClawHub 评分：3.538

## 6. 优缺点

✅ 多浏览器支持 ✅ 自动等待 ✅ 录制功能  
⚠️ 资源消耗大 ⚠️ 维护成本高

## 7. 平替

| 工具 | 特点 |
|------|------|
| Cypress | 简单易用 |
| Selenium | 历史悠久 |

## 8. 落地过程

1. 安装 Playwright
2. 编写测试
3. 运行测试
4. 集成 CI/CD
