    #!/bin/sh
    #
    # http://www.slackbr.org/forum/viewtopic.php?f=45&t=15052
    # Script para renomear arquivos de forma padronizada.
    #
    # Sandro Marcell (sandro_marcell@yahoo.com.br)
    # Boa Vista, Roraima - 31/06/2007 (Atualizado em 07/10/2008).
    #
    # 07/10/2008
    # - Adicionado suporte a opcoes longas;
    # - Adicionada opcao de modo silencioso.
    #
    # Uso: Faca './script.sh --ajuda' para mais detalhes.
    #
    # Obs.:
    # - Se declaradas, as opcoes [-n]*, [-c]* e [-e]* devem obrigatoriamente
    # possuir valores *(o mesmo e valido para as opcoes longas);
    # - Se a opcao [-c] nao for declarada, o 'contador' iniciara em 1;
    # - Os arquivos renomeados serao movidos para o diretorio de trabalho
    # corrente;
    # - Se no diretorio corrente houver arquivos com o mesmo nome declarado
    # na opcao [-n], entao backup serao criados;
    # - Ao declarar a opcao [-b] um subdiretorio sera criado em /tmp e os
    # arquivos serao copiados para ele, antes de serem renomeados;
    # - E possivel o uso de metacaracteres.
    PATH=/bin:/usr/bin:/usr/local/bin
    prog=`basename ${0}`

    # Como utilizar o script:
    __uso__ ()
    {
       cat <<-FIM
       Uso: $prog -abs [-c NUMERO] [-e EXTENSAO] [-n NOME] arquivo1 ...
       Onde:
       -a,        --ajuda       : Mostra esta tela de ajuda
       -b,        --backup            : Cria backups dos arquivos
       -c NUMERO,   --contador=NUMERO   : Contador numerico
       -e EXTENSAO, --extensao=EXTENSAO : Extensao dos arquivos
       -n NOME,     --nome=NOME         : Novo nome dos arquivos
       -s,        --silencioso    : Modo silencioso

       Exemplos:

       # Renomear somente arquivos jpg:
       $prog -n imagem -c 1 -e jpg ~/pessoal/*.jpg
       # Renomear arquivos com formato 001.txt ... 010.txt ..:
       $prog --extensao=txt ~/docs/*
       # Criar backups antes de renomear arquivos:
       $prog -b -n texto -c 10 -e txt ~/arqs/*
       # Renomear arquivos de diferentes diretorios:
       $prog --nome=copia --contador=1 --extensao=bkp ~/pessoal/* ~/docs/*
       FIM
       exit 1
    }

    # Checando parametros:
    [ $# -eq 0 ] && __uso__

    # Inicializando variaveis:
    bkp= ; nome= ; cont=1 ; ext= ; output=

    # Checando as opcoes definidas pelo usuario:
    while [ $# -ne 0 ]
    do
       case $1 in
          # Obtendo ajuda:
          -a | --ajuda)
          __uso__
          ;;
          # Criar backups:
          -b | --backup)
          bkp=sim
          # Diretorio destino das copias em backup:
          dbkp=/tmp/${prog}-$USER
          [ ! -d "$dbkp" ] && mkdir "$dbkp"
          ;;
          # Contador numerico:
          -c)
          # Descartando opcao [-c]:
          shift
          cont=$1
          # Somente numeros sao validos para o contador:
          echo "$cont" | grep -q "[^0-9]" && cont=1
          ;;
          # Opcao longa para contador:
          --contador=*)
          cont=`echo $1 | sed -u 's/.*=//'`
          echo "$cont" | grep -q "[^0-9]" && cont=1
          ;;
          # Extensao dos arquivos:
          -e)
          shift
          ext=$1
          ;;
          --extensao=*)
          ext=`echo $1 | sed -u 's/.*=//'`
          ;;
          # Novo nome dos arquivos:
          -n)
          shift
          nome=$1
          ;;
          --nome=*)
          nome=`echo $1 | sed -u 's/.*=//'`
          ;;
          # Modo silencioso:
          -s | --silencioso)
          output=nao
          ;;
          # Caso alguma opcao invalida seja especificada:
          -*)
          echo "[$1]: Opcao invalida\!"
          echo "Faca: '$prog --ajuda' para obter ajuda."
          exit 1
          ;;
          # O que sobrar, sera considerado arquivo:
          *)
          break
          ;;
       esac
       shift
    done

    # O usuario especificou algum arquivo:
    [ $# -eq 0 ] && {
       echo "Erro: Especifique os arquivos a serem renomeados."
       exit 1
    }

    # Informando o destino dos arquivos renomeados:
    echo "ATENCAO: Os arquivos renomeados serao movidos para: $PWD"
    echo "Renomeando..."
    sleep 2

    # Loop de execucao:
    for i in "$@"
    do
       # Criar backups antes de renomear arquivos?
       [ "$bkp" = "sim" ] && cp -rf "$i" -t "$dbkp" 2> /dev/null

       # Testes condicionais:
       [ ! -e $i ] && echo "[$i]: Arquivo nao encontrado." && continue
       [ ! -w $i ] && echo "[$i]: Sem permissao para renomear." && continue
       [ -d $i ]   && echo "Diretorios nao serao renomeados." && continue

       # Adicionado zeros ao contador:
       zeros=`printf "%03d\n" ${cont}`
       # Concatenando variaveis para formar o novo nome:
       nn="${nome}${zeros}.$ext"

       # Renomeando...
       mv --backup=t -T -- "$i" "$nn"
       [ $? -eq 0 -a "$output" != "nao" ] && echo "[$i] Renomeado para: $nn"

       # Incrementando contador:
       cont=`expr $cont + 1`
    done
    # Fim
