var exec = require('child_process').exec;
function installAPT(){
    const core = require('@actions/core');
    const time = (new Date()).toTimeString();
    core.setOutput("time", time);
    // Time End
    const packages = core.getInput('MOREPACKAGE')
    var aptrepo = exec(`bash ${__dirname}/src/Install.sh`);
    aptrepo.stdout.on('data', function (data) {
        console.log(data);
    });
    aptrepo.on('exit', function (code) {
        if (code == 0) {
            console.log('Apt Packages Install Sucess')
        } else {
            core.setFailed('exit with code: '+code);
        }
    });
}
var npmi = exec(`cd ${__dirname} && pwd && npm install`, {detached: false,shell: true});
console.log('Node Modules install')
// npmi.stdout.on('data', function (data) {
//     console.log(data)
// });
npmi.on('exit', function (code) {
    if (code == 0) {
        // console.log('NPM install Sucess')
        installAPT();
    } else {
        console.log('exit with code: '+code);
    }
});
