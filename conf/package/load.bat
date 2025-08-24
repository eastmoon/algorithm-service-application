@echo off
setlocal
setlocal enabledelayedexpansion

echo ^> Loading docker image
@rem Retrieve image name
for /f "tokens=1" %%p in ('dir /b *.tar') do (
    set IMAGE_FILE=%%p
    for %%q in (%%~np) do (
      set IMAGE_HASH=%%~xq
      set IMAGE_NAME=%%~nq
    )

    set IS_LOAD=
    set cmd=docker inspect !IMAGE_HASH:.=! --format "{{index .RepoTags 0}}"
    for /f "tokens=1" %%p in ('!cmd!') do (set IS_LOAD=1)
    if "!IS_LOAD!" == "" (
        echo Loading image !IMAGE_FILE! to docker ...
        docker load --input !IMAGE_FILE!
    ) else (
        echo Image !IMAGE_FILE! is loaded.
    )
)
