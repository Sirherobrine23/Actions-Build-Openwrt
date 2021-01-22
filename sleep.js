var exec = require('child_process').exec;
const core = require('@actions/core');
// TIME
const time = (new Date()).toTimeString();
core.setOutput("time", time);
function output(dados){if (dados.slice(-1) == '\n'){var dados = dados.slice(0, -1)};console.log(dados)}
// TIME
// Build 
const time = core.getInput("NGROK_TIME")

const hour = time.includes('h', 'H')
const minu = time.includes('m', 'M')
const seco = time.includes('s', 'S')

time = time.replace('h', '').replace('H', '').replace('m', '').replace('M', '').replace('s', '').replace('S', '')

if (hour){
    const sleepout = time * 60 * 60
} else if (minu){
    const sleepout = time * 60
} else if (seco){
    const sleepout = time
} else {
    process.exit(1)
}




var sle = exec(`bash ${__dirname}/src/sleeping.sh "${sleepout}"`, {detached: false, shell: true, maxBuffer: Infinity});
sle.stdout.on('data', function (data) {
    output(data)
});
sle.stdout.on("data", function (data){
    output(data)
})