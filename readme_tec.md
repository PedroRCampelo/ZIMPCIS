# 📘 Documentação Técnica - Fonte ZIMPCIS.PRW

Este documento descreve tecnicamente o funcionamento de todas as funções do fonte ZIMPCIS.PRW, responsável por importar dados nas tabelas CIS, CIT e CIU do novo configurador de tributos do Protheus.

---

## 🧩 Função: ZIMPCIS()

Função principal que inicia a interface da rotina. Apresenta uma tela com opções para o usuário:

- Exibe uma janela com título, instruções e botões de ação.
- Se o usuário escolher a opção de importar (`nOpcao == 1`), chama a função `ExecBlock("ZNCM")`, que é responsável pela lógica de importação.

---

## 🧩 Função: ZGerUUID(nIndex)

Gera um identificador único com base na data, hora e número incremental:

```advpl
Return DToS(Date()) + StrTran(Time(), ":", "") + StrZero(nIndex, 4)
```

🔧 Exemplo de retorno: `2025061218230032`

---

## 🧩 Função: SetAssocValue(aArray, cKey, xValue)

Simula um dicionário: associa uma chave `cKey` a um valor `xValue` dentro de um array bidimensional:

```advpl
SetAssocValue(aTribCIT, "ICMS", "UUID123")
```

Se a chave já existir, substitui o valor. Se não existir, adiciona o par no array.

---

## 🧩 Função: GetAssocValue(aArray, cKey)

Busca o valor correspondente a uma chave `cKey` no array bidimensional:

```advpl
x := GetAssocValue(aTribCIT, "ICMS")
```

Retorna o valor se encontrar, ou `Nil` se não encontrar.

---

## 🧩 Função: SplitPreservandoVazios(cLinha)

Divide uma string por `;`, preservando campos vazios. Isso é importante para importações com campos faltando no meio:

```advpl
SplitPreservandoVazios("A;;C") => ["A", "", "C"]
```

---

## 🧩 Função: ZNCM()

Executa o processo de importação em si:

1. **Abre janela para o usuário selecionar o arquivo .TXT**
2. **Lê e separa cada linha do arquivo**
3. **Identifica o tipo de linha (CIS, CIT ou CIU)**
4. **Faz o tratamento de dados e salva nas tabelas**

### ▶ Bloco CIS:
- Lê o NCM.
- Gera ID.
- Salva na tabela `CIS`.

### ▶ Bloco CIT:
- Lê o tributo.
- Associa ao último `CIS` lido.
- Gera ID.
- Salva na tabela `CIT`.
- Armazena o ID e NCM para referência em CIU.

### ▶ Bloco CIU:
- Associa ao último tributo (`CIT`) processado.
- Preenche os campos da tabela `CIU`, mesmo com dados vazios.
- Grava os dados.

---

## 📌 Observações Técnicas

- Todas as inserções são feitas com `RecLock()` e `MsUnlock()` para garantir integridade.
- A função lida com valores numéricos (como alíquotas) convertendo vírgulas para ponto flutuante (`StrTran` + `Val`).
- Todos os campos opcionais são tratados, permitindo linhas incompletas no arquivo `.TXT`.

---

