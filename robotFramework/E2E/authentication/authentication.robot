*** Settings ***
Documentation   Gerar token
Resource    ../variables/resources.robot

*** Variables ***
${acess_token}

*** Keywords ***
Bearer token
    ${false}=    Convert to Boolean    False

###################### HEADERS ##########################
    ${headers}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded

###################### BODY #############################
    ${body}=    Create Dictionary    grant_type=${Ambiente.grant_type}    client_id=${Ambiente.client_id}    client_secret=${Ambiente.client_secret}

###################### Criação da Sessão ################
    Create Session     oauth    ${Ambiente.url_token}
    ...                     disable_warnings=1
    ...                     verify=${false}
    ...                     headers=${headers}

###################### POST da Requisição ###############
    ${resposta}    POST On Session    oauth    ${Ambiente.url_token}/token
    ...                                        data=${body} 
    ...                                        expected_status=200

    Set Suite Variable        ${acess_token}
    ...                       Bearer ${resposta.json()['acess_token']}
    Log    ${resposta.content}