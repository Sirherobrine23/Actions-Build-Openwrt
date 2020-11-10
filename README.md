# How To Use

Github Actions: 
```yml
name: OpenWRT Github CI
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    name: Build
    steps:
    - uses: Sirherobrine23/Actions-Build-Openwrt@main
      with:
        CONFIG: '.config'
        P1: 'p1.sh'
        p2: 'p2.sh'
      
```