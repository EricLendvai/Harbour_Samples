# Dockerfile

The following folder is used to build images sent to Docker Hub.   

See the [docker documentation](https://docs.docker.com/engine/reference/commandline/build/).

## docker build
From the repo root folder execute the following to build images locally:   
To force not to use cached build, add "--no-cache"   
Call "docker build" with multiple tags to create a Docker image and tag as "latest" an a date.   
    docker build . -f Dockerfile_harbour_basic -t ericlendvai/harbour_basic:latest -t ericlendvai/harbour_basic:2022_10_24_001

    docker build . -f Dockerfile_harbour_curl_hb-orm_hb-vfp_hb-fastcgi_apache_odbc-postgresql -t ericlendvai/harbour_curl_hb-orm_hb-vfp_hb-fastcgi_apache_odbc-postgresql:latest -t ericlendvai/harbour_curl_hb-orm_hb-vfp_hb-fastcgi_apache_odbc-postgresql:2022_10_24_001

## docker push
From the repo root folder execute the following to send to Docker Hub the new images. The tag "latest" will replace previous version".   
Call multiple "docker push".   
Don't use "--all-tags" option the since even existing images will be redates as current.   
    docker push ericlendvai/harbour_basic:2022_10_24_001
    docker push ericlendvai/harbour_basic:latest

    docker push ericlendvai/harbour_curl_hb-orm_hb-vfp_hb-fastcgi_apache_odbc-postgresql:2022_10_24_001
    docker push ericlendvai/harbour_curl_hb-orm_hb-vfp_hb-fastcgi_apache_odbc-postgresql:latest
