# **RASBET**

Projeto desenvolvido no âmbito da unidade curricular Requisitos e Arquiteturas de Software do Mestrado em Engenharia Informática.

**Tema**: _Website_ de Apostas Desportivas

#

## **Autores**:

- [PG49995 - Anabela Pereira](https://github.com/alpereirinha)
- [PG50002 - Fernando Lobo](https://github.com/NaNdUSL)
- [PG50457 - Joana Maia](https://github.com/marshaia)
- [PG50799 - Vicente Moreira](https://github.com/VicShadow)

#

## **Estrutura do Projeto**

Este projeto apresenta três componentes principais:

- [Servidor _Web_ (VueJS App)](#FE)
- [Servidor Lógica Negócio (Projeto Java)](#BE)
- [Servidor de Base de Dados](#BD)

Apresentamos de seguida a ordem de configuração destes três componentes, tendo esta de ser seguida para conseguir obter uma execução bem-sucedida.

#

## **Setup**

### <a id="BD"> </a> **Bases de Dados**

Para o bom funcionamento da aplicação, é necessário ter um servidor de base de dados disponível. Para isso, utilize a ferramenta _MySQL Server_ para criar um servidor local.

**NOTA:** Os ficheiros seguintes encontram-se todos na diretoria _BD_.

1. Para sincronizar o servidor com os _schemas_ necessários, execute:

```
sudo mysql < createRasbetDB.sql
```

2. O próximo passo é adicionar o utilizador responsável pela comunicação com a componente da Lógica de Negócio, executando o comando:

```
sudo mysql < usersRasbetDB.sql
```

- **NOTA:** Este comando poderá gerar erro devido à política de passwords do _MySQL-Server_, para corrigir reduza as condições das passwords. (SHOW VARIABLE LIKE 'validate_password.%';)

3. Após a configuração da base de dados, para criar e atualizar os _procedures_ da base de dados, de modo a permitir a troca de informação com a Lógica de Negócio, execute:

```
sudo mysql < proceduresRasbetDB.sql
```

4. (OPCIONAL) Caso pretenda popular a base de dados com dados de teste, execute:

```
sudo mysql < populateRasbetDB.sql
```

No final destas configurações, deverá obter um servidor _MySQL_ atualizado com toda a informação, funcional e operacional, podendo avançar para o próximo passo.

#

### <a id="BE"> </a> **Lógica de Negócio**

Para correr o servidor da Lógica de Negócio será necessário uma versão do JRE (Java Runtime Enviroment) igual ou superior à versão 17, sendo recomendada a versão _openjdk-17-jre-headless_. Para uma conexão bem sucedida da base de dados à lógica de negócio, é necessário a existência de uma driver de conexão. Assim, verifique que tem instalado o driver **ConnectorJ** do MySQL.

Após a instalação, para inicializar a camada da lógica de negócio, deverá correr o ficheiro executável da mesma. Para isso, navegue até à pasta _'BACKEND'_ pelo terminal, escrevendo de seguida:

    $ java -jar JavaBackend.jar

A sua execução irá inicializar toda a camada da lógica de negócio, carregando toda a informação presente no momento na base de dados, assim como responder aos pedidos REST definidos.

**NOTA:** O servidor de Backend é responsavél por efetuar a comunicação com a API externa, logo o dispositivo onde este é executado deverá ter ligação à VPN da 'Universidade do Minho'

#

### <a id="FE"> </a> **Interface Gráfica**

Por fim, para executar e interagir com a interface gráfica desenvolvida, terá de ter instalado [_Node JS_](https://nodejs.org/en/) com uma versão igual ou superior a 16 e [_NPM_](https://docs.npmjs.com/cli/v7/configuring-npm/install) com versão mínima de 8.8.5.

Após a sua instalação, abra o terminal e navegue até à diretoria 'WEB'. De seguida, digite os seguintes comandos sequencialmente e pela ordem apresentada, esperando pela execução dos mesmos:

```cmd
    $ npm install
      ...
    $ npm run dev
```

Estes comandos irão compilar a aplicação. A partir daí, estará a interagir com a aplicação **RasBet** totalmente funcional.

**NOTA:** Caso o browser não seja iniciado, execute o mesmo colocando na barra de pesquisa:

```
https://www.localhost:5173
```
