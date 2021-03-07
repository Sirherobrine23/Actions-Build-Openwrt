var exec = require('child_process').exec;
const core = require('@actions/core');
const path = require("path");
const fs = require("fs");
var config_1, config_2;
const github_workspace = process.env.GITHUB_WORKSPACE
// TIME
const time = (new Date()).toTimeString();
core.setOutput("time", time);
function output(dados){
    if (dados.slice(-1) == '\n'){
        var dados = dados.slice(0, -1)
    }
    console.log(dados)
}
// TIME
// Build
config_1 = path.resolve(github_workspace, core.getInput("P1"))
config_2 = path.resolve(github_workspace, core.getInput("P2"))
console.log(github_workspace);
if (!(fs.existsSync(config_1))) core.info("We didn't find your feed files, check if the settings are right.")
if (!(fs.existsSync(config_2))) core.info("We did not find the customized settings file, check the settings.")
var serverstated = exec(`bash ${__dirname}/src/Build.sh "${config_1}" "${config_2}"`, {detached: false, shell: true, maxBuffer: Infinity});
serverstated.stdout.on('data', function (data) {
    output(data)
});
serverstated.on('exit', function (code) {
    if (code == 0) {
        console.log('Sucess')
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
