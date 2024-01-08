const AWS = require('aws-sdk');

exports.handler = async (event) => {
    try {
        // AWS S3 configuration
        const s3 = new AWS.S3();

        // AWS DynamoDB configuration
        const dynamodb = new AWS.DynamoDB();

        // S3 Bucket details
        const s3BucketName = 'your-s3-bucket-name';

        // DynamoDB Table details
        const dynamoDBTableName = 'your-dynamodb-table-name';

        // Fetch number of objects in S3 bucket
        const s3Objects = await s3.listObjectsV2({ Bucket: s3BucketName }).promise();
        const numberOfS3Objects = s3Objects.Contents.length;

        // Fetch number of items in DynamoDB table
        const dynamoDBItems = await dynamodb.describeTable({ TableName: dynamoDBTableName }).promise();
        const numberOfDynamoDBItems = dynamoDBItems.Table.ItemCount;

        return {
            statusCode: 200,
            body: JSON.stringify({
                numberOfS3Objects,
                numberOfDynamoDBItems
            })
        };
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: 'Internal Server Error' })
        };
    }
};
