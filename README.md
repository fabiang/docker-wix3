# fabiang/wix3 — Wix Toolset Docker Image

> THE MOST POWERFUL SET OF TOOLS AVAILABLE TO CREATE YOUR WINDOWS INSTALLATION EXPERIENCE.

… [as an Docker image](https://github.com/fabiang/docker-wix3).

## Available images

### ltsc2022
```
3.x (tags: 3-windowsservercore-ltsc2022)
3.11 (tags: 3.11-windowsservercore-ltsc2022)
3.11.x (tags: 3.11.2-windowsservercore-ltsc2022, 3.11.1-windowsservercore-ltsc2022)
3.10 (tags: 3.10-windowsservercore-ltsc2022)
3.10.x (tags: 3.10.4-windowsservercore-ltsc2022)
```

## ltsc2019
```
3.x (tags: 3-windowsservercore-ltsc2019)
3.11 (tags: 3.11-windowsservercore-ltsc2019)
3.11.x (tags: 3.11.2-windowsservercore-ltsc2019, 3.11.1-windowsservercore-ltsc2019)
3.10 (tags: 3.10-windowsservercore-ltsc2019)
3.10.x (tags: 3.10.4-windowsservercore-ltsc2019)
```

## Usage

Powershell:

```
docker run -it --rm `
    -v "./:C:\app" `
    fabiang/docker-wix3:3-windowsservercore-ltsc2022 `
    msbuild ...
```

## LICENSE

The Wix toolset is released under Microsoft Reciprocal License (MS-RL).
[The source code of the repository is licensed as:](LICENSE)

> BSD 2-Clause License
>
> Copyright (c) 2022, Fabian Grutschus
> All rights reserved.
