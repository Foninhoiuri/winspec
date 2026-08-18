# 📚 Guia: Usando Claude Code CLI com seu Projeto

## 🎯 O que você tem agora

Um projeto Git completo com:
- ✅ Script PowerShell (`specs.ps1`)
- ✅ README e documentação
- ✅ .gitignore configurado
- ✅ Repositório Git inicializado

---

## 🚀 Passo a Passo com Claude Code

### 1️⃣ Extraia o projeto

```bash
unzip windows-specs-project.zip
cd windows-specs-project
```

### 2️⃣ Configure o GitHub

**A) Crie um repositório vazio no GitHub:**
- Acesse [github.com/new](https://github.com/new)
- Nome: `windows-specs-project`
- Deixe em branco (NÃO initialize com README)
- Clique em "Create repository"

**B) No seu terminal (na pasta do projeto):**

```bash
git remote add origin https://github.com/SEU-USUARIO/windows-specs-project.git
git branch -M main
git push -u origin main
```

### 3️⃣ Pegue a URL para usar com `iex`

Após fazer push, a URL será:

```
https://raw.githubusercontent.com/SEU-USUARIO/windows-specs-project/main/specs.ps1
```

### 4️⃣ Use no PowerShell

```powershell
iex (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/SEU-USUARIO/windows-specs-project/main/specs.ps1').Content
```

---

## 🔄 Fluxo com Claude Code CLI

### Ver status do projeto
```bash
git status
```

### Fazer alterações

1. Edite o `specs.ps1` ou outros arquivos
2. Teste localmente:
   ```bash
   powershell -ExecutionPolicy Bypass -File specs.ps1
   ```

### Enviar mudanças
```bash
git add .
git commit -m "Descrição da mudança"
git push origin main
```

A URL será atualizada automaticamente!

---

## 💡 Usando seu próprio domínio

Se tiver um servidor/domínio próprio:

1. Upload `specs.ps1` para `https://seu-dominio.com/specs.ps1`
2. Use diretamente:

```powershell
iex (Invoke-WebRequest -Uri 'https://seu-dominio.com/specs.ps1').Content
```

---

## 🌟 Exemplo completo (do zero)

```bash
# 1. Extrair projeto
unzip windows-specs-project.zip
cd windows-specs-project

# 2. Ver o que temos
git log --oneline
cat README.md

# 3. Configurar origem remota
git remote add origin https://github.com/seu-usuario/windows-specs-project.git

# 4. Fazer push
git branch -M main
git push -u origin main

# 5. Compartilhar URL
echo "Compartilhe esta URL:"
echo "iex (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/seu-usuario/windows-specs-project/main/specs.ps1').Content"
```

---

## 📝 Atualizando depois

Toda vez que quiser fazer mudanças:

```bash
# Edite os arquivos
nano specs.ps1  # ou seu editor

# Teste
powershell -ExecutionPolicy Bypass -File specs.ps1

# Envie para o GitHub
git add .
git commit -m "Melhorias no script"
git push origin main
```

A URL já estará atualizada!

---

## 🎓 Dicas

1. **Teste sempre localmente** antes de fazer push
2. **Use mensagens de commit descritivas**
3. **Mantenha o README atualizado** com novas features
4. **Faça backup** do seu `specs.ps1` antes de grandes mudanças

---

## 🔗 Referências úteis

- [GitHub Raw Content](https://raw.githubusercontent.com)
- [PowerShell iex](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-expression)
- [Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)

---

## ❓ Dúvidas?

- Erro de execução no PowerShell? Verifique se está como **Admin**
- Arquivo não encontrado na URL? Espere alguns minutos após o push
- URL retorna 404? Verifique se é `raw.githubusercontent.com` (não `github.com`)

**Tudo pronto! 🎉**
