# Leilão de Estoque
## Essa é uma aplicação web, de um sistema de leilões de um estoque antigo com produtos que já saíram de linha, ou que possuem pequenos defeitos.

### Principais Funcionalidades
    - Criação de itens
    - Criação de categoria dos itens 
    - Casdastro de lotes
    - Cadastro de um leilão
    - Lances enviados em tempo real
    - Dúvidas e respostas em dúvidas em tempo real
    - Telas específicas para usuários Administradores
    - Capacidade de favoritar lotes

### Depêndencias para rodar o projeto
* Versão do Ruby                     ->  3.2.1
* Versão do Rails                    ->  7.0.4.3
* Versão do [Rspec](#rspec)          ->  3.12
* Versão do [Capybara](#capybara)                 ->  3.39.0
* Versão do [Devise](#devise)                   ->  4.9.2
* Versão do [Image Processing](#image-processing)          ->  1.2
* Versão do [Mini Magick](#mini-magick)              ->  4.12.0
* Versão do [Import Map](#import-map)               ->  1.1.6
* Versão do [Slim Select](#rspec)              ->  2.4.5
* Versão do [Hotwire Rails](#hotwire-rails)   -> 0.1.3
* Versão do [Redis](#redis) -> 4.8.1

### Dependências dos testes
* Versão do [Selenium Webdriver](#selenium-webdriver) -> 4.9.0
* Versão do [Webdrivers](#webdrivers) -> 5.2.0
* Versão do [Google Chrome](#google-chrome) -> 113.0.5672.126


### A importância de cada dependência

- #### Devise
    Solução para autenticação para o Rails baseado no Warden. [Documentação](https://github.com/heartcombo/devise)

- #### Rspec
    Solução para criação de diferentes tipos de testes, para a linguagem Ruby. [Documentação](https://rspec.info/documentation/6.0/rspec-rails/#installation)

- #### Capybara
    Ajuda as aplicações web em geral, simulando como um usuário real interage com o app. [Documentação](https://github.com/teamcapybara/capybara)

- #### Image Processing
    Disponibiliza auxiliadores de processamento de imagem que são necessários em uploads de imagens. [Documentação](https://github.com/janko/image_processing)

- #### Mini Magick
    Permite manipular imagens, como redimensionar, cortar, aplicar filtros, entre outros. [Documentação](https://github.com/minimagick/minimagick)

- #### Import Map
    Permite importar módulos JavaScript. [Documentação](https://github.com/rails/importmap-rails)

- #### Slim Select
    Plugin para seleção de opções em formulários. Ele permite uma ótima personalização e melhor interatividade. [Documentação](https://slimselectjs.com/)

- #### Hotwire Rails
    Conjunto de bibliotecas que permite construir interfaces web interativas e em tempo real de forma fácil e eficiente. [Documentação](https://hotwired.dev/)

- #### Redis
    Banco de dados não relacional, é utilizado com o Action Cable. [Documentação](https://redis.io/docs/)

- #### Selenium Webdriver
    Implementa a interface do Selenium para diferentes navegadores. Ele permite que você execute seus testes automatizados em diferentes navegadores de forma consistente, fornecendo uma camada de abstração sobre os detalhes de cada navegador. [Documentação](https://github.com/SeleniumHQ/selenium)

- #### Webdrivers
    Simplifica o uso do Selenium WebDriver em projetos Ruby. Ele fornece uma API amigável e conveniente para interagir com o WebDriver e executar testes automatizados em navegadores. [Documentação](https://github.com/titusfortner/webdrivers)

- #### Google Chrome
    Ótimo navegador web, nesse projeto é utilizado como navegador de testes juntamente com o Selenium, Webdrivers, Capybara e Rspec. [Website](https://www.google.com/intl/pt-BR/chrome/)

### Como rodar o projeto
Faça um git clone, em um diretório de sua preferência:
```
git clone https://github.com/GA9BR1/Leilao_de_Estoque
```
Entre no diretório, e rode o comando:
```
bundle install
```
O comando à cima instalará as gems. Além disso ele também instalará o redis-server no seu sistema operacional e o Google Chrome se eles não estiverem instalados.
A instalação automatica irá funcionar em sistemas Debian/Ubuntu, caso seu sistema não seja nenhum desses remova da linha 28 até a linha 50 no Gemfile. Note que será necessário instalar os 2 manualmente.

Após fazer todas as instalações necessárias, rode o comando: 
```
rails db:migrate
```
Finalizado, abra dois shells. Em cada um deles você deve executar essas linhas respectivamente.
```
redis-server
```

```
rails server
```

Pronto !! Sua aplicação já está no ar em modo desenvolvimento.

### Como rodar os testes
Você precisa ter tudo instalado para funcionar direitinho, caso não leu a seção de cima, volte e leia: Como rodar o projeto.
Para rodar os testes basta digitar o comando: 
```
rspec
```

### Instrução básicas de usuários
    - Para criar um usuário administrador basta adicionar o domínio @leilaodogalpao.com.br em seu e-mail.