*** Settings ***
Documentation       Passo a passo execução dos testes

Resource            ../variables/resources.robot

*** Keywords ***
################ Gerando variáveis dinamicas ##################
Gerar variaveis dinamicas
    ${cpf1_pag}    Cpf
    ${doc_pag}    Remove string    ${cpf1_pag}    .    -
    Set Global Variable    ${doc_pag}
    # ${cnpj1_pag}    Cnpj
    # ${cnpj_pag}=    Remove String    ${cnpj1_pag}    .    -    /
    # Set Global Variable    ${cnpj_pag}
    ${doc1_rec}    Cpf
    ${doc_rec}    Remove string    ${doc1_rec}    .    -
    Set Global Variable    ${doc_rec}
    # ${cnpj1_rec}    Cnpj
    # Set Global Variable    ${cnpj1_rec}
    # ${cnpj_rec}=    Remove String    ${cnpj1_rec}    .    -    /
    ${nome_pag1}    First Name
    ${nome_pag}    Unidecode    ${nome_pag1}
    Set Global Variable    ${nome_pag}
    ${sobrenome_pag1}    Last Name
    ${sobrenome_pag}    Unidecode    ${sobrenome_pag1}
    Set Global Variable    ${sobrenome_pag}
    ${nome_rec1}    First Name
    ${nome_rec}    Unidecode    ${nome_rec1}
    Set Global Variable    ${nome_rec}
    ${sobrenome_rec1}    Last Name
    ${sobrenome_rec}    Unidecode    ${sobrenome_rec1}
    Set Global Variable    ${sobrenome_rec}
    ${data_atual}    Get Current Date    result_format=timestamp
    Set Global Variable    ${data_atual}
    ${ag_pag}    Generate Random String    4    [NUMBERS]
    Set Global Variable    ${ag_pag}
    ${ag_rec}    Generate Random String    4    [NUMBERS]
    Set Global Variable    ${ag_rec}
    ${conta_pag}    Generate Random String    6    [NUMBERS]
    Set Global Variable    ${conta_pag}
    ${conta_rec}    Generate Random String    6    [NUMBERS]
    Set Global Variable    ${conta_rec}
    ${reais}    Generate Random String    2    [NUMBERS]
    Set Global Variable    ${reais}
    ${centavos}    Generate Random String    6    [NUMBERS]
    Set Global Variable    ${centavos}

############################# 1-Cenario Pix Entre Contas #############################

Dado que eu queira fazer um Pix entre contas
    Create Session    massaEntreContas    ${Ambiente.pix_base_url}

Quando eu preencho os dados e envio
    &{headers}    Create Dictionary
    ...    Authorization=${access_token}
    ...    Content-Type=${Ambiente.pix_Content_Type}
    ...    api-id=${Ambiente.pix_api_id}
    ...    api-key=${Ambiente.pix_api_key}
    ${bodyteste}    Get File    ./contract/request/pixEntreContas.json
    ${body}    Replace Variables    ${bodyteste}
###POST da Requisição###
    ${resposta}    POST On Session    massaEntrecontas    /pagamentos/pix
    ...    data=${body}
    ...    headers=${headers}
    Set Global Variable    ${resposta}
    ${status}    Set Variable    ${resposta.json()}[status]
    ${response}    Set Variable    ${resposta.json()}
    Set Global Variable    ${status}
    Set Global Variable    ${response}

Então o sistema realiza a transação e me devolve um retorno com 200 com status EFETIVACAO_CONCLUIDA
    Status Should Be    200
    Should Be Equal As Strings    ${status}    EFETIVACAO_CONCLUIDA

############################# 2-Cenario Valida Contrato Pix Entre Contas (cenario Positivo) #############################

Dado que eu queira validar o contrato da api Pix entre contas
    Create Session    massaEntreContas    ${Ambiente.pix_base_url}

Quando eu realizo a transação
    &{headers}    Create Dictionary
    ...    Authorization=${access_token}
    ...    Content-Type=${Ambiente.pix_Content_Type}
    ...    api-id=${Ambiente.pix_api_id}
    ...    api-key=${Ambiente.pix_api_key}
    ${bodyteste}    Get File    ./contract/request/pixEntreContas.json
    ${body}    Replace Variables    ${bodyteste}
    ### POST da Requisição ###
    ${resposta}    POST On Session    massaEntrecontas    /pagamentos/pix
    ...    data=${body}
    ...    headers=${headers}
    Set Test Variable    ${resposta}

Então o sistema valida o retorno da requisição e valida que o contrato está OK
    # Carregue o esquema JSON real a partir do arquivo
    ${schema_file}    Get File    ./schemas/pixEntreContas.json
    ${response_data}    Extract   ${resposta}    content
    ${response_json}    Convert Json To String   ${response_data}
    Validate Json By Schema   ${response_json}    ${schema_file}

############################# 3-Cenario Pix Chaves #############################

Dado que eu queira fazer um Pix com a chave do recebedor
    Create Session    massaChave    ${Ambiente.pix_base_url}

Quando preencho os dados e envio
    &{headers}    Create Dictionary
    ...    Authorization=${access_token}
    ...    Content-Type=${Ambiente.pix_Content_Type}
    ...    api-id=${Ambiente.pix_api_id}
    ...    api-key=${Ambiente.pix_api_key}
    ${bodyteste}    Get File    ./contract/request/pixChave.json
    ${body}    Replace Variables    ${bodyteste}
###POST da Requisição###
    ${resposta}    POST On Session    massaChave    /pagamentos/pix
    ...    data=${body}
    ...    headers=${headers}
    Set Global Variable    ${resposta}
    ${status}    Set Variable    ${resposta.json()}[status]
    ${response}    Set Variable    ${resposta.json()}
    Set Global Variable    ${status}
    Set Global Variable    ${response}

Então o sistema realiza o pix e me devolve um retorno com 200 com status EFETIVACAO_CONCLUIDA
    Status Should Be    200
    Should Be Equal As Strings    ${status}    EFETIVACAO_CONCLUIDA

############################# Cenario 4 #############################

#Dado que eu queira validar o contrato da api Pix com Chave

#Quando eu realiso uma transação

#Então o sistema valida o retorno da requisição e devolve um erro no qual o contrato foi quebrado
#    Validate Json By Schema File    pixChave.json    ${response}

############################# Cenario 5 #############################
# Dado que eu queira fazer um Pix com e gero um QRCode
# Quando eu preencho os dados e envio minha requisição
# Então eu realizo a transação o sistema realiza a transação e me devolve um retorno com 200 com status EFETIVACAO_CONCLUIDA
