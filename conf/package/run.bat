@echo off
setlocal
setlocal enabledelayedexpansion
chcp 65001

echo ^> Loading docker image
@rem Retrieve image name
for /f "tokens=1" %%p in ('dir /b *.tar') do (
    set IMAGE_FILE=%%p
    set IMAGE_FILE_NAME=!IMAGE_FILE:.tar=!
    echo Loading image !IMAGE_FILE! to docker ...
    @rem docker load --input !IMAGE_FILE!

    @rem execute package image
    docker rm -f srv_!IMAGE_FILE_NAME!
    docker run -d --rm ^
        -v %cd%\cache\data:/data ^
        -p 80:80 ^
        --name srv_!IMAGE_FILE_NAME! ^
        !IMAGE_FILE_NAME!
)

@rem show status
echo --------------------
echo.
docker stats --no-stream srv_!IMAGE_FILE_NAME!
echo --------------------
