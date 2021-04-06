const chokidar = require('chokidar');

const { teInvestigate } = require('./te')

// One-liner for current directory
chokidar.watch('../in', { awaitWriteFinish: true }).on('all', async (event, path) => {
  console.log(event, path);
  if (event === 'add' || event === 'change') {
    try {
      const res = await teInvestigate(path);
      //console.log(res);
      if (res && res.response && res.response.te && res.response.te.combined_verdict) {
        let action = (res.response.te.combined_verdict === 'benign') ? 'COPY' : 'QUARANTINE'
        console.log(`${action} ${path} - ${res.response.te.combined_verdict}`)
      }
    } catch (err) {
      console.error('ERROR:', err);
    }
  }
});
