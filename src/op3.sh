#!/bin/bash

clear
echo "=================================================================="
echo "          FILTRO AVANÇADO DE LOGS POR SEVERIDADE (OPÇÃO 3)        "
echo "=================================================================="
echo ""

echo "Aplicações disponíveis no sistema:"
# Procura apenas arquivos (-f) dentro da pasta ./logs/ terminados em .log
for app_file in ./logs/*.log; do
    if [ -f "$app_file" ]; then
        # Pega o nome do arquivo (ex: app1.log) e remove a extensão (.log)
        nome_limpo=$(basename "$app_file" .log)
        echo " - $nome_limpo"
    fi
done

echo ""
echo -n "Informe qual aplicação você deseja ver os logs (Exemplo: app1, app2, etc): "
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
    
    # Condicional que mapeia o número digitado para a string exata do log
    case $opcao_erro in
        1) nivel_erro="INFO" ;;
        2) nivel_erro="WARNING" ;;
        3) nivel_erro="ERROR" ;;
        4) nivel_erro="CRITICAL" ;;
        *) 
            echo -e "\n[ERRO]: Opção inválida. Retornando ao menu."
            echo ""
            read -p "Pressione [Enter] para voltar ao menu principal..."
            exit 1
            ;;
    esac
    
    # Conta a quantidade de ocorrências usando a flag '-c' do grep
    quantidade_erros=$(grep -c -i "$nivel_erro" "$CAMINHO_LOG")
    
    echo -e "\n------------------------------------------------------------------"
    echo "Resumo da Análise:"
    echo " -> Foram encontradas $quantidade_erros ocorrência(s) do tipo [$nivel_erro] no arquivo ${app}.log."
    echo "------------------------------------------------------------------"
    
    # Se encontrou pelo menos 1 erro, oferece a opção de listá-los
    if [ "$quantidade_erros" -gt 0 ]; then
        echo -n "Deseja listar todos os registros detalhados agora? (S/N): "
        read -r exibir_logs
        
        # Converte a resposta para maiúscula para aceitar tanto 's' quanto 'S'
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