# How To Use

Github Actions Workflow: 
```yml
name: OpenWRT Github CI
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    name: Build
    steps:
    - name: Checkout
      uses: actions/checkout@main
      
    - name: Copiler
      uses: Sirherobrine23/Actions-Build-Openwrt@javascript
      with:
        CONFIG: '.config'

    - name: Upload To Releases
      uses: softprops/action-gh-release@v1
      if: env.UPLOADTORELEASE == 'true'
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      with:
        name: Build to ${{ env.DEVICE_NAME }}, Run ID ${{ github.run_id }}
        tag_name: ${{ github.run_id }}
        body_path: ${{ env.BODY_PATH }}
        files: ${{ env.FIRMWARE_PATH }}/*

    - name: Delete Old Releases
      uses: dev-drprasad/delete-older-releases@v0.1.0
      if: env.UPLOADTORELEASE == 'true'
      with:
        keep_latest: 4
        delete_tags: true
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

# More options

```yml
  URL:
    description: 'Git Repository URL'
    required: false
    default: 'https://git.openwrt.org/openwrt/openwrt.git'

  BRANCH:
    description: 'Git Repository Branch'
    required: false
    default: 'master'

  MOREPACKAGE:
    description: 'Apt package to add to use in build'
    required: false
    default:

  FEEDS_FILE:
    description: 'Openwrt Feed Repository File'
    required: false
    default: 'feeds.conf.default'
  
  UPLOADTORELEASE:
    description: 'Publish Files in Release'
    required: false
    default: 'true'

  CONFIG:
    description: 'Openwrt Build File'
    required: false
    default: '.config'

  P1:
    description: 'File Bash Script for execute before feed Update'
    required: false
    default: 'p1.sh'

  P2:
    description: 'File Bash Script for execute before feed Update'
    required: false
    default: 'p2.sh'
```