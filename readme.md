
# ZIMPCIS

Realiza a importação de dados para as tabelas CIS, CIT e CIU da rotina Regras por NCM do novo configurador de tributos Protheus.

O processo lê um arquivo .TXT estruturado por blocos de informações, agrupando registros do tipo CIS, CIT e CIU. 

## Estrutura do arquivo
O arquivo de importação é um .TXT com linhas separadas por ponto e vírgula (;).
Cada linha pode conter um dos seguintes identificadores no primeiro campo:
- CIS: Define o NCM a ser cadastrado.
- CIT: Define a tributação associada ao NCM.
- CIU: Define as exceções fiscais associadas à tributação (CIT).
Exemplo de estrutura:

[![Screenshot-2025-05-28-at-11-50-46.png](https://i.postimg.cc/Jn2JDM0f/Screenshot-2025-05-28-at-11-50-46.png)](https://postimg.cc/N9RLZh1D)

Também foi criada uma planilha em Excel para facilitar o preenchimento pelo cliente:

[![Screenshot-2025-06-06-124535.png](https://i.postimg.cc/V6BsyY1R/Screenshot-2025-06-06-124535.png)](https://postimg.cc/bDrfkfZD)

## Como utilizar?

- Aplicar o fonte
- Executar função ZIMPCIS (Criar menu como boa prática)
- Selecionar arquivo TXT
- O WebAgent deve estar ligado

Esse fonte é robusto e flexível, suportando múltiplos CIUs por CIT, e múltiplos CITs por CIS.

[![Screenshot-2025-06-06-123056.png](https://i.postimg.cc/FRxT4m3V/Screenshot-2025-06-06-123056.png)](https://postimg.cc/HcVwwqSr)
[![Screenshot-2025-06-06-123239.png](https://i.postimg.cc/jq45Jjz4/Screenshot-2025-06-06-123239.png)](https://postimg.cc/4nnZDs2Y)
[![Screenshot-2025-05-28-at-12-02-52.png](https://i.postimg.cc/44zzZLDk/Screenshot-2025-05-28-at-12-02-52.png)](https://postimg.cc/nMhsGkV0)

## Melhorias futuras

- Utilizar função para leitura de arquivo local, mesmo estando no Protheus Web - Realizado ✅
- Valida se o NCM já foi preenchido anteriormente e barra a duplicidade na importação
