const core = require('@actions/core');
const time = (new Date()).toTimeString();
console.log(time)
core.setOutput("time", time);