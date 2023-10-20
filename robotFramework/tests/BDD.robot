*** Settings ***
Documentation       Cenarios de teste BDD

Resource            ../variables/resources.robot

Suite Setup         Bearer token

Test Tags           bdd
### Para rodar a suite inteira coloque a Tag no executavel Testes_API_Robot_Tag da pasta executavel ###


*** Test Cases ***
################### Gerando Variaveis dinamicas #####################

Gerando Variaveis dinamicas
    Gerar variaveis dinamicas

############################# Cenario 1 #############################

Cenario 1 - Realizar pagamento Pix entre Contas
    Dado que eu queira fazer um Pix entre contas
    Quando eu preencho os dados e envio
    Então o sistema realiza a transação e me devolve um retorno com 200 com status EFETIVACAO_CONCLUIDA

############################# Cenario 2 #############################

Cenario 2 - Validar Contrato Pix entre contas (Cenário Positivo)
    Dado que eu queira validar o contrato da api Pix entre contas
    Quando eu realizo a transação
    Então o sistema valida o retorno da requisição e valida que o contrato está OK

############################# Cenario 3 #############################

Cenario 3 - Realizar pagamento Pix com Chave
    Dado que eu queira fazer um Pix com a chave do recebedor
    Quando preencho os dados e envio
    Então o sistema realiza o pix e me devolve um retorno com 200 com status EFETIVACAO_CONCLUIDA

############################# Cenario 4 #############################

Cenario 4 - Validar Contrato Pix com Chave (Cenário Negativo)
    Dado que eu queira validar o contrato da api Pix com Chave
    Quando eu realizo uma transação
    Então o sistema valida o retorno da requisição e devolve um ERRO no qual o contrato foi quebrado

############################# Cenario 5 #############################

Cenario 5 - Realizar pagamento Pix com QRCode
    Dado que eu queira fazer um Pix e gero um QRCode
    Quando decodifico o QrCode e envio os dados da minha requisição
    Então o sistema realiza a transação e devolve um status 200 apresentando a resposta EFETIVACAO_CONCLUIDA
