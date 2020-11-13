var exec = require('child_process').exec;
const core = require('@actions/core');
// TIME
const time = (new Date()).toTimeString();
core.setOutput("time", time);
// TIME
const URL = core.getInput('URL')
const BRANCH = core.getInput('BRANCH')
const FEED = core.getInput('FEEDS_FILE')
const CONFIG = core.getInput('CONFIG')
const P1 = core.getInput('P1')
const P2 = core.getInput('P2');
// console.log(`Git Url: "${URL}", Branch: "${BRANCH}", Feed File: "${FEED}", Config File: "${CONFIG}", Pre Script: "${P1}", Post Script: "${P2}"`)
// Build 
var serverstated = exec(`bash ${__dirname}/src/Build.sh`, {
    detached: false,
    shell: true
});
serverstated.stdout.on('data', function (data) {
    console.log(data)
});
serverstated.on('exit', function (code) {
    if (code == 0) {
        console.log('Sucess')
    } else {
        core.setFailed('exit with code: '+code);
    }
});