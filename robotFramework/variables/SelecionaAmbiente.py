class Ambiente:
    """Realiza a chamada do ambiente HOM ou DEV"""
    
    #local = 'DEV' # para testes em Ambiente de Desenvolvimento
    local = 'HOM' #para testes em Ambiente de Homologação
    
    if local == 'DEV':
        # URLS e Variaveis de HEADERS - APIs
        token_url = 'http://localhost:8081/dev/api/oauth'
        token_Content_Type = 'application/x-www-form-urlencoded'
        token_grant_type = 'client_credentials'
        token_client_id = '9x48f5da-63c6-4793-8570-3d0b3a6d0822'
        token_client_secret = '2a48f5da-63c6-4793-8570-3d0b3a6d0825'
        pix_base_url = 'http://localhost:8081/dev'
        pix_Content_Type = 'application/json'
        pix_api_id = '456v99vppt'
        pix_api_key = '6759eb24-2449-44f4-8b58-f806f58'
        
    elif local == 'HOM':
        # URLS e Variaveis de HEADERS - APIs
        token_url = 'http://localhost:8081/hom/api/oauth'
        token_Content_Type = 'application/x-www-form-urlencoded'
        token_grant_type = 'client_credentials'
        token_client_id = '9x48f5da-63c6-4793-8570-3d0b3a6d0822'
        token_client_secret = '2a48f5da-63c6-4793-8570-3d0b3a6d0825'
        pix_base_url = 'http://localhost:8081/hom'
        pix_Content_Type = 'application/json'
        pix_api_id = '456v99vppt'
        pix_api_key = '6759eb24-2449-44f4-8b58-f806f58'