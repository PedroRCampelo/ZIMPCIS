
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

[![Screenshot-2025-05-28-at-11-56-31.png](https://i.postimg.cc/VLq4GLft/Screenshot-2025-05-28-at-11-56-31.png)](https://postimg.cc/56twjJF9)
## Como utilizar?

Para utilizar, basta aplicar o fonte na base, criar uma pasta no FTP(Caso cloud) ou Protheus Data (Caso base local) chamada "impncm", e salvar o arquivo .txt como "impncm"

- Aplicar o fonte
- Criar pasta "impncm"
- Salvar TXT dentro da pasta como "impncm.txt"

Esse fonte é robusto e flexível, suportando múltiplos CIUs por CIT, e múltiplos CITs por CIS.

Para executar a importação, execute o fonte em um menu ou na rotina de Executar programas.

[![Screenshot-2025-05-28-at-12-02-52.png](https://i.postimg.cc/44zzZLDk/Screenshot-2025-05-28-at-12-02-52.png)](https://postimg.cc/nMhsGkV0)
## Melhorias futuras

- Valida se o NCM já foi preenchido anteriormente e barra a duplicidade na importação
- Utilizar função para leitura de arquivo local, mesmo estando no Protheus Web