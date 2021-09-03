import logging


def upload_to_s3(bucket_name, upload_key, content, client):
    try:
        response = client.put_object(
            ACL='private',
            Body=content,
            Bucket=bucket_name,
            Key=upload_key,
            ServerSideEncryption='AES256',
            StorageClass='STANDARD',
        )
        return response
    except:
        msg = f"Could not upload to S3 path: {bucket_name}/{upload_key}"
        logging.error(msg)
        raise Exception(msg)