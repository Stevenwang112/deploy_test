# my-webapp

用于练习 Linux 部署的示例项目：Flask + Gunicorn + Nginx + Docker Compose。

## 目录结构

```
my-webapp/
├── app/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── nginx/
│   └── default.conf
├── docker-compose.yml
├── build.sh
└── deploy.sh
```

## 本地快速体验

```bash
cd my-webapp
chmod +x build.sh deploy.sh
./deploy.sh
curl http://127.0.0.1:8080/
```

## Git 部署（推荐练习路径）

### 一、Mac：初始化并推到 GitHub

```bash
cd my-webapp
git init
git add .
git commit -m "Initial commit: Flask + Docker deploy"
```

在 GitHub 新建空仓库（不要勾选 README），然后：

```bash
git branch -M main
git remote add origin https://github.com/<你的用户名>/<仓库名>.git
git push -u origin main
```

### 二、Ubuntu：首次克隆并部署

```bash
# 安装依赖
sudo apt update
sudo apt install -y git docker.io docker-compose-v2
sudo usermod -aG docker $USER
# 注销再登录，或 newgrp docker

sudo mkdir -p /opt/my-webapp
sudo chown $USER:$USER /opt/my-webapp
git clone https://github.com/<你的用户名>/<仓库名>.git /opt/my-webapp

cd /opt/my-webapp
chmod +x build.sh deploy.sh
./deploy.sh
```

防火墙（若启用 ufw）：

```bash
sudo ufw allow 8080/tcp
```

浏览器访问：`http://<Ubuntu-IP>:8080/`

### 三、日常更新（手动）

Mac 改代码并 push 后，在 Ubuntu：

```bash
cd /opt/my-webapp
git pull
./deploy.sh
```

### 四、自动部署（GitHub Actions）

1. 在 Ubuntu 生成部署用 SSH 密钥（在 **Mac** 上执行，把公钥写到服务器）：

```bash
ssh-keygen -t ed25519 -C "github-deploy" -f ~/.ssh/my-webapp-deploy -N ""
ssh-copy-id -i ~/.ssh/my-webapp-deploy.pub user@<Ubuntu-IP>
```

2. GitHub 仓库 → **Settings → Secrets and variables → Actions**，添加：

| Name | Value |
|------|--------|
| `SERVER_HOST` | Ubuntu IP |
| `SERVER_USER` | SSH 用户名 |
| `SSH_PRIVATE_KEY` | `~/.ssh/my-webapp-deploy` 私钥全文 |

3. 之后每次 `git push origin main`，Actions 会在服务器执行 `git pull` + `./deploy.sh`。

查看进度：GitHub 仓库 **Actions** 标签页。

## Linux 服务器部署（无 Git 时）

仍可用 `rsync`/`scp` 拷到 `/opt/my-webapp`，再执行 `./deploy.sh`（见上文目录结构）。

## 常用命令

```bash
docker compose ps          # 查看状态
docker compose logs -f     # 看日志
docker compose down          # 停止并删除容器
docker compose restart       # 重启
```

## API

| 路径     | 说明           |
|----------|----------------|
| `/`      | 返回 JSON 欢迎信息 |
| `/health`| 健康检查       |
