# NOME DA IMAGEM BASE A SER UTILIZADA #
FROM ubuntu
 
# ROTULO PARA A NOVA IMAGEM, IDENTIFICACAO DO DESENVOLVEDOR #
LABEL maintainer="Jose Wellington"
 
# EXECUCAO DOS COMANDOS DE AUTLIZACAO E INSTALACAO DE FERRAMENTAS #
RUN apt-get update -y && apt-get upgrade -y
 
RUN apt-get install vim -y
 
RUN apt-get install squid -y
 
RUN apt-get install apache2 -y
 
### Configuração do Squid ###
RUN cp /etc/squid/squid.conf /etc/squid/squid.conf.old
 
RUN rm -rf /etc/squid/squid.conf
 
RUN touch /etc/squid/squid.conf
 
RUN echo "### ARQUIVO DE CONFIGURACAO ### \n \
## DEFINICAO DA PORTA DE CONEXAO DO SQUID \n \
http_port 3128 \n \
## DEFINICAO DO TAMANHO MAXIMO DE UM OBJETO PARA SER ARMAZENADO EM CACHE ## \n \
maximum_object_size 4096 KB \n \
## DEFINICAO DO TAMANHO MINIMO DE UM OBJETO PARA SER ARMAZENADO EM CACHE ## \n \
minimum_object_size 0 KB \n \
## DEFINICAO DO TAMANHO MAXIMO DE UM OBJETO PARA SER ARMAZENADO EM CACHE DE MEMORIA ## \n \
maximum_object_size_in_memory 64 KB \n \
## DEFINICAO DA QUANTIDADE DE MEMORIA RAM A SER ALOCADA PARA CACHE ## \n \
cache_mem 512 MB \n \
## AJUSTA DA PERFORMANCE EM CONEXOES PIPELINE ## \n \
pipeline_prefetch on \n \
## CACHE DE FQDN ## \n \
fqdncache_size 1024 \n \
## OPCOES DE REFRESH PATTERN ## \n \
refresh_pattern ^ftp: 1440 20% 10080 \n \
refresh_pattern ^gopher: 1440 0% 1440 \n \
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0 \n \
refresh_pattern . 0 20% 4320 \n \
## DEFINICAO DA PORCENTAGEM DO USO DO CACHE ## \n \
cache_swap_low 90 \n \
cache_swap_high 95 \n \
## ARQUIVO DE LOGS DO SQUID ## \n \
access_log /var/log/squid/access.log squid \n \
cache_log /var/log/squid/cache.log \n \
cache_store_log /var/log/squid/store.log \n \
## DEFINICAO DO LOCAL DO CACHE ## \n \
cache_dir ufs /var/spool/squid 1600 16 256 \n \
## CONTROLE DE ROTACAO DOS ARQUIVOS DE LOGS ## \n \
logfile_rotate 10 \n \
## ARQUIVO CONTENDO OS ENDERECOS LOCAIS DA REDE ## \n \
hosts_file /etc/hosts \n \
## ACLS - PORTAS PADROES LIBERADAS ## \n \
acl SSL_ports port 80 #HTTP \n \
acl SSL_ports port 443 #HTTPS \n \
acl Safe_ports port 70 # gopher \n \
acl Safe_ports port 210 # wais \n \
acl Safe_ports port 1025-65535 # unregistered ports \n \
acl Safe_ports port 280 # http-mgmt \n \
acl Safe_ports port 488 # gss-http \n \
acl Safe_ports port 591 # filemaker \n \
acl Safe_ports port 777 # multiling http \n \
acl CONNECT method CONNECT \n \
### DEFINICAO DO MODO DE AUTENTICACAO \n \
auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/usuarios \n \
auth_param basic children 5 \n \
auth_param basic realm \"INFORME SEU USUARIO E SENHA DE ACESSO A INTERNET:\" \n \
auth_param basic credentialsttl 2 hours \n \
auth_param basic casesensitive off \n \
### ACL PARA GARANTIR A AUTENTICACAO DO USUARIO NOS SITES ### \n \
acl autenticados proxy_auth REQUIRED \n \
## BLOQUEIA O ACESSO UNSAFE PORTS ## \n \
http_access deny !Safe_ports \n \
## Deny CONNECT to other than secure SSL port ## \n \
http_access deny CONNECT !SSL_ports \n \
## SITES BLOQUEADOS ## \n \
acl sites-bloqueados url_regex -i \"/etc/squid/regras/sites_bloqueados\" \n \
## SITES LIBERADOS ## \n \
acl sites-liberados url_regex -i \"/etc/squid/regras/sites_liberados\" \n \
## DEFININDO A ORDEM DAS REGRAS - ACLS ## \n \
http_access deny sites-bloqueados \n \
http_access allow autenticados \n \
http_access allow sites-liberados \n \
http_access deny all \n \
http_reply_access allow all \n \
icp_access allow all \n \
miss_access allow all \n \
## DIRETORIO DAS PAGINAS DE ERROS ## \n \
error_directory /usr/share/squid/errors/pt-br \n \
## OUTRAS OPCOES DE CACHE ## \n \
cache_effective_user proxy \n \
coredump_dir /var/spool/squid " > /etc/squid/squid.conf
 
RUN mkdir /etc/squid/regras
 
RUN touch /etc/squid/regras/sites_liberados
 
RUN touch /etc/squid/regras/sites_bloqueados
 
RUN chmod -Rf 774 /var/spool/squid
 
RUN squid -z
 
# DEFINICAO DA PORTA A SER EXPOSTA NO CONTAINER #
EXPOSE 3128
