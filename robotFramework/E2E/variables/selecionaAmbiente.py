class Ambiente:
    """Realiza a chamada do ambiente HOM ou DEV"""
    
    #local = 'DEV' # para testes em Ambiente de Desenvolvimento
    local = 'HOM' #para testes em Ambiente de Homologação
    
    if local == 'DEV':
        # URLS e Variaveis de HEADERS - APIs
        url_token = 'http://localhost:8080/dev/api/oauth'