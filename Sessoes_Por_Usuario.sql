select loginame, count(open_tran)as qtd_transacoes From master.sys.sysProcesses
where open_tran >0
group by loginame
