# Windows PC Specs Checker 🖥️

Script PowerShell para visualizar especificações completas do seu computador Windows.

## ⚡ Uso Rápido

Execute diretamente do PowerShell com uma linha:

```powershell
irm https://raw.githubusercontent.com/Foninhoiuri/winspec/main/specs.ps1 | iex
```

## 📋 O que o script mostra

- ✅ Sistema Operacional (versão, build, arquitetura)
- ✅ Processador (modelo, cores, threads, velocidade)
- ✅ Memória RAM (total, uso, disponível)
- ✅ Discos (espaço com alertas visuais)
- ✅ Placa de Vídeo (GPU e driver)
- ✅ Informações de Rede (IP, MAC)
- ✅ Bateria (se for notebook)

## 🚀 Como usar localmente

1. Salve o arquivo `specs.ps1`
2. Abra PowerShell como Administrador
3. Execute:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
   & "C:\caminho\para\specs.ps1"
   ```

## 🌐 Deploy no seu domínio

### Opção 1: GitHub Pages (Grátis)

1. Faça fork ou crie novo repositório
2. Salve o arquivo `specs.ps1` na raiz
3. Acesse: `https://raw.githubusercontent.com/Foninhoiuri/winspec/main/specs.ps1`

Use no PowerShell:
```powershell
irm https://raw.githubusercontent.com/Foninhoiuri/winspec/main/specs.ps1 | iex
```

### Opção 2: Seu próprio servidor

1. Upload o arquivo `specs.ps1` para seu servidor/domínio
2. Certifique-se que está acessível via HTTP/HTTPS
3. Use:
   ```powershell
   iex (Invoke-WebRequest -Uri 'https://seu-dominio.com/specs.ps1').Content
   ```

### Opção 3: URL Encurtada

Use um serviço como Bit.ly para encurtar:
```powershell
irm https://bit.ly/seu-link | iex
```

## ⚙️ Requisitos

- Windows 7 ou superior
- PowerShell 3.0+
- Acesso à internet (para versão via `iex`)
- Executar como Administrador (recomendado)

## 🔒 Segurança

O script não modifica nenhum arquivo, apenas lê informações do sistema.

Para executar remotamente com `iex`, você pode confiar neste repositório ou revisar o código antes de executar.

## 📝 Licença

Livre para usar e modificar.

---

**Exemplo de execução rápida:**
```bash
powershell -Command "irm https://raw.githubusercontent.com/Foninhoiuri/winspec/main/specs.ps1 | iex"
```
