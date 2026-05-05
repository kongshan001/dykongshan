#!/usr/bin/env python3
"""
AI 项目调研任务：获取 GitHub Trending AI 项目并生成文档
"""

import urllib.request
import json
import os
from datetime import datetime

# 获取 GitHub Trending AI 项目
def get_ai_trending():
    url = "https://api.github.com/search/repositories?q=ai+OR+llm+OR+machine-learning+OR+gpt+created:>2024-01-01&sort=stars&order=desc&per_page=10"
    req = urllib.request.Request(url, headers={"Accept": "application/vnd.github.v3+json"})
    with urllib.request.urlopen(req, timeout=15) as response:
        return json.loads(response.read().decode())

def generate_html_report(repo):
    """生成单个项目的 HTML 报告"""
    name = repo.get("name")
    description = repo.get("description", "暂无描述")
    stars = repo.get("stargazers_count", 0)
    forks = repo.get("forks_count", 0)
    language = repo.get("language", "Unknown")
    topics = repo.get("topics", [])[:8]
    html_url = repo.get("html_url")
    
    def fmt_num(n):
        if n >= 1000:
            return f"{n/1000:.1f}k"
        return str(n)
    
    topics_html = "".join(f'<span class="topic">{t}</span>' for t in topics) if topics else ""
    
    return f'''
    <a href="{html_url}" target="_blank" class="project-card">
      <div class="project-header">
        <h3>{name}</h3>
        <span class="stars">⭐ {fmt_num(stars)}</span>
      </div>
      <p class="desc">{description}</p>
      <div class="meta">
        <span class="lang">💻 {language}</span>
        <span class="forks">🍴 {fmt_num(forks)}</span>
      </div>
      <div class="topics">{topics_html}</div>
    </a>
    '''

def main():
    print(f"[{datetime.now()}] 开始调研 AI 项目...")
    
    try:
        data = get_ai_trending()
        repos = data.get("items", [])[:10]
        
        if not repos:
            print("未获取到项目")
            return
        
        # 生成 HTML
        projects_html = "\n".join(generate_html_report(repo) for repo in repos)
        
        html = f'''<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AI 项目调研 - GitHub Trending</title>
  <style>
    * {{ margin: 0; padding: 0; box-sizing: border-box; }}
    body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.7; color: #24292f; background: #f6f8fa; padding: 20px; }}
    .container {{ max-width: 900px; margin: 0 auto; background: white; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); overflow: hidden; }}
    .header {{ background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%); color: white; padding: 40px; }}
    .header h1 {{ font-size: 1.8em; margin-bottom: 10px; }}
    .header p {{ opacity: 0.95; }}
    .nav {{ background: #f6f8fa; padding: 16px 40px; border-bottom: 1px solid #d0d7de; }}
    .nav a {{ color: #6366f1; text-decoration: none; margin-right: 20px; }}
    .content {{ padding: 40px; }}
    .projects-grid {{ display: grid; gap: 20px; }}
    .project-card {{ display: block; padding: 24px; border: 1px solid #d0d7de; border-radius: 12px; text-decoration: none; color: inherit; transition: all 0.2s; }}
    .project-card:hover {{ border-color: #6366f1; box-shadow: 0 4px 12px rgba(99, 102, 241, 0.15); transform: translateY(-2px); }}
    .project-header {{ display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }}
    .project-header h3 {{ color: #6366f1; font-size: 1.1em; }}
    .stars {{ color: #f59e0b; font-weight: bold; }}
    .desc {{ color: #57606a; font-size: 14px; margin-bottom: 12px; }}
    .meta {{ display: flex; gap: 16px; color: #57606a; font-size: 13px; margin-bottom: 12px; }}
    .topics {{ display: flex; flex-wrap: wrap; gap: 6px; }}
    .topic {{ background: #f3f4f6; padding: 2px 8px; border-radius: 4px; font-size: 12px; color: #57606a; }}
    .footer {{ background: #f6f8fa; padding: 20px; text-align: center; border-top: 1px solid #d0d7de; color: #57606a; font-size: 14px; }}
    .back-link {{ display: inline-block; margin-bottom: 20px; color: #6366f1; text-decoration: none; }}
  </style>
</head>
<body>
  <div class="container">
    <div class="nav">
      <a href="../../pages/research/index">← 返回文档中心</a>
    </div>
    <div class="header">
      <h1>🤖 AI 项目调研</h1>
      <p>GitHub 热门 AI/ML 开源项目排行</p>
    </div>
    <div class="content">
      <a class="back-link" href="../../pages/research/index">← 返回文档中心</a>
      <div class="projects-grid">
        {projects_html}
      </div>
    </div>
    <div class="footer">
      <p>📅 更新于 {datetime.now().strftime("%Y-%m-%d %H:%M")} | 由 AI 助手自动更新</p>
    </div>
  </div>
</body>
</html>'''
        
        # 保存文件
        output_path = "/root/.openclaw/workspace/dykongshan/src/static/research/ai-trending.html"
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(html)
        
        print(f"✅ 生成完成: {output_path}")
        print(f"📊 共获取 {len(repos)} 个项目")
        
    except Exception as e:
        print(f"❌ 错误: {e}")

if __name__ == "__main__":
    main()
