#!/bin/bash

# Script para backup via SSH usando o rsync
# Versão 0.1http://organelas.com/2009/08/07/shell-script-para-backup-usando-rsync-e-ssh-em-dhcp-no-ubuntu/

## Configuração!!! ##
# Mude os parâmetros abaixo, referentes ao seu sistema

# Destino:  IP ou hostname da máquina de destino
ORIGEM1=("/dev/sdb1","/media/daniel/D7B3-DE22")
ORIGEM2=("/home/daniel","/media/daniel/D7B3-DE22")
DESTINO=("/dev/sdc1","/media/daniel/HD1500GB")
# Arquivo log
LOG=/home/arduino/Dropbox/UDESC/ProjPesq14/Pratico/GreenHop/.bkp_sync/.backup`date +%Y-%m-%d`.log

# Checar se a máquina de destino está ligada
/bin/ping -c 1 -W 2 $DESTINO > /dev/null
if [ "$?" -ne 0 ];
then
   echo -e `date +%c` >> $LOG
   echo -e "\n$DESTINO desligado." >> $LOG
   echo -e "Backup não realizado\n" >> $LOG
   echo -e "--- // ---\n" >> $LOG
   echo -e "\n$DESTINO desligado."
   echo -e "Backup não realizado.\n"
else
   HORA_INI=`date +%s`
   echo -e `date +%c` >> $LOG
   echo -e "\n$DESTINO ligado!" >> $LOG
   echo -e "Iniciando o backup...\n" >> $LOG
   rsync -ah --delete --stats --progress --log-file=$LOG -e ssh $SRC$FDR1 $USR@$DESTINO:$DIR
   rsync -ah --stats --progress --log-file=$LOG -e ssh $SRC$FDR2 $USR@$DESTINO:$INITD
   HORA_FIM=`date +%s`
   TEMPO=`expr $HORA_FIM - $HORA_INI`
   echo -e "\nBackup finalizado com sucesso!" >> $LOG
   echo -e "Duração: $TEMPO s\n" >> $LOG
   echo -e "--- // ---\n" >> $LOG
   echo -e "\nBackup finalizado com sucesso!"
   echo -e "Duração: $TEMPO s\n"
   echo -e "Consulte o log da operação em $LOG.\n"
fi

# TODO

#       - Incluir em cron job!
#       - Definir como lidar com o arquivo.log (deletar, arquivar, deixar...)
#       - Incluir wakeonlan para ligar o computador se estiver desligado
#       - Desligar máquina de destino após o término do backup
#       - Criar alça para quando a transferência falhar (e.g.,falta de espaço)




