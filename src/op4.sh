#!/bin/bash

clear
echo "=================================================================="
echo "       MONITORAMENTO DE HARDWARE E EXECUÇÃO (OPÇÃO 4)             "
echo "=================================================================="
echo ""
echo "O que você deseja validar no sistema operacional?"
echo "  1) Status do Hardware (Uso de RAM e Disco)"
echo "  2) Ranking de Processos/Executáveis mais pesados"
echo "  3) Filtrar eventos de execução no Kernel (Logs de Hardware)"
echo -n "Escolha um módulo de auditoria (1, 2 ou 3): "
read -r modulo

echo ""
echo "------------------------------------------------------------------"

case $modulo in
    1)
        # --- VALIDAÇÃO DE HARDWARE ---
        echo -n "Deseja visualizar a memória em (M)egabytes ou (G)igabytes? "
        read -r escala
        
        # Converte para maiúscula para validar
        if [[ "${escala^^}" == "G" ]]; then
            flag="-g"
            texto="Gigabytes"
        else
            flag="-m"
            texto="Megabytes"
        fi
        
        echo -e "\n[Status da Memória RAM e Swap em $texto]:"
        # O comando free mostra a memória ram e o swap
        free $flag
        
        echo -e "\n[Armazenamento do Sistema (Top 5 partições)]:"
        # O df -h mostra os discos montados em formato legível
        df -h | head -n 6
        ;;
        
    2)
        # --- VALIDAÇÃO DE EXECUTÁVEIS (PROCESSOS) ---
        echo -n "Quantos executáveis deseja listar no ranking? (ex: 5, 10, 15): "
        read -r qtd
        
        # Valida se digitou apenas números
        if [[ "$qtd" =~ ^[0-9]+$ ]]; then
            # Ordena os processos por uso de CPU em ordem decrescente
            printf "%-10s %-8s %-8s %-8s %s\n" "USUÁRIO" "PID" "%CPU" "%MEM" "COMANDO"
            ps aux --sort=-%cpu | awk 'NR>1 {printf "%-10s %-8s %-8s %-8s %s\n", $1, $2, $3, $4, $11}' | head -n "$qtd"
        else
            echo "[ERRO]: A quantidade digitada deve ser um número inteiro."
        fi
        ;;
        
    *)
        echo "[ERRO]: Módulo inválido. Digite 1 ou 2 "
        ;;
esac

echo "------------------------------------------------------------------"
echo ""
read -p "Pressione [Enter] para voltar ao menu principal..."
exit 0