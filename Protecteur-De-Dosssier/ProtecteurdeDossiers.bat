@echo off
setlocal enabledelayedexpansion

:: Vérification des droits administrateur
echo Verification des permissions administrateur...
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo Ce script necessite des droits administrateur.
    echo Veuillez relancer le script en tant qu'administrateur.
    pause
    exit /b 1
) else (
    color 0A
    echo Permissions administrateur verifiees.
    echo.
    pause
)

color 0D

:MENU
cls
echo ====================================
echo     BOUCLIER PROTECTEUR DE DOSSIERS
echo ====================================
echo.
echo [1] - Proteger un dossier
echo [2] - Acceder a un dossier protege
echo [3] - Mot de passe oublie
echo [4] - Quitter
echo.
set /p choix="Entrez votre choix (1-4): "

if "%choix%"=="1" goto PROTECT
if "%choix%"=="2" goto ACCESS
if "%choix%"=="3" goto FORGOT_PASSWORD
if "%choix%"=="4" exit
goto MENU

:PROTECT
cls
set /p "folder=Entrez le chemin complet du dossier a proteger: "
if not exist "%folder%\" (
    echo Le dossier n'existe pas.
    pause
    goto MENU
)
if exist "%folder%\password.txt" (
    echo Ce dossier est deja protege.
    pause
    goto MENU
)
set /p "password=Entrez le mot de passe pour proteger le dossier: "
echo %password% > "%folder%\password.txt"
attrib +h "%folder%\password.txt"

set /p "security_question=Entrez une question de securite: "
set /p "security_answer=Entrez la reponse a la question de securite: "
echo %security_question%> "%folder%\security.txt"
echo %security_answer%>> "%folder%\security.txt"
attrib +h "%folder%\security.txt"

set /p "opener_location=Entrez le chemin ou placer les fichiers Ouvrir.bat et INSTRUCTIONS.txt (ex: C:\Chemin\Vers\Dossier): "
if not exist "%opener_location%\" mkdir "%opener_location%"

echo @echo off > "%opener_location%\Ouvrir.bat"
echo setlocal enabledelayedexpansion >> "%opener_location%\Ouvrir.bat"
echo set "folder=%folder%" >> "%opener_location%\Ouvrir.bat"
echo :CHECK >> "%opener_location%\Ouvrir.bat"
echo set /p pwd=Entrez le mot de passe: >> "%opener_location%\Ouvrir.bat"
echo set /p correct=^<"%%folder%%\password.txt" >> "%opener_location%\Ouvrir.bat"
echo if "!pwd!"=="!correct!" ( >> "%opener_location%\Ouvrir.bat"
echo     color 0A >> "%opener_location%\Ouvrir.bat"
echo     echo Mot de passe correct ! Ouverture du dossier en cours... >> "%opener_location%\Ouvrir.bat"
echo     timeout /t 2 ^>nul >> "%opener_location%\Ouvrir.bat"
echo     start "" "%%folder%%" >> "%opener_location%\Ouvrir.bat"
echo     exit >> "%opener_location%\Ouvrir.bat"
echo ) else ( >> "%opener_location%\Ouvrir.bat"
echo     color 0C >> "%opener_location%\Ouvrir.bat"
echo     echo Le mot de passe saisi est incorrect. >> "%opener_location%\Ouvrir.bat"
echo     echo. >> "%opener_location%\Ouvrir.bat"
echo     echo [1] - Reessayer >> "%opener_location%\Ouvrir.bat"
echo     echo [2] - Mot de passe oublie >> "%opener_location%\Ouvrir.bat"
echo     set /p choice=Votre choix: >> "%opener_location%\Ouvrir.bat"
echo     if "!choice!"=="1" goto CHECK >> "%opener_location%\Ouvrir.bat"
echo     if "!choice!"=="2" goto FORGOT_PASSWORD >> "%opener_location%\Ouvrir.bat"
echo ) >> "%opener_location%\Ouvrir.bat"
echo :FORGOT_PASSWORD >> "%opener_location%\Ouvrir.bat"
echo set /p q=^<"%%folder%%\security.txt" >> "%opener_location%\Ouvrir.bat"
echo set /p a=^<^<"%%folder%%\security.txt" >> "%opener_location%\Ouvrir.bat"
echo echo Question de securite: !q! >> "%opener_location%\Ouvrir.bat"
echo set /p answer=Votre reponse: >> "%opener_location%\Ouvrir.bat"
echo if "!answer!"=="!a!" ( >> "%opener_location%\Ouvrir.bat"
echo     color 0A >> "%opener_location%\Ouvrir.bat"
echo     echo Reponse correcte. Ouverture du dossier... >> "%opener_location%\Ouvrir.bat"
echo     timeout /t 2 ^>nul >> "%opener_location%\Ouvrir.bat"
echo     start "" "%%folder%%" >> "%opener_location%\Ouvrir.bat"
echo     exit >> "%opener_location%\Ouvrir.bat"
echo ) else ( >> "%opener_location%\Ouvrir.bat"
echo     color 0C >> "%opener_location%\Ouvrir.bat"
echo     echo Reponse incorrecte. >> "%opener_location%\Ouvrir.bat"
echo     pause >> "%opener_location%\Ouvrir.bat"
echo     goto CHECK >> "%opener_location%\Ouvrir.bat"
echo ) >> "%opener_location%\Ouvrir.bat"

echo Pour acceder au dossier protege, executez le fichier Ouvrir.bat dans ce dossier. > "%opener_location%\INSTRUCTIONS.txt"
echo Suivez les instructions a l'ecran pour entrer le mot de passe. >> "%opener_location%\INSTRUCTIONS.txt"
echo En cas d'oubli du mot de passe, vous pouvez utiliser la question de securite. >> "%opener_location%\INSTRUCTIONS.txt"
echo Le dossier protege se trouve a l'emplacement suivant: %folder% >> "%opener_location%\INSTRUCTIONS.txt"

echo Dossier protege avec succes.
echo Les fichiers Ouvrir.bat et INSTRUCTIONS.txt ont ete places dans: %opener_location%
pause
goto MENU

:ACCESS
cls
set /p "opener_location=Entrez le chemin du dossier contenant Ouvrir.bat: "
if not exist "%opener_location%\Ouvrir.bat" (
    echo Le fichier Ouvrir.bat n'existe pas a cet emplacement.
    pause
    goto MENU
)
call "%opener_location%\Ouvrir.bat"
goto MENU

:FORGOT_PASSWORD
cls
set /p "opener_location=Entrez le chemin du dossier contenant Ouvrir.bat: "
if not exist "%opener_location%\Ouvrir.bat" (
    echo Le fichier Ouvrir.bat n'existe pas a cet emplacement.
    pause
    goto MENU
)
call "%opener_location%\Ouvrir.bat"
goto MENU