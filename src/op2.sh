#!/bin/bash

clear
echo "=================================================================="
echo "          VISUALIZADOR E FILTRO DE LOGS (OPÇÃO 2)                 "
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

# Monta o caminho apontando direto para o arquivo .log correspondente
CAMINHO_LOG="./logs/${app}.log"

echo ""
# Valida se o arquivo realmente existe antes de rodar qualquer comando
if [ -f "$CAMINHO_LOG" ]; then
    
    # --- SUB-MENU DE AÇÕES ---
    echo "O que você deseja fazer com os logs da aplicação '${app}'?"
    echo "  1) Visualizar todos os logs (Arquivo completo)"
    echo "  2) Ver as últimas 30 linhas"
    echo -n "Escolha uma opção (1, 2 ou 3): "
    read -r opcao_filtro

    echo ""
    echo "------------------------------------------------------------------"
    
    # --- LÓGICA DE ESCOLHA ---
    if [ "$opcao_filtro" == "1" ]; then
        echo "Exibindo todos os registros de ${app} (Arquivo completo):"
        echo "------------------------------------------------------------------"
        # Comando cat: cospe o conteúdo inteiro do arquivo no terminal
        cat "$CAMINHO_LOG"
        
    elif [ "$opcao_filtro" == "2" ]; then
        echo "Exibindo as últimas 30 linhas de ${app}:"
        echo "------------------------------------------------------------------"
        # Comando tail: pega apenas o final
        tail -n 30 "$CAMINHO_LOG"
        
    else
        echo "[ERRO]: Opção inválida. Digite apenas 1, 2 ou 3."
    fi
    
    echo "------------------------------------------------------------------"
else
    echo "[ERRO]: Arquivo de log não encontrado em: $CAMINHO_LOG"
fi

echo ""
read -p "Pressione [Enter] para voltar ao menu..."
exit 0