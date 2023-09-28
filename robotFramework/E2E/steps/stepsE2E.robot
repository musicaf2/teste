*** Settings ***
Documentation     Passo a passo execução dos testes
Resource         ../variables/resources.robot

*** Keywords ***
################ Gerando variáveis dinamicas ##################
    ${CPF_ORIGINAL}        Cpf
    Set Global Variable    ${CPF_ORIGINAL}
    ${cpf}=                Remove string    ${CPF_ORIGINAL}    .    -
    ${CNPJ_ORIGINAL}       Cnpj
    Set Global Variable    ${CNPJ_ORIGINAL}
    ${cnpj}=               Remove String    ${CNPJ_ORIGINAL}    .    -    /
    ${nome_pag1}           First Name
    Set Global Variable    ${CPF_ORIGINAL}
    ${cpf}=                Remove String    ${CPF_ORIGINAL}    .    -