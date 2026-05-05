# 执行过程中的陷阱

1. **Puppeteer中文渲染** - 默认Docker镜像缺少中文字体，需安装fonts-noto-cjk
2. **大行程内存** - 超过15天的行程需要分块渲染，否则内存溢出
3. **PDF分页控制** - CSS break-before/break-after在不同渲染引擎行为不一致
