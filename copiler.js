var exec = require('child_process').exec;
const core = require('@actions/core');
// TIME
const time = (new Date()).toTimeString();
core.setOutput("time", time);
// TIME

function publish(){
    var ghre = exec(`node ${__dirname}/dist/index.js`, {detached: false,shell: true});
    ghre.stdout.on('data', function (data) {
        console.log(data)
    });
    ghre.on('exit', function (code) {
        if (code == 0) {
            console.log('NPM install Sucess')
        } else {
            console.log('exit with code: '+code);
        }
    });
}

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
        publish();
    } else {
        if (code == 23 ){
            core.setFailed('Erro in Link bin folder: '+code);
        } else if (code == 24){
            core.setFailed('No Config file in Root Dir, erro: '+code);
        } else if (code == 255){
            core.setFailed('Multi Copiler Erro, chech config file, Erro code: '+code);
        } else if (code == 127){ // Buids Code exit
            core.setFailed('Erro code: '+code);
        } else if (code == 128){
            core.setFailed('..., Erro code: '+code);
        } else if (code == 129){
            core.setFailed('...., Erro code: '+code);
        } else if (code == 130){
            core.setFailed('..., Erro code: '+code);
        } else if (code == 131){
            core.setFailed('...., Erro code: '+code);
        } else if (code == 132){
            core.setFailed('..., Erro code: '+code);
        } else if (code == 133){
            core.setFailed('Copiler Erro: '+code);
        } else if (code == 134){
            core.setFailed('File erro to upload: '+code);
        } else {
            core.setFailed('Make erro code: '+code);
        }
    }
});