const core = require('@actions/core');
const time = (new Date()).toTimeString();
core.setOutput("time", time);