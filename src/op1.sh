#!/bin/bash

# --- VALIDAÇÃO DA OPERAÇÃO ---
while true; do
    echo "Para iniciar a operação matemática, deseja realizar uma soma, subtração, multiplicação ou divisão? (Digite +, -, * ou /)"
    read -r operacao
    if [[ "$operacao" != "+" && "$operacao" != "-" && "$operacao" != "*" && "$operacao" != "/" ]]; then
        echo -e "[ERRO]: Operação inválida. Escolha (+, -, * ou /).\n"
        continue
    fi
    break
done

# --- ENTRADA DO NÚMERO 1 ---
while true; do
    echo "Digite o primeiro número:"
    read -r num1
    # Expressão regular corrigida para aceitar inteiros e decimais (ponto)
    if ! [[ "$num1" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "[ERRO]: Número inválido. Digite um número real válido.\n"
        continue
    fi
    break
done

# --- ENTRADA DO NÚMERO 2 ---
while true; do
    echo "Digite o segundo número:"
    read -r num2
    if ! [[ "$num2" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        echo -e "[ERRO]: Número inválido. Digite um número real válido.\n"
        continue
    fi
    
    # Validação Crítica de SO: Divisão por zero causa erro no comando 'bc'
    if [[ "$operacao" == "/" ]]; then
        # Converte para float usando bc para checar se o valor é exatamente zero (ex: 0 ou 0.00)
        is_zero=$(echo "$num2 == 0" | bc)
        if [ "$is_zero" -eq 1 ]; then
            echo -e "[ERRO]: Divisão por zero não é permitida em Sistemas Operacionais. Digite outro número.\n"
            continue
        fi
    fi
    break
done

# --- CÁLCULO LOGÍCO ---
case $operacao in
    "+")
        total=$(echo "$num1 + $num2" | bc)
        ;;
    "-")
        total=$(echo "$num1 - $num2" | bc)
        ;;
    "*")
        total=$(echo "$num1 * $num2" | bc)
        ;;
    "/")
        total=$(echo "scale=2; $num1 / $num2" | bc)
        ;;
esac

# Exibição organizada do resultado
echo ""
echo "--------------------------------------------------"
printf "Resultado: %s %s %s = %s\n" "$num1" "$operacao" "$num2" "$total"
echo "--------------------------------------------------"
echo ""

# Pausa a execução antes de limpar a tela e voltar para o menu
read -p "Pressione [Enter] para voltar ao menu..."