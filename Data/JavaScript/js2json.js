
const jsFile = process.argv[2];
if (!jsFile) {
  console.error('Please provide a JavaScript (.js) file.');
  process.exit(1);
}
const listVar = process.argv.slice(3);
const numVar  = listVar.length;

// https://nodejs.org/docs/v20.0.0/api/fs.html
const fs = require('node:fs');

const jsScript = fs.readFileSync(jsFile, 'utf8');

// https://nodejs.org/docs/v20.0.0/api/vm.html
const vm       = require('node:vm');

const context = {};
vm.createContext(context);
const script = new vm.Script(jsScript);
script.runInContext(context);

if ( numVar >= 1 ) {
    const nameVar = listVar[0];
    let json;
    if ( nameVar in  context ) {
        json = JSON.stringify(context[nameVar]); 
    } else {
        json = JSON.stringify(context);  
    }
    process.stdout.write(json);
}



