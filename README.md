# dcape-app-dendrite

[![GitHub Release][1]][2] [![GitHub code size in bytes][3]]() [![GitHub license][4]][5]

[1]: https://img.shields.io/github/release/dopos/dcape-app-dendrite.svg
[2]: https://github.com/dopos/dcape-app-dendrite/releases
[3]: https://img.shields.io/github/languages/code-size/dopos/dcape-app-dendrite.svg
[4]: https://img.shields.io/github/license/dopos/dcape-app-dendrite.svg
[5]: LICENSE

[Dendrite](https://matrix-org.github.io/dendrite/) application package for [dcape](https://github.com/dopos/dcape).

## Docker image used

* [matrixdotorg/dendrite-monolith](https://hub.docker.com/r/matrixdotorg/dendrite-monolith)

## Requirements

* linux 64bit (git, make, sed)
* [docker](http://docker.io)
* [dcape](https://github.com/dopos/dcape) v3
* Git service ([github](https://github.com), [gitea](https://gitea.io) or [gogs](https://gogs.io))

## Install

### By mouse (deploy with drone)

* Gitea: Fork or mirror this repo in your Git service
* Drone: Activate repo
* Gitea: "Test delivery", config sample will be saved to enfist
* Enfist: Edit config and remove .sample from name
* Gitea: "Test delivery" again (or Drone: "Restart") - app will be installed and started on webhook host

### By hands

```bash
git clone https://github.com/dopos/dcape-app-dendrite.git
cd dcape-app-dendrite
make config-if
... <edit .env>
make init-cli
make up
make create-user-admin
```

## License

The MIT License (MIT), see [LICENSE](LICENSE).

Copyright (c) 2024 Aleksei Kovrizhkin <lekovr+dopos@gmail.com>
