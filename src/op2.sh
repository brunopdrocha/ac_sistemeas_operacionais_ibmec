#!/bin/bash
echo "Aplicações disponíveis no sistema:"
            # 1. Procura apenas arquivos (-f) dentro da pasta ./logs/
            for app_file in ./logs/*; do
                if [ -f "$app_file" ]; then
                    # Pega o nome do arquivo (ex: app1.log) e remove a extensão (.log)
                    nome_limpo=$(basename "$app_file" .log)
                    echo " - $nome_limpo"
                fi
            done
            
            echo ""
            echo -n "Informe qual aplicação você deseja ver os logs (Exemplo: app1, app2, etc): "
            read -r app

            # 2. Monta o caminho apontando direto para o arquivo .log correspondente
            CAMINHO_LOG="./logs/${app}.log"

            echo ""
            # 3. Valida se o arquivo realmente existe antes de rodar o tail
            if [ -f "$CAMINHO_LOG" ]; then
                echo "Exibindo os últimos 30 logs de ${app}:"
                echo "------------------------------------------------------------------"
                tail -n 30 "$CAMINHO_LOG"
                echo "------------------------------------------------------------------"
            else
                echo "[ERRO]: Arquivo de log não encontrado em: $CAMINHO_LOG"
            fi

            echo ""
            read -p "Pressione [Enter] para voltar ao menu..."