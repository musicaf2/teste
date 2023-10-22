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
    ${data_atual}    Get Current Date    result_format= %y-%m-%d
    Set Global Variable    ${data_atual}
    ${hora_atual}    Get Current Date    result_format=%H:%M:%S
    Set Global Variable    ${hora_atual}
    ${data_atualF}    Get Current Date    result_format= %y%m%d
    Set Global Variable    ${data_atualF}
    ${hora_atualF}    Get Current Date    result_format=%H%M%S
    Set Global Variable    ${hora_atualF}
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
    ${centavos}    Generate Random String    2    [NUMBERS]
    Set Global Variable    ${centavos}
    ${rdmstring}    Generate Random String    length=8    chars=[LETTERS][NUMBERS]
    Set Global Variable    ${rdmstring}

############################# Cenario 1 - Realizar pagamento Pix entre Contas #############################

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
    Set test Variable    ${status}

Então o sistema realiza a transação e me devolve um retorno com 200 com status EFETIVACAO_CONCLUIDA
    Status Should Be    200
    Should Be Equal As Strings    EFETIVACAO_CONCLUIDA    ${status}

############################# Cenario 2 - Validar Contrato Pix entre contas (Cenário Positivo) #############################

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
    Validate Json    pixEntreContas.json    ${resposta.json()}
############################# Cenario 3 - Realizar pagamento Pix com Chave #############################

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
    Set test Variable    ${resposta}
    ${status}    Set Variable    ${resposta.json()}[status]
    Set test Variable    ${status}

Então o sistema realiza o pix e me devolve um retorno com 200 com status EFETIVACAO_CONCLUIDA
    Status Should Be    200
    Should Be Equal As Strings    EFETIVACAO_CONCLUIDA    ${status}

############################# Cenario 4 - Validar Contrato Pix com Chave (Cenário Negativo) #############################

Dado que eu queira validar o contrato da API Pix com Chave
    Create Session    massaChave    ${Ambiente.pix_base_url}

Quando eu realizo uma transação
    &{headers}    Create Dictionary
    ...    Authorization=${access_token}
    ...    Content-Type=${Ambiente.pix_Content_Type}
    ...    api-id=${Ambiente.pix_api_id}
    ...    api-key=${Ambiente.pix_api_key}
    ${bodyteste}    Get File    ./contract/request/pixChave2.json
    ${body}    Replace Variables    ${bodyteste}
    ${resposta}    POST On Session     massaChave    /pagamentos/pix
    ...    data=${body}
    ...    headers=${headers}
    ...    expected_status=anything
    Set test Variable    ${resposta}
    ${status}    Set Variable    ${resposta.json()}[status]
    Set test Variable    ${status}
    ${response_body}    Set Variable    ${resposta.text}
    ${expected_response_body}    Set Variable    {"status":"Error","message":"Endpoint not found"}

Então o sistema valida o retorno da requisição e devolve um ERRO no qual o contrato foi quebrado
    Status Should Be    404
 #   Validate Json    pixEntreContas.json    ${resposta.json()}


############################# Cenario 5 - Realizar pagamento Pix com QRCode #############################

Dado que eu queira fazer um Pix e gero um QRCode
    Create Session    massaGeraQrCode    ${Ambiente.pix_base_url}
    &{headers}    Create Dictionary
    ...    Authorization=${access_token}
    ...    Content-Type=${Ambiente.pix_Content_Type}
    ...    api-id=${Ambiente.pix_api_id}
    ...    api-key=${Ambiente.pix_api_key}
    ${bodyteste}    Get File    ./contract/request/geraQrCode.json
    ${body}    Replace Variables    ${bodyteste}
###POST da Requisição###
    ${resposta}    POST On Session    massaGeraQrCode    /qrcode/pix
    ...    data=${body}
    ...    headers=${headers}
    ${qrcode}    Set Variable    ${resposta.json()}[qrcode]
    Set Global Variable    ${qrcode}

Quando decodifico o QrCode e envio os dados da minha requisição
    Create Session    massaQrCode    ${Ambiente.pix_base_url}
    &{headers}    Create Dictionary
    ...    Authorization=${access_token}
    ...    Content-Type=${Ambiente.pix_Content_Type}
    ...    api-id=${Ambiente.pix_api_id}
    ...    api-key=${Ambiente.pix_api_key}
    ${bodyteste}    Get File    ./contract/request/pixQrCode.json
    ${body}    Replace Variables    ${bodyteste}
###POST da Requisição###
    ${resposta}    POST On Session    massaQrCode    /pagamentos/pix
    ...    data=${body}
    ...    headers=${headers}
    Set test Variable    ${resposta}
    ${status}    Set Variable    ${resposta.json()}[status]
    Set test Variable    ${status}

Então o sistema realiza a transação e devolve um status 200 apresentando a resposta EFETIVACAO_CONCLUIDA
    Status Should Be    200
    Should Be Equal As Strings    EFETIVACAO_CONCLUIDA    ${status}
