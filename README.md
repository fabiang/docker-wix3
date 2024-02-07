# fabiang/wix3 — Wix Toolset Docker Image (Windows Container)

> THE MOST POWERFUL SET OF TOOLS AVAILABLE TO CREATE YOUR WINDOWS INSTALLATION EXPERIENCE.

… [as an Docker image](https://hub.docker.com/r/fabiang/wix3) for Windows machines.

## Available images

### Windows

See [Docker hub page for available tags](https://hub.docker.com/r/fabiang/wix3/tags?page=1&ordering=name).

## Usage

Powershell:

```
docker run -it --rm `
    -v "C:\Users\myuser\Documents\Projects\MyProject:C:\app" `
    fabiang/docker-wix3:3-windowsservercore-ltsc2022 `
    candle.exe -dProductVersion=${productVersion} -dSomeParam=Foobar .\\MyProject.wxs -arch x64

docker run -it --rm `
    -v "C:\Users\myuser\Documents\Projects\MyProject:C:\app" `
    fabiang/docker-wix3:3-windowsservercore-ltsc2022 `
    light.exe -sval .\\MyProject.wixobj'
```

## LICENSE

The Wix toolset is released under Microsoft Reciprocal License (MS-RL).
[The source code of the repository is licensed as:](LICENSE)

> BSD 2-Clause License
>
> Copyright (c) 2022, Fabian Grutschus
> All rights reserved.
