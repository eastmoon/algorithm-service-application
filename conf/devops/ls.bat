@rem ------------------- batch setting -------------------
@echo off

@rem ------------------- execute script -------------------
call :%*
goto end

@rem ------------------- declare function -------------------

:action
    @rem Call ASA list command
    docker exec -ti asa-%PROJECT_NAME% bash -c "asa ls"
    goto end

:args
    goto end

:short
    echo List algorithm.
    goto end

:help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo List all algorithm in application.
    echo.
    echo Options:
    echo      --help, -h        Show more information with '%~n0' command.
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat command-description %~n0
    goto end

:end
