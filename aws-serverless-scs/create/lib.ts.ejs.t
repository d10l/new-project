---
to: lib.ts
---
import * as archiver from 'archiver';
import * as fs from 'fs';


function zipFolder(pathToFolder: string, ignoredFilesAtDeployment: Array<string>, outputName: string) {
  // create a file to stream archive data to.
  var output = fs.createWriteStream(`${pathToFolder}/${outputName}.zip`);
  var archive = archiver('zip', {
    zlib: {
      level: 9
    } // Sets the compression level.
  });

  // listen for all archive data to be written 'close' event is fired only when a
  // file descriptor is involved
  output.on('close', function () { });

  // This event is fired when the data source is drained no matter what was the
  // data source. It is not part of this library but rather from the NodeJS Stream
  // API. @see: https://nodejs.org/api/stream.html#stream_event_end
  output.on('end', function () { });

  // good practice to catch warnings (ie stat failures and other non-blocking
  // errors)
  archive.on('warning', function (err) {
    if (err.code === 'ENOENT') {
      // log warning
    } else {
      // throw error
      throw err;
    }
  });

  // good practice to catch this error explicitly
  archive.on('error', function (err) {
    throw err;
  });

  // pipe archive data to the file
  archive.pipe(output);

  archive.glob(`**/*`, {
    cwd: `${pathToFolder}`,
    root: `${pathToFolder}`,
    ignore: ignoredFilesAtDeployment
  });
  archive.finalize();
}

export function packageLambda(pathToLambdaFolder: string, configFileName: string) {
  const configFile = fs.readFileSync(`${pathToLambdaFolder}/${configFileName}`);
  const parsedConfig = JSON.parse(configFile.toString());
  zipFolder(pathToLambdaFolder, parsedConfig.ignoredFilesAtDeployment, parsedConfig.name);
}