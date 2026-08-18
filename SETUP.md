# 🚀 Setup com Claude Code CLI

## Usando Claude Code para gerenciar este projeto

### 1️⃣ Inicializar o repositório

```bash
cd windows-specs-project
git init
git add .
git commit -m "Initial commit: Windows PC specs checker"
```

### 2️⃣ Conectar ao GitHub (se não tiver ainda)

```bash
# Crie um novo repositório no GitHub
# Depois execute:

git remote add origin https://github.com/seu-usuario/windows-specs-project.git
git branch -M main
git push -u origin main
```

### 3️⃣ URL para usar com iex

Após fazer push no GitHub:

```powershell
irm https://raw.githubusercontent.com/Foninhoiuri/winspec/main/specs.ps1 | iex
```

### 4️⃣ Usar seu próprio domínio

Se tiver um domínio próprio, faça upload do arquivo `specs.ps1` para seu servidor:

```powershell
irm https://seu-dominio.com/specs.ps1 | iex
```

---

## 📋 Estrutura do Projeto

```
windows-specs-project/
├── specs.ps1           # Script principal
├── README.md           # Documentação
├── SETUP.md            # Este arquivo
├── .gitignore          # Arquivos ignorados pelo git
└── .git/               # Repositório Git
```

---

## 💡 Próximos Passos

1. Configure seu GitHub/domínio
2. Teste a URL com `iex` no PowerShell
3. Compartilhe a URL com outros
4. Faça atualizações direto no repositório

---

## 🔧 Atualizações futuras

Sempre que fizer mudanças:

```bash
git add .
git commit -m "Descrição das mudanças"
git push origin main
```

A URL já será atualizada automaticamente!
