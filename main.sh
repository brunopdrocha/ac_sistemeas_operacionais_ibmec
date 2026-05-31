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

# Ajuste fino na concatenação da data de hoje
LINHA7="Rio de Janeiro, $(LC_TIME=pt_BR.UTF-8 date +"%d") de $(LC_TIME=pt_BR.UTF-8 date +"%B") de $(date +"%Y")"
LINHA8="Hora do Sistema: $(date +"%H") Horas e $(date +"%M") Minutos"

# Declaração correta do Array no Bash (Sem espaços antes/depois do '=' e sem vírgulas separando)
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

# Função matemática para medir caracteres reais (imune a acentos)
medir_tamanho() {
    echo -n "$1" | wc -m
}

# Função para renderizar o cabeçalho estruturado
cabecalho() {
    for linha in "${list[@]}"; do
        
        # Caso TAGLINE 1 (Linha cheia de Hashtags)
        if [ "$linha" == "$TAGLINE1" ]; then
            printf '%0.s#' $(seq 1 $LARGURA_TOTAL); echo ""
            continue
        fi

        # Caso TAGLINE 2 (Hashtag no início, traços no meio, Hashtag no fim)
        if [ "$linha" == "$TAGLINE2" ]; then
            printf "#"
            printf '%0.s-' $(seq 1 $(( LARGURA_TOTAL - 2 )))
            printf "#\n"
            continue
        fi

        # DEFAULT (Texto Alinhado à Esquerda com preenchimento até o final)
        tamanho_real=$(medir_tamanho "$linha")
        
        # -4 desconta a borda inicial "# ", e a borda final " #"
        tamanho_espacos=$(( LARGURA_TOTAL - tamanho_real - 4 )) 
        
        printf "# "
        printf "%s" "$linha"                     # O texto real encostado na esquerda
        printf '%*s' $tamanho_espacos ""         # Todos os espaços necessários na direita
        printf " #\n"                            # A hashtag final cravada na coluna 100
        
    done
}

opcoes(){
    echo ""
    echo "Menu de Escolhas:"
    echo "   1) Opção interativa 1 (Operação Matemática)"
    echo "   2) Opção interativa 2 (Logs de Aplicação)"
    echo "   3) Opção interativa 3 (Exemplo: Informações de Rede)"
    echo "   4) Opção interativa 4 (Exemplo: Logs do Sistema)"
    echo "   0) Finalizar o programa."
    echo ""
    echo -n "Selecione uma opção: "
}


# Função para renderizar o menu dinâmico
exibir_menu() {
    
    clear

    while [ true ]; do
        # Chama a função que processa a sua lista do cabeçalho
        cabecalho
        
        # --- EXIBIÇÃO DO MENU ---
        opcoes
        # --- LEITURA DA ESCOLHA DO USUÁRIO ---
    

        read escolha
        case $escolha in
            1)  
                bash src/op1.sh
                ;;
            2)

                bash src/op2.sh
                ;;

            3)
                echo "Você escolheu a Opção 3: Informações de Rede"
                # Aqui você pode adicionar o código para mostrar as informações de rede, por exemplo:
                ifconfig
                continue
                ;;
            4)
                echo "Você escolheu a Opção 4: Logs do Sistema"
                # Aqui você pode adicionar o código para mostrar os logs do sistema, por exemplo:
                tail -n 20 /var/log/syslog
                continue
                ;;
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
# Executa o menu
exibir_menu