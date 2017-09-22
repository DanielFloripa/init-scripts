#!/bin/bash

FOLD="/media/dani/"
S3_BUCK="danielcamargo13"
S3_FOLD="Fotos/"

echo $FOLD $S3_FILE $S3_FOLD

#zip -r $FILE $FOLD

aws s3 sync $FOLD s3://$S3_BUCK/$S3_FOLD --exclude "*.ini"
#aws s3 cp $FILE s3://$S3_BUCK/$S3_FOLD 
