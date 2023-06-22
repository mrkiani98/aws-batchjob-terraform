var AWS = require('aws-sdk');

// var credentials = new AWS.SharedIniFileCredentials({profile: 'default'});
// AWS.config.credentials = credentials;
// let config = require('./config/config');
// AWS.config.update(config.aws_remote_config);

s3 = new AWS.S3({apiVersion: '2006-03-01'});

var bucketParams = {
    Bucket : `${process.env.SRC_BUCKET}`,
  };
  
  // Call S3 to obtain a list of the objects in the bucket
  s3.listObjects(bucketParams, function(err, data) {
    if (err) {
      console.log("Error", err);
    } else {
      console.log("Success", data.Contents[0]);
    for(var i = 0; i < data.Contents.length;i++){
        var params = {
            Bucket: `${process.env.DST_BUCKET}`, 
            CopySource: `${process.env.SRC_BUCKET}/${data.Contents[i].Key}`,
            Key: `${data.Contents[i].Key}`
           };
           console.log(`${data.Contents[i].Key}`)
           s3.copyObject(params, function(err, data) {
             if (err) console.log(err, err.stack); // an error occurred
             else     console.log(data);           // successful response
           }); 

    }
    }
  });