# Avaliação Contínua — Sistemas Operacionais

**Instituição:** IBMEC  
**Disciplina:** Sistemas Operacionais  
**Código:** IBM8940 | **Turma:** 8001  
**Professor:** Luiz Fernando T. de Farias  
**Semestre:** 1 de 2026

**Equipe Desenvolvedora:**
- Bruno Pilão da Rocha (202201037911)

---

## 1. Descrição Geral do Projeto

Este projeto consiste em um sistema de menus interativo desenvolvido inteiramente em Bash, com o objetivo de permitir que o usuário execute diferentes tarefas administrativas e de monitoramento diretamente pelo terminal. O sistema é composto por um script principal que gerencia a navegação e por quatro módulos independentes, cada um responsável por uma funcionalidade específica.

O cabeçalho institucional é exibido automaticamente toda vez que o menu principal é apresentado, e a única forma de encerrar o programa é através da opção dedicada de finalização.

---

## 2. Estrutura dos Módulos e Sub-rotinas

### `main.sh` — Script Principal

É o ponto de entrada do sistema. Contém duas funções centrais:

**`cabecalho()`** — Responsável por renderizar o cabeçalho institucional formatado com largura fixa de 80 caracteres. Itera sobre um array de linhas e aplica três tipos de formatação: linha cheia de `#`, linha de separação com traços `#---#`, e linha de texto alinhado à esquerda com bordas `# texto #`. Usa a função auxiliar `medir_tamanho()` para contar corretamente os caracteres, inclusive acentuados.

**`medir_tamanho()`** — Função auxiliar que mede o comprimento real de uma string usando `wc -m`, garantindo que caracteres multibyte (como letras acentuadas do português) não distorçam o alinhamento visual.

**`opcoes()`** — Exibe o menu de escolhas no terminal, listando as quatro opções interativas e a opção de saída.

**`exibir_menu()`** — Controla o loop principal do programa. Limpa a tela, chama `cabecalho()` e `opcoes()`, lê a entrada do usuário e despacha para o script correspondente via `bash src/opN.sh`. O loop só é encerrado quando o usuário escolhe a opção `0`.

---

### `op1.sh` — Operação Matemática

Permite ao usuário realizar uma operação aritmética (soma, subtração, multiplicação ou divisão) entre dois números reais. O módulo realiza validações em três etapas: valida o operador informado, valida se os dois números são numéricos (aceita inteiros e decimais com ponto), e bloqueia explicitamente a divisão por zero antes de executar o cálculo. O resultado é calculado com precisão de duas casas decimais (no caso da divisão) usando o utilitário `bc`.

---

### `op2.sh` — Visualizador de Logs de Aplicação

Lista automaticamente os arquivos `.log` disponíveis na pasta `./logs/` e permite ao usuário escolher qual aplicação deseja inspecionar. Após a seleção, oferece um sub-menu com duas opções: visualizar o arquivo de log completo ou exibir apenas as últimas 30 linhas. Valida a existência do arquivo antes de executar qualquer comando, exibindo uma mensagem de erro clara caso o arquivo não seja encontrado.

---

### `op3.sh` — Filtro Avançado de Logs por Severidade

Também lista os arquivos de log disponíveis e solicita ao usuário que escolha uma aplicação. Em seguida, apresenta um sub-menu com os quatro níveis de severidade padrão: INFO, WARNING, ERROR e CRITICAL. O módulo conta o número de ocorrências do nível selecionado usando `grep -c`, exibe um resumo da análise e, se houver ocorrências, oferece a opção de listar todos os registros filtrados com destaque colorido via `--color=always`.

---

### `op4.sh` — Monitoramento de Hardware e Execução

Oferece dois módulos de auditoria do sistema operacional:

**Módulo 1 — Status de Hardware:** Exibe o uso de memória RAM e Swap no formato escolhido pelo usuário (Megabytes ou Gigabytes), seguido das informações das principais partições de disco montadas no sistema.

**Módulo 2 — Ranking de Processos:** Solicita ao usuário a quantidade de processos a listar e exibe um ranking ordenado por consumo de CPU, com colunas formatadas mostrando usuário, PID, %CPU, %MEM e nome do executável.

---

## 3. Comandos Utilizados e Seus Propósitos

| Comando | Propósito |
|---|---|
| `printf` | Exibição formatada de texto no terminal, com controle preciso de largura e alinhamento das colunas do cabeçalho |
| `echo` | Exibição simples de texto e mensagens para o usuário |
| `wc -m` | Contagem de caracteres reais em uma string, respeitando caracteres multibyte como letras acentuadas |
| `seq` | Geração de sequências numéricas, usada para repetir caracteres (`#` e `-`) na construção do cabeçalho |
| `date` | Obtenção da data e hora atuais do sistema, com suporte a locale `pt_BR` para exibição do mês em português |
| `read` | Leitura da entrada interativa do usuário no terminal |
| `bc` | Calculadora de precisão arbitrária usada para realizar as operações matemáticas com suporte a decimais |
| `cat` | Exibição completa do conteúdo de um arquivo de log no terminal |
| `tail -n` | Exibição das últimas N linhas de um arquivo, usada para visualização parcial dos logs |
| `grep` | Busca e filtragem de padrões de texto nos arquivos de log; usado com `-c` para contar ocorrências e `--color` para destacar resultados |
| `basename` | Extração do nome do arquivo a partir de um caminho completo, removendo o diretório e a extensão |
| `free` | Exibição do uso atual de memória RAM e Swap do sistema |
| `df -h` | Listagem das partições de disco montadas com seus tamanhos em formato legível |
| `ps aux` | Listagem de todos os processos em execução no sistema com informações de CPU e memória |
| `awk` | Processamento e formatação de texto estruturado, usado para extrair e alinhar colunas da saída do `ps` |
| `head -n` | Limitação da saída a um número definido de linhas, usada no ranking de processos e na listagem de partições |
| `clear` | Limpeza da tela do terminal antes de exibir cada tela do menu ou módulo |

---

## 4. Referências

- GNU Bash Reference Manual: https://www.gnu.org/software/bash/manual/bash.html
- GNU bc Manual: https://www.gnu.org/software/bc/manual/html_mono/bc.html
- Linux `man` pages: `man printf`, `man grep`, `man ps`, `man free`, `man df`, `man awk`
- Stack Overflow — discussões sobre contagem de caracteres multibyte em Bash e alinhamento com `printf`
- TLDP — The Linux Documentation Project: https://tldp.org/LDP/abs/html/
- Repositório Github — https://github.com/brunopdrocha/ac_sistemeas_operacionais_ibmec

---

## 5. Texto do Script

### `main.sh`

```bash
#!/bin/bash

# 1. Definição rígida do tamanho da caixa
LARGURA_TOTAL=80

# 2. Configurações dos dados
TAGLINE1='#'
TAGLINE2='-'

LINHA1="IBMEC"
LINHA2="Sistemas Operacionais                                   Semestre 1 de 2026"
LINHA3="Código: IBM8940                                         Turma: 8001"
LINHA4="Professor: Luiz Fernando T. de Farias"
LINHA5="Equipe Desenvolvedora:"
LINHA6="  Aluno: Bruno Pilão da Rocha"

LINHA7="Rio de Janeiro, $(LC_TIME=pt_BR.UTF-8 date +"%d") de $(LC_TIME=pt_BR.UTF-8 date +"%B") de $(date +"%Y")"
LINHA8="Hora do Sistema: $(date +"%H") Horas e $(date +"%M") Minutos"

list=(
    "$TAGLINE1"
    "$LINHA1"
    "$LINHA2"
    "$LINHA3"
    "$LINHA4"
    "$TAGLINE2"
    "$LINHA5"
    "$LINHA6"
    "$TAGLINE2"
    "$LINHA7"
    "$LINHA8"
    "$TAGLINE1"
)

medir_tamanho() {
    echo -n "$1" | wc -m
}

cabecalho() {
    for linha in "${list[@]}"; do
        if [ "$linha" == "$TAGLINE1" ]; then
            printf '%0.s#' $(seq 1 $LARGURA_TOTAL); echo ""
            continue
        fi
        if [ "$linha" == "$TAGLINE2" ]; then
            printf "#"
            printf '%0.s-' $(seq 1 $(( LARGURA_TOTAL - 2 )))
            printf "#\n"
            continue
        fi
        tamanho_real=$(medir_tamanho "$linha")
        tamanho_espacos=$(( LARGURA_TOTAL - tamanho_real - 4 ))
        printf "# "
        printf "%s" "$linha"
        printf '%*s' $tamanho_espacos ""
        printf " #\n"
    done
}

opcoes(){
    echo ""
    echo "Menu de Escolhas:"
    echo "   1) Opção interativa 1 (Operação Matemática)"
    echo "   2) Opção interativa 2 (Logs de Aplicação)"
    echo "   3) Opção interativa 3 (Filtro de Logs por Severidade)"
    echo "   4) Opção interativa 4 (Monitoramento de Hardware)"
    echo "   0) Finalizar o programa."
    echo ""
    echo -n "Selecione uma opção: "
}

exibir_menu() {
    clear
    while [ true ]; do
        cabecalho
        opcoes
        read escolha
        case $escolha in
            1) bash src/op1.sh ;;
            2) bash src/op2.sh ;;
            3) bash src/op3.sh ;;
            4) bash src/op4.sh ;;
            0)
                echo "Finalizando o programa. Até logo!"
                break
                ;;
            *)
                echo "Opção inválida. Por favor, selecione uma opção válida."
                continue
                ;;
        esac
    done
}

exibir_menu
```

---

### `op1.sh`

```bash
#!/bin/bash

clear
echo "=================================================================="
echo "          OPERAÇÃO MATEMÁTICA (OPÇÃO 1)                          "
echo "=================================================================="
echo ""

while true; do
    echo "Para iniciar a operação matemática, deseja realizar uma soma, subtração, multiplicação ou divisão? (Digite +, -, * ou /)"
    read -r operacao
    if [[ "$operacao" != "+" && "$operacao" != "-" && "$operacao" != "*" && "$operacao" != "/" ]]; then
        echo -e "[ERRO]: Operação inválida. Escolha (+, -, * ou /).\n"
        continue
    fi
    break
done

while true; do
    echo "Digite o primeiro número:"
    read -r num1
    if ! [[ "$num1" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "[ERRO]: Número inválido. Digite um número real válido.\n"
        continue
    fi
    break
done

while true; do
    echo "Digite o segundo número:"
    read -r num2
    if ! [[ "$num2" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "[ERRO]: Número inválido. Digite um número real válido.\n"
        continue
    fi
    if [[ "$operacao" == "/" ]]; then
        is_zero=$(echo "$num2 == 0" | bc)
        if [ "$is_zero" -eq 1 ]; then
            echo -e "[ERRO]: Divisão por zero não é permitida. Digite outro número.\n"
            continue
        fi
    fi
    break
done

case $operacao in
    "+") total=$(echo "$num1 + $num2" | bc) ;;
    "-") total=$(echo "$num1 - $num2" | bc) ;;
    "*") total=$(echo "$num1 * $num2" | bc) ;;
    "/") total=$(echo "scale=2; $num1 / $num2" | bc) ;;
esac

echo ""
echo "--------------------------------------------------"
printf "Resultado: %s %s %s = %s\n" "$num1" "$operacao" "$num2" "$total"
echo "--------------------------------------------------"
echo ""

read -p "Pressione [Enter] para voltar ao menu..."
exit 0
```

---

### `op2.sh`

```bash
#!/bin/bash

clear
echo "=================================================================="
echo "          VISUALIZADOR E FILTRO DE LOGS (OPÇÃO 2)                 "
echo "=================================================================="
echo ""

echo "Aplicações disponíveis no sistema:"
for app_file in ./logs/*.log; do
    if [ -f "$app_file" ]; then
        nome_limpo=$(basename "$app_file" .log)
        echo " - $nome_limpo"
    fi
done

echo ""
echo -n "Informe qual aplicação você deseja ver os logs (Exemplo: app1, app2, etc): "
read -r app

CAMINHO_LOG="./logs/${app}.log"

echo ""
if [ -f "$CAMINHO_LOG" ]; then
    echo "O que você deseja fazer com os logs da aplicação '${app}'?"
    echo "  1) Visualizar todos os logs (Arquivo completo)"
    echo "  2) Ver as últimas 30 linhas"
    echo -n "Escolha uma opção (1 ou 2): "
    read -r opcao_filtro

    echo ""
    echo "------------------------------------------------------------------"

    if [ "$opcao_filtro" == "1" ]; then
        echo "Exibindo todos os registros de ${app}:"
        echo "------------------------------------------------------------------"
        cat "$CAMINHO_LOG"
    elif [ "$opcao_filtro" == "2" ]; then
        echo "Exibindo as últimas 30 linhas de ${app}:"
        echo "------------------------------------------------------------------"
        tail -n 30 "$CAMINHO_LOG"
    else
        echo "[ERRO]: Opção inválida. Digite apenas 1 ou 2."
    fi

    echo "------------------------------------------------------------------"
else
    echo "[ERRO]: Arquivo de log não encontrado em: $CAMINHO_LOG"
fi

echo ""
read -p "Pressione [Enter] para voltar ao menu..."
exit 0
```

---

### `op3.sh`

```bash
#!/bin/bash

clear
echo "=================================================================="
echo "          FILTRO AVANÇADO DE LOGS POR SEVERIDADE (OPÇÃO 3)        "
echo "=================================================================="
echo ""

echo "Aplicações disponíveis no sistema:"
for app_file in ./logs/*.log; do
    if [ -f "$app_file" ]; then
        nome_limpo=$(basename "$app_file" .log)
        echo " - $nome_limpo"
    fi
done

echo ""
echo -n "Informe qual aplicação você deseja ver os logs: "
read -r app

CAMINHO_LOG="./logs/$app.log"

if [ -f "$CAMINHO_LOG" ]; then
    echo ""
    echo "Níveis de severidade disponíveis:"
    echo "  1 - INFO"
    echo "  2 - WARNING"
    echo "  3 - ERROR"
    echo "  4 - CRITICAL"
    echo -n "Escolha o número correspondente ao nível de erro (1 a 4): "
    read -r opcao_erro

    case $opcao_erro in
        1) nivel_erro="INFO" ;;
        2) nivel_erro="WARNING" ;;
        3) nivel_erro="ERROR" ;;
        4) nivel_erro="CRITICAL" ;;
        *)
            echo -e "\n[ERRO]: Opção inválida. Retornando ao menu."
            read -p "Pressione [Enter] para voltar ao menu principal..."
            exit 1
            ;;
    esac

    quantidade_erros=$(grep -c -i "$nivel_erro" "$CAMINHO_LOG")

    echo -e "\n------------------------------------------------------------------"
    echo "Resumo da Análise:"
    echo " -> Foram encontradas $quantidade_erros ocorrência(s) do tipo [$nivel_erro] no arquivo ${app}.log."
    echo "------------------------------------------------------------------"

    if [ "$quantidade_erros" -gt 0 ]; then
        echo -n "Deseja listar todos os registros detalhados agora? (S/N): "
        read -r exibir_logs
        if [[ "${exibir_logs^^}" == "S" ]]; then
            echo -e "\nExibindo os logs filtrados:\n"
            grep -i --color=always "$nivel_erro" "$CAMINHO_LOG"
            echo "------------------------------------------------------------------"
        fi
    fi
else
    echo -e "\n[ERRO]: O arquivo '$CAMINHO_LOG' não foi encontrado na pasta ./logs/."
fi

echo ""
read -p "Pressione [Enter] para voltar ao menu principal..."
exit 0
```

---

### `op4.sh`

```bash
#!/bin/bash

clear
echo "=================================================================="
echo "       MONITORAMENTO DE HARDWARE E EXECUÇÃO (OPÇÃO 4)             "
echo "=================================================================="
echo ""
echo "O que você deseja validar no sistema operacional?"
echo "  1) Status do Hardware (Uso de RAM e Disco)"
echo "  2) Ranking de Processos/Executáveis mais pesados"
echo -n "Escolha um módulo de auditoria (1 ou 2): "
read -r modulo

echo ""
echo "------------------------------------------------------------------"

case $modulo in
    1)
        echo -n "Deseja visualizar a memória em (M)egabytes ou (G)igabytes? "
        read -r escala

        if [[ "${escala^^}" == "G" ]]; then
            flag="-g"
            texto="Gigabytes"
        else
            flag="-m"
            texto="Megabytes"
        fi

        echo -e "\n[Status da Memória RAM e Swap em $texto]:"
        free $flag

        echo -e "\n[Armazenamento do Sistema (Top 5 partições)]:"
        df -h | head -n 6
        ;;

    2)
        echo -n "Quantos executáveis deseja listar no ranking? (ex: 5, 10, 15): "
        read -r qtd

        if [[ "$qtd" =~ ^[0-9]+$ ]]; then
            printf "%-10s %-8s %-8s %-8s %s\n" "USUÁRIO" "PID" "%CPU" "%MEM" "COMANDO"
            ps aux --sort=-%cpu | awk 'NR>1 {printf "%-10s %-8s %-8s %-8s %s\n", $1, $2, $3, $4, $11}' | head -n "$qtd"
        else
            echo "[ERRO]: A quantidade digitada deve ser um número inteiro."
        fi
        ;;

    *)
        echo "[ERRO]: Módulo inválido. Digite 1 ou 2."
        ;;
esac

echo "------------------------------------------------------------------"
echo ""
read -p "Pressione [Enter] para voltar ao menu principal..."
exit 0
```