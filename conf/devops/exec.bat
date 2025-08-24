@rem ------------------- batch setting -------------------
@echo off

@rem ------------------- declare script attribute -------------------
::@STOP-CLI-PARSER

@rem ------------------- execute script -------------------
call :%*
goto end

@rem ------------------- declare function -------------------

:action
    @rem Call ASA command
    docker exec -ti asa-%PROJECT_NAME% bash -c "asa exec %*"
    goto end

:args
    goto end

:short
    echo Call algorithm.
    goto end

:help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Call algorithm in application.
    echo.
    echo Options:
    echo      --help, -h        Show more information with '%~n0' command.
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat command-description %~n0
    goto end

:end
