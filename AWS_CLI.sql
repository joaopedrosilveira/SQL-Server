--Comando AWS CLi para subir uma pasta no bucket

--Configurando o ambiente
aws configure set default.s3.multipart_chunksize 128MB

aws configure set default.s3.max_concurrent_requests 20
 
-- Caso a pasta ja exista esse comando so adiciona a diferença de arquivos
Comando: aws s3 sync H:\BACKUP_SRV2042 s3://bkp-prd-cnseg/BACKUP_SRV2042 --debug

--Exemplo
aws s3 sync H:\BACKUP_SRV2042 s3://bkp-prd-cnseg/BACKUP_SRV2042 --debug
