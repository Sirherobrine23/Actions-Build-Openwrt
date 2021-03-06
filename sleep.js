var exec = require('child_process').exec;
const core = require('@actions/core');
// TIME
const timei = (new Date()).toTimeString();
core.setOutput("time", timei);
function output(dados){if (dados.slice(-1) == '\n'){var dados = dados.slice(0, -1)};console.log(dados)}
// TIME
// Build 
var time = core.getInput("NGROK_TIME")

const hour = time.includes('h', 'H')
const minu = time.includes('m', 'M')
const seco = time.includes('s', 'S')

time = time.replace('h', '').replace('H', '').replace('m', '').replace('M', '').replace('s', '').replace('S', '')

if (hour){
    var sleepout = time * 60 * 60
} else if (minu){
    var sleepout = time * 60
} else if (seco){
    var sleepout = time
} else {
    process.exit(1)
}

const ngrok_token = core.getInput("NGROK_TOKEN")


var sle = exec(`bash ${__dirname}/src/sleeping.sh "${sleepout}" "${ngrok_token}"`, {detached: false, shell: true, maxBuffer: Infinity});
sle.stdout.on('data', function (data) {
    output(data)
});
sle.stdout.on("data", function (data){
    output(data)
})