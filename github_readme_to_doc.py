#!/usr/bin/env python3
"""
GitHub Repo README to Beautiful HTML Document
Usage: python3 github_readme_to_doc.py <owner/repo>
"""

import sys
import json
import base64
import urllib.request
import urllib.parse

def get_repo_info(owner, repo):
    """获取 repo 基本信息"""
    url = f"https://api.github.com/repos/{owner}/{repo}"
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github.v3+json"})
    with urllib.request.urlopen(req, timeout=15) as response:
        return json.loads(response.read().decode())

def get_readme(owner, repo):
    """获取 README 内容"""
    url = f"https://api.github.com/repos/{owner}/{repo}/readme"
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github.v3+json"})
    with urllib.request.urlopen(req, timeout=15) as response:
        data = json.loads(response.read().decode())
        return base64.b64decode(data["content"]).decode("utf-8")

def generate_html(owner, repo, repo_info, readme):
    """生成漂亮的 HTML 文档"""
    
    # 提取关键信息
    name = repo_info.get("name", repo)
    description = repo_info.get("description", "暂无描述")
    stars = repo_info.get("stargazers_count", 0)
    forks = repo_info.get("forks_count", 0)
    watchers = repo_info.get("watchers_count", 0)
    language = repo_info.get("language", "Unknown")
    license_info = repo_info.get("license", {}).get("name", "No License")
    topics = repo_info.get("topics", [])
    html_url = repo_info.get("html_url", f"https://github.com/{owner}/{repo}")
    
    # 格式化数字
    def fmt_num(n):
        if n >= 1000:
            return f"{n/1000:.1f}k"
        return str(n)
    
    # 处理 README 中的图片（相对路径转绝对路径）
    readme = readme.replace("](docs/", f"]({html_url}/docs/")
    readme = readme.replace("](images/", f"]({html_url}/images/")
    readme = readme.replace("](img/", f"]({html_url}/img/")
    readme = readme.replace("](.", f"]({html_url}/blob/main/.")
    readme = readme.replace("](..", f"]({html_url}/blob/main/..")
    
    # 简单 Markdown 转 HTML（基础版）
    import re
    
    # 代码块
    readme = re.sub(r'```(\w+)?\n(.*?)```', r'<pre><code>\2</code></pre>', readme, flags=re.DOTALL)
    readme = re.sub(r'`([^`]+)`', r'<code>\1</code>', readme)
    
    # 标题
    readme = re.sub(r'^### (.+)$', r'<h3>\1</h3>', readme, flags=re.MULTILINE)
    readme = re.sub(r'^## (.+)$', r'<h2>\1</h2>', readme, flags=re.MULTILINE)
    readme = re.sub(r'^# (.+)$', r'<h1>\1</h1>', readme, flags=re.MULTILINE)
    
    # 粗体斜体
    readme = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', readme)
    readme = re.sub(r'\*([^*]+)\*', r'<em>\1</em>', readme)
    
    # 链接
    readme = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', readme)
    
    # 列表
    readme = re.sub(r'^- (.+)$', r'<li>\1</li>', readme, flags=re.MULTILINE)
    readme = re.sub(r'^\* (.+)$', r'<li>\1</li>', readme, flags=re.MULTILINE)
    readme = re.sub(r'^(\d+)\. (.+)$', r'<li>\2</li>', readme, flags=re.MULTILINE)
    
    # 段落
    readme = re.sub(r'\n\n', '</p><p>', readme)
    readme = '<p>' + readme + '</p>'
    
    # 清理空段落
    readme = re.sub(r'<p></p>', '', readme)
    readme = re.sub(r'<p>\s*</p>', '', readme)
    
    topics_html = ""
    if topics:
        topics_html = '<div class="topics">' + ''.join(f'<span class="topic">{t}</span>' for t in topics[:8]) + '</div>'
    
    html = f'''<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{name} - 项目介绍</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.7;
            color: #24292f;
            background: #f6f8fa;
            padding: 20px;
        }}
        .container {{
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            overflow: hidden;
        }}
        .header {{
            background: linear-gradient(135deg, #0969da 0%, #2188ff 100%);
            color: white;
            padding: 40px;
        }}
        .header h1 {{
            font-size: 2.2em;
            margin-bottom: 10px;
        }}
        .header .description {{
            font-size: 1.2em;
            opacity: 0.95;
            margin-bottom: 20px;
        }}
        .stats {{
            display: flex;
            gap: 24px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }}
        .stat {{
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 15px;
        }}
        .stat svg {{ width: 18px; height: 18px; fill: currentColor; }}
        .topics {{
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }}
        .topic {{
            background: rgba(255,255,255,0.2);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
        }}
        .meta {{
            background: #f6f8fa;
            padding: 16px 40px;
            border-bottom: 1px solid #d0d7de;
            display: flex;
            gap: 24px;
            flex-wrap: wrap;
            font-size: 14px;
            color: #57606a;
        }}
        .meta-item {{
            display: flex;
            align-items: center;
            gap: 6px;
        }}
        .content {{
            padding: 40px;
        }}
        .content h1, .content h2, .content h3 {{
            margin: 1.5em 0 0.8em;
            color: #24292f;
        }}
        .content h1 {{ font-size: 1.8em; border-bottom: 1px solid #d0d7de; padding-bottom: 0.3em; }}
        .content h2 {{ font-size: 1.5em; }}
        .content h3 {{ font-size: 1.25em; }}
        .content p {{ margin: 1em 0; }}
        .content ul, .content ol {{
            margin: 1em 0;
            padding-left: 2em;
        }}
        .content li {{ margin: 0.4em 0; }}
        .content pre {{
            background: #f6f8fa;
            border: 1px solid #d0d7de;
            border-radius: 6px;
            padding: 16px;
            overflow-x: auto;
            margin: 1em 0;
        }}
        .content code {{
            font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, monospace;
            font-size: 0.9em;
        }}
        .content a {{
            color: #0969da;
            text-decoration: none;
        }}
        .content a:hover {{ text-decoration: underline; }}
        .footer {{
            background: #f6f8fa;
            padding: 20px 40px;
            text-align: center;
            border-top: 1px solid #d0d7de;
        }}
        .btn {{
            display: inline-block;
            background: #0969da;
            color: white;
            padding: 10px 24px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
        }}
        .btn:hover {{ background: #0a7fed; text-decoration: none; }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>{name}</h1>
            <p class="description">{description}</p>
            <div class="stats">
                <span class="stat">⭐ {fmt_num(stars)}</span>
                <span class="stat">🍴 {fmt_num(forks)}</span>
                <span class="stat">👁 {fmt_num(watchers)}</span>
            </div>
            {topics_html}
        </div>
        <div class="meta">
            <span class="meta-item">📝 {language}</span>
            <span class="meta-item">📜 {license_info}</span>
            <span class="meta-item">🔗 <a href="{html_url}" style="color:inherit">{owner}/{repo}</a></span>
        </div>
        <div class="content">
            {readme}
        </div>
        <div class="footer">
            <a href="{html_url}" class="btn">查看 GitHub 原始仓库 →</a>
        </div>
    </div>
</body>
</html>'''
    
    return html

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 github_readme_to_doc.py <owner/repo>")
        print("Example: python3 github_readme_to_doc.py facebook/react")
        sys.exit(1)
    
    owner_repo = sys.argv[1].strip().strip('/')
    if '/' not in owner_repo:
        print("Error: 请使用格式 owner/repo")
        sys.exit(1)
    
    owner, repo = owner_repo.split('/', 1)
    
    print(f"📥 正在获取 {owner}/{repo} 的信息...")
    
    try:
        repo_info = get_repo_info(owner, repo)
        readme = get_readme(owner, repo)
        
        html = generate_html(owner, repo, repo_info, readme)
        
        # 保存文件
        filename = f"{owner}-{repo}.html"
        with open(filename, 'w', encoding='utf-8') as f:
            f.write(html)
        
        print(f"✅ 生成完成！")
        print(f"📄 文件: {filename}")
        print(f"⭐ Stars: {repo_info.get('stargazers_count', 0)}")
        print(f"📝 语言: {repo_info.get('language', 'Unknown')}")
        
    except Exception as e:
        print(f"❌ 错误: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
