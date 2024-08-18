# Infra Challenge 20240202 - This is a challenge by Coodesh

## Parte 1 e 2 - Configuração do servidor com IaC
Para realizar essa configuração iremos utilizar o Terraform para criar tanto a instância do EC2, que no caso é a t2.micro, quanto para a definição de regras do VPC.
Como apenas eu terei acesso à VM, irei limitar, por exemplo, o acesso a conexões SSH apenas para o meu IP.
E como se trata de uma aplicação, irei liberar a porta 80 para acesso público.
A ideia é fazer uma configuração básica para rodar uma página do Nginx, usando o próprio user_data do Terraform.
Se fosse algo mais complexo, eu utilizaria o Ansible para fazer toda a configuração desse servidor.

Como melhoria de performance poderíamos utilizar o auto scalling e dependendo da quantidade de requisições que a aplicação fosse receber, melhorar o tipo da instância.

Já de configuração básica de servidores Linux, diria que o primeiro passo seria desabilitar ou diminuir o SWAP, tendo em vista que afeta diretamente a performance. 
Além disso, fazer configuração de Cache do Nginx para que o tempo de acesso a partir da segunda vez, seja mais rápido.
Todas essas configurações de servidores podemos implementar com uma playbook no Ansible.

Questões de backups também não tem muito segredo, por não ter nada complexo que demande um script específico, poderíamos fazer um simples cronjob que copia por exemplo a página do Nginx para outro servidor, que analogamente serve para outros tipos de arquivos. Claro que pra isso demanda de criação de novas regras, talvez deixar uma porta alta específica pra isso.
Se fosse algo um pouco mais complexo, como backup de banco de dados, poderíamos sim usar um cronjob para realizar essa rotina mas alinhada com um bash script, de tal forma que podemos definir muito mais detalhes.

## Parte 3 - Continous Delivery
No caso de CI/CD temos muitas opções no mercado que são ótimas, como por exemplo o próprio Jenkins. Ou, se preferir, temos outras opções como o próprio GitHub.
Essa etapa ela varia bastante de acordo com o software que estamos trabalhando, mas no caso vou criar um pipeline bem simples que representa a etapa de build, test e deploy de uma aplicação, que facilmente poderia se adaptar.

## Estrutura da solução
* Dentro da pasta **.github/workflows** temos a criação do pipeline que executa as 3 etapadas: build, test e deploy.
  
* Dentro da pasta **terraform** temos os arquivos do terraform que foram utilizados para criação e configuração da instância do EC2 na AWS.

* Dentro da pasta **ansible** temos os arquivos utilizados para a execução da playbook que otimiza algumas tarefas do servidor em questão. Para executar essa playbook, basta preencher os dados em **ansible/hosts_vars/ec2-ubuntu1.yml** e rodar o seguinte comando:
  ```bash
  ansible-playbook -become -i inventory/testing/hosts ec2_configure.yml

## Acessando página da aplicação que está rodando no servidor configurado:
- [nginx page](http://52.90.47.51/)

## Observações 
Por ser uma infraestrutura simples, não tem muito o que explorar, como parte de monitoramento e log, rotinas de backup, automações.
O que foi feito basicamente foi a criação e configuração dessa infra utilizando IaC e medidas de segurança, além da adição do pipeine como simulação do fluxo do desenvolvimento de um software.
