--Comando AWS CLi para subir uma pasta no bucket
-- Caso a pasta ja exista esse comando so adiciona a diferença de arquivos
Comando: aws s3 sync H:\BACKUP_SRV2042 s3://bkp-prd-cnseg/BACKUP_SRV2042 --debug

--Exemplo
aws s3 sync H:\BACKUP_SRV2042 s3://bkp-prd-cnseg/BACKUP_SRV2042 --debug
