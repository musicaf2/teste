cls
@echo off
set "tags="
echo Insira as tags que serao executadas separadas por um (1) espaco em branco.
set /P tags="Caso nao queira utilizar o sistema de tags, apenas passe o campo vazio: "
echo.
if [%tags%]==[] GOTO NOTUSINGTAGS

:USINGTAGS
echo Executando com as seguintes Tags: %tags%
echo.
set command=python -m robot -N "Log Cenarios de teste automatizados" --include %tags% -d ./results tests\*.robot
goto :EXECUTE

:NOTUSINGTAGS
echo Executando sem o uso de Tags.
echo.
set command=python -m robot -N "Log Cenarios de teste automatizados" -d ./results tests\*.robot
goto :EXECUTE

:EXECUTE
set local=%~dp0
echo Iniciando os testes automatizados com RobotFramework - BACKEND
echo --------------------------------------------------------------
cd ..
cd %cd%
call %command%

echo --------------------------------------------------------------
echo Caso de testes FINALIZADO
cd %local%
goto :done

:done
pause