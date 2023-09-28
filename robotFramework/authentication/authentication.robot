*** Settings ***
Documentation   Gerar token
Resource    ../variables/resources.robot

*** Variables ***
${ACCESS_TOKEN}

*** Keywords ***
Bearer token
    ${false}=    Convert to Boolean    False

###################### HEADERS ##########################
    ${HEADERS}=    Create Dictionary    Content-Type=${Ambiente.token_Content_Type}

###################### BODY #############################
    ${BODY}=    Create Dictionary    grant_type=${Ambiente.token_grant_type}    client_id=${Ambiente.token_client_id}    client_secret=${Ambiente.token_client_secret}

###################### Criação da Sessão ################
    Create Session     oauth    ${Ambiente.token_url}
    ...                         disable_warnings=1
    ...                         verify=${false}
    ...                         headers=${HEADERS}

###################### POST da Requisição ###############
    ${RESPOSTA}    POST On Session    oauth    ${Ambiente.token_url}/token
    ...                                        data=${BODY} 
    ...                                        expected_status=200

    Set Suite Variable        ${ACCESS_TOKEN}
    ...                       Bearer ${RESPOSTA.json()['access_token']}
    Log    ${RESPOSTA.content}