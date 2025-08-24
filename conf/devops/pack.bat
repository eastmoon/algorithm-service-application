@rem ------------------- batch setting -------------------
@echo off

@rem ------------------- declare variable -------------------

@rem ------------------- execute script -------------------
call :%*
goto end

@rem ------------------- declare function -------------------

:action
    echo ^> Package docker image with algorithm
    @rem create cache
    IF NOT EXIST cache (
        mkdir cache
    )
    IF EXIST cache\publish (
        rd /S /Q cache\publish
    )
    mkdir cache\publish\app
    IF EXIST cache\package (
        rd /S /Q cache\package
    )
    mkdir cache\package

    @rem build base image
    set PROJECT_ENV=rpc
    docker build  --target %PROJECT_ENV% -t asa.%PROJECT_NAME%:%PROJECT_ENV% %cd%\conf\docker\cgi
    cd %CLI_DIRECTORY%

    @rem copy dockerfile and soruce code
    copy %cd%\conf\docker\Dockerfile.pack cache\publish\Dockerfile
    xcopy /Y /S %cd%\app %cd%\cache\publish\app

    @rem build pack image
    cd %cd%\cache\publish
    docker build ^
      -t asa.%PROJECT_NAME%:latest ^
      --build-arg PACK_PROJECT=%PROJECT_NAME% ^
      --build-arg PACK_ENV=%PROJECT_ENV% ^
      .
    cd %CLI_DIRECTORY%

    @rem save image
    docker save --output %cd%\cache\package\asa.%PROJECT_NAME%.tar asa.%PROJECT_NAME%:latest

    @rem copy launcher script
    xcopy /Y /S %cd%\conf\package\* %cd%\cache\package
    goto end

:args
    goto end

:short
    echo Package mode
    goto end

:help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Package docker image with algorithm.
    echo.
    echo Options:
    echo      --help, -h        Show more information with '%~n0' command.
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat command-description %~n0
    goto end

:end
