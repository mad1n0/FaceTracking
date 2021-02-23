const express = require('express');
const app = express();
const path = require('path');
const busboy = require('connect-busboy');
const bodyParser = require('body-parser');
const fs = require('fs');
// const timeout = require('connect-timeout');

const port = process.env.PORT || 5000;
const server = app.listen(port);
// increase the timeout to 4 minutes
server.timeout = 1200000;

// create data dir if not exist
const data_dir = 'data'
if (!fs.existsSync(data_dir)){
    fs.mkdirSync(data_dir);
}

app.use(busboy());
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true, parameterLimit: 50000 }));
app.use(express.static(path.join(__dirname, 'public')));

app.post('/', (req, res, next) => {

  req.busboy.on('error', next);

  req.busboy.on('field', function(fieldname, val) {

    if (fieldname === 'password') {
      const password = val;

      if (!password || password !== 'b+FRongauiv/bKy1egB8AbB2HIICNbhX5IqlbMWcfn4') {
        const err = new Error();
        err.message = 'Invalid password, please refresh and try again.';
        err.status = 400;
        return next(err);
      }
    }
  });

  req.busboy.on('file', (fieldname, file, filename, encoding, mimetype) => {
    // if filename is not truthy there is no file, redirect to error handlers
    if (!filename) {
      const err = new Error();
      err.message = 'Invalid request, missing filename.';
      err.status = 400;
      return next(err);
    }

    // Create the initial array containing the stream's chunks.
    file.fileRead = [];

    file.on('error', (err) => {
      return next(err);
    });

    file.on('data', (data) => {
      // Push every data chunk into fileRead array.
      file.fileRead.push(data);
    });

    file.on('end', () => {
      // finalBuffer contains all chunks i.e our uploaded file.
      const finalBuffer = Buffer.concat(file.fileRead);

      res.locals[fieldname] = {
        buffer: finalBuffer,
        size: finalBuffer.length,
        filename,
        mimetype,
      };
    });
  });

  req.pipe(req.busboy);

  req.busboy.on('finish', next);
}, (req, res, next) => {

  if (!res.locals.uploadedFile){
    const err = new Error();
    err.message = 'Uploaded file not found.';
    err.status = 400;
    return next(err);
  }

  const filePath = data_dir + '/' + res.locals.uploadedFile.filename;
  const body = res.locals.uploadedFile.buffer;

  fs.appendFile(filePath, body, (err) => {
    if (err) {
      console.log('Error saving file : '.concat(err));
      return next(err);
    }
    res.send('Upload completed successfully.');
  });

});
