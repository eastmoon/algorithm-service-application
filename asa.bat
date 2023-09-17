@rem
@rem Copyright 2020 the original author jacky.eastmoon
@rem All commad module need 3 method :
@rem [command]        : Command script
@rem [command]-args   : Command script options setting function
@rem [command]-help   : Command description
@rem Basically, CLI will not use "--options" to execute function, "--help, -h" is an exception.
@rem But, if need exception, it will need to thinking is common or individual, and need to change BREADCRUMB variable in [command]-args function.
@rem NOTE, batch call [command]-args it could call correct one or call [command] and "-args" is parameter.
@rem

@rem ------------------- batch setting -------------------
@rem setting batch file
@rem ref : https://www.tutorialspoint.com/batch_script/batch_script_if_else_statement.htm
@rem ref : https://poychang.github.io/note-batch/

@echo off
setlocal
setlocal enabledelayedexpansion

@rem ------------------- declare CLI file variable -------------------
@rem retrieve project name
@rem Ref : https://www.robvanderwoude.com/ntfor.php
@rem Directory = %~dp0
@rem Object Name With Quotations=%0
@rem Object Name Without Quotes=%~0
@rem Bat File Drive = %~d0
@rem Full File Name = %~n0%~x0
@rem File Name Without Extension = %~n0
@rem File Extension = %~x0

set CLI_DIRECTORY=%~dp0
set CLI_FILE=%~n0%~x0
set CLI_FILENAME=%~n0
set CLI_FILEEXTENSION=%~x0

@rem ------------------- declare CLI variable -------------------

set BREADCRUMB=cli
set COMMAND=
set COMMAND_BC_AGRS=
set COMMAND_AC_AGRS=

@rem ------------------- declare variable -------------------

for %%a in ("%cd%") do (
    set PROJECT_NAME=%%~na
)
set PROJECT_ENV=cli

@rem ------------------- execute script -------------------

call :main %*
goto end

@rem ------------------- declare function -------------------

:main
    set COMMAND=
    set COMMAND_BC_AGRS=
    set COMMAND_AC_AGRS=
    call :argv-parser %*
    call :main-args-parser %COMMAND_BC_AGRS%
    IF defined COMMAND (
        set BREADCRUMB=%BREADCRUMB%-%COMMAND%
        findstr /bi /c:":!BREADCRUMB!" %CLI_FILE% >nul 2>&1
        IF errorlevel 1 (
            goto cli-help
        ) else (
            call :main %COMMAND_AC_AGRS%
        )
    ) else (
        call :%BREADCRUMB%
    )
    goto end

:main-args-parser
    for /f "tokens=1*" %%p in ("%*") do (
        for /f "tokens=1,2 delims==" %%i in ("%%p") do (
            call :%BREADCRUMB%-args %%i %%j
            call :common-args %%i %%j
        )
        call :main-args-parser %%q
    )
    goto end

:common-args
    set COMMON_ARGS_KEY=%1
    set COMMON_ARGS_VALUE=%2
    if "%COMMON_ARGS_KEY%"=="-h" (set BREADCRUMB=%BREADCRUMB%-help)
    if "%COMMON_ARGS_KEY%"=="--help" (set BREADCRUMB=%BREADCRUMB%-help)
    goto end

:argv-parser
    for /f "tokens=1*" %%p in ("%*") do (
        IF NOT defined COMMAND (
            echo %%p | findstr /r "\-" >nul 2>&1
            if errorlevel 1 (
                set COMMAND=%%p
            ) else (
                set COMMAND_BC_AGRS=!COMMAND_BC_AGRS! %%p
            )
        ) else (
            set COMMAND_AC_AGRS=!COMMAND_AC_AGRS! %%p
        )
        call :argv-parser %%q
    )
    goto end

@rem ------------------- Main method -------------------

:cli
    goto cli-help

:cli-args
    set COMMON_ARGS_KEY=%1
    set COMMON_ARGS_VALUE=%2
    if "%COMMON_ARGS_KEY%"=="--rpc" (set PROJECT_ENV=rpc)
    goto end

:cli-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo If not input any command, at default will show HELP
    echo.
    echo Options:
    echo      --help, -h        Show more information with CLI.
    echo      --rpc             Setting project environment with "RPC", default is "CLI"
    echo.
    echo Command:
    echo      dev               Startup and into container for develop algorithm.
    echo      pack              Package docker image with algorithm.
    echo      run               Run package image.
    echo      exec              Execute command in container.
    echo.
    echo Run 'cli [COMMAND] --help' for more information on a command.
    goto end

@rem ------------------- Common Command method -------------------

@rem ------------------- Command "dev" method -------------------

:cli-dev
    echo ^> Startup and into container for develop algorithm
    @rem build image
    cd ./conf/docker
    docker build -t python.asa:%PROJECT_ENV% -f Dockerfile.%PROJECT_ENV% .
    cd %CLI_DIRECTORY%

    @rem create cache
    IF NOT EXIST cache (
        mkdir cache
    )

    @rem execute container
    docker rm -f python.asa-%PROJECT_NAME%
    docker run -d --rm ^
        -v %cd%\cache\data:/data ^
        -v %cd%\conf\docker\cli:/usr/local/src/asa ^
        -v %cd%\src:/app ^
        --name python.asa-%PROJECT_NAME% ^
        python.asa:%PROJECT_ENV%

    @rem into container
    docker exec -ti python.asa-%PROJECT_NAME% bash
    goto end

:cli-dev-args
    goto end

:cli-dev-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Startup and into container for develop algorithm.
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end

@rem ------------------- Command "pack" method -------------------

:cli-pack
    echo ^> Package docker image with algorithm
    @rem create cache
    IF NOT EXIST cache (
        mkdir cache
    )
    IF NOT EXIST cache\image (
        mkdir cache\image
    )
    IF EXIST cache\pack (
        rd /S /Q cache\pack
    )
    mkdir cache\pack\app

    @rem build base image
    cd ./conf/docker
    docker build -t python.asa:rpc -f Dockerfile.rpc .
    cd %CLI_DIRECTORY%

    @rem copy dockerfile and soruce code
    copy conf\docker\Dockerfile.pack cache\pack\Dockerfile
    xcopy /Y /S src cache\pack\app

    @rem build pack image
    cd cache\pack
    docker build -t python.asa:pack .
    cd %CLI_DIRECTORY%

    @rem save image
    docker save --output cache\image\asa.tar python.asa:pack
    goto end

:cli-pack-args
    goto end

:cli-pack-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Package docker image with algorithm.
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end


@rem ------------------- Command "run" method -------------------

:cli-run
    echo ^> Run package image
    @rem If image exist, then load image
    IF EXIST cache\image\asa.tar (
        cd cache\image
        docker load --input asa.tar
        cd %CLI_DIRECTORY%
    )

    @rem execute package image
    docker rm -f python.asa-%PROJECT_NAME%
    docker run -d --rm ^
        -v %cd%\cache\data:/data ^
        -p 80:80 ^
        --name python.asa-%PROJECT_NAME% ^
        python.asa:pack
    goto end

:cli-run-args
    goto end

:cli-run-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Run package image.
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    goto end

@rem ------------------- Command "exec" method -------------------

:cli-exec
    IF defined ASA_COMMAND (
        echo ^> Execute : %ASA_COMMAND%
        @rem If image exist, then load image
        docker exec -ti python.asa-%PROJECT_NAME% bash -c "python %ASA_COMMAND%.py"
    ) else (
        echo ^> Execute : command was not assign
    )
    goto end

:cli-exec-args
    set COMMON_ARGS_KEY=%1
    set COMMON_ARGS_VALUE=%2
    if "%COMMON_ARGS_KEY%"=="-c" (set ASA_COMMAND=%COMMON_ARGS_VALUE%)
    goto end

:cli-exec-help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Run package image.
    echo.
    echo Options:
    echo      --help, -h        Show more information with UP Command.
    echo      -c                When execute command, e.g -c='demo'.
    goto end

@rem ------------------- End method-------------------

:end
    endlocal
