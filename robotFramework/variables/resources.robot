*** Settings ***
Documentation       Armazenamento de todas livrarias e resourses

Library             FakerLibrary    locale=pt_BR
Library             DateTime
Library             String
Library             Collections
Library             OperatingSystem
Library             JSONLibrary
Library             RequestsLibrary
Library             unidecode
Library             keyword
Library             jsonschema
Library             JSONSchemaLibrary

Variables           SelecionaAmbiente.py

Resource            ../variables/massaDinamica.robot
Resource            ../authentication/authentication.robot
Resource            ../steps/stepsE2E.robot
