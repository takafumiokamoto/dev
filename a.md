# API Gateway Access Logs to EFS
Created: 8/6/2025, 9:02:22 AM
Last Updated: 8/6/2025, 6:20:57 PM
---

### User

I would like to move access log in AWS API gateway to EFS exactly as is. I know this is not straightforward and against the best practices but I have to do this. I want to ask you what is the most straightforward way to achieve this? I already have required resources except for lambda(if you need it)


---

### Assistant (grok-v4)

I understand you're looking to redirect AWS API Gateway access logs to an Amazon EFS (Elastic File System) volume in their exact, unaltered format. As you mentioned, this isn't a native feature of API Gateway (which primarily supports logging to CloudWatch Logs, Kinesis, or Firehose), and it's generally not recommended due to potential performance overhead, costs, and complexity compared to using CloudWatch or S3 for log storage. However, since you need to proceed, I'll outline the most straightforward approach below. This method uses CloudWatch Logs as an intermediary (the default for API Gateway access logs) and a Lambda function to stream and write the logs to EFS. Lambda is necessary here because it can mount EFS directly and handle the log processing in real-time.

This assumes you already have:
- An API Gateway with access logging enabled (or ready to enable) to a CloudWatch Logs group.
- An EFS file system set up in a VPC, with appropriate mount targets, security groups, and access points (if needed for Lambda).
- IAM roles/policies for the necessary permissions (we'll cover what to add).

If any of these aren't in place, let me know for more details. Let's break it down step by step.

### Step 1: Ensure API Gateway Access Logging is Configured to CloudWatch Logs
If not already done:
1. In the AWS Management Console, navigate to your API Gateway stage.
2. Under **Logs/Tracing**, enable **CloudWatch Logs** and set the log level to `INFO` (or higher) to capture access logs.
3. Specify a custom access log format if needed (e.g., to match your "exactly as is" requirement). For example, use something like:
   ```
   { "requestId": "$context.requestId", "ip": "$context.identity.sourceIp", "caller": "$context.identity.caller", "user": "$context.identity.user", "requestTime": "$context.requestTime", "httpMethod": "$context.httpMethod", "resourcePath": "$context.resourcePath", "status": "$context.status", "protocol": "$context.protocol", "responseLength": "$context.responseLength" }
   ```
   This will log in JSON format to a CloudWatch Logs group (e.g., `/aws/apigateway/your-api-name/access-logs`).
4. Deploy the stage for changes to take effect.

This ensures logs are generated in CloudWatch exactly as you'd see them natively.

### Step 2: Create a Lambda Function to Stream Logs to EFS
Since you don't have a Lambda yet, we'll create one. This is the core of the solution—Lambda will subscribe to the CloudWatch Logs stream, process events, and write them to a file on EFS.

#### Prerequisites for Lambda + EFS Integration
- **VPC Configuration**: Your Lambda must be in the same VPC as your EFS mount targets. Ensure the Lambda's security group allows outbound NFS traffic (TCP port 2049) to the EFS security group.
- **EFS Access**: Create an EFS access point if you want to restrict the Lambda to a specific directory (recommended for security).
- **IAM Permissions**:
  - Attach policies to the Lambda execution role for:
    - `logs:CreateLogGroup`, `logs:CreateLogStream`, `logs:PutLogEvents` (for Lambda's own logs).
    - `elasticfilesystem:ClientMount`, `elasticfilesystem:ClientWrite` (for EFS access).
    - `ec2:CreateNetworkInterface`, `ec2:DescribeNetworkInterfaces`, `ec2:DeleteNetworkInterface` (for VPC access).

#### Create the Lambda Function
1. In the AWS Console, go to Lambda > **Create function**.
2. Choose **Author from scratch**, name it (e.g., `APIGatewayLogsToEFS`), and select a runtime like Node.js 18.x or Python 3.x (I'll provide code for both).
3. Under **Advanced settings**, enable VPC and select the subnets/security groups that can access your EFS.
4. Under **File systems**, add your EFS file system:
   - Select the EFS file system and an access point (if using one).
   - Specify a local mount path, e.g., `/mnt/efs`.
5. Create the function.

#### Lambda Code
The code will:
- Receive batched log events from CloudWatch.
- Decode and extract the log messages.
- Append them "exactly as is" to a file on EFS (e.g., `/mnt/efs/access-logs.log`).

Here's sample code. I've formatted it with Prettier (print width 80) for readability.

**Option 1: Node.js Runtime**
```javascript
const fs = require('fs');
const zlib = require('zlib');

exports.handler = async (event, context) => {
  const payload = Buffer.from(event.awslogs.data, 'base64');
  const decompressed = zlib.gunzipSync(payload);
  const parsed = JSON.parse(decompressed.toString('utf8'));

  const logEvents = parsed.logEvents;

  const logFilePath = '/mnt/efs/access-logs.log'; // Adjust as needed

  try {
    for (const logEvent of logEvents) {
      // Write each log message exactly as is, with a newline
      fs.appendFileSync(logFilePath, `${logEvent.message}\n`);
    }
    console.log(`Successfully wrote ${logEvents.length} log events to EFS.`);
  } catch (error) {
    console.error('Error writing to EFS:', error);
    throw error;
  }
};
```

**Option 2: Python Runtime**
```python
import base64
import gzip
import json
import os

def lambda_handler(event, context):
    compressed_payload = base64.b64decode(event['awslogs']['data'])
    uncompressed_payload = gzip.decompress(compressed_payload)
    log_data = json.loads(uncompressed_payload)

    log_events = log_data['logEvents']

    log_file_path = '/mnt/efs/access-logs.log'  # Adjust as needed

    try:
        with open(log_file_path, 'a') as log_file:
            for event in log_events:
                # Write each log message exactly as is, with a newline
                log_file.write(f"{event['message']}\n")
        print(f"Successfully wrote {len(log_events)} log events to EFS.")
    except Exception as e:
        print(f"Error writing to EFS: {e}")
        raise e
```

- **Notes on Code**:
  - This appends logs to a single file for simplicity. You could enhance it to rotate files (e.g., by date) or handle concurrency, but this keeps it straightforward.
  - CloudWatch sends logs in batches, compressed and base64-encoded, so we decompress and parse them.
  - Test the function with sample input from the Lambda console to ensure EFS mounting works.

### Step 3: Set Up CloudWatch Logs Subscription to Trigger Lambda
1. Go to CloudWatch > **Log groups** > Select your API Gateway log group.
2. Under **Subscription filters**, choose **Create** > **Lambda function**.
3. Select your new Lambda function.
4. Optionally, add a filter pattern (e.g., to match specific log formats), but for "exactly as is," you can leave it blank to capture everything.
5. Name the subscription and create it.

This will stream logs in near real-time to Lambda, which writes them to EFS.

### Step 4: Testing and Monitoring
- Invoke your API Gateway to generate logs.
- Check CloudWatch Logs to confirm they're being generated.
- Verify the file on EFS (e.g., via an EC2 instance mounted to EFS or AWS Systems Manager).
- Monitor Lambda invocations in CloudWatch for errors, and set up alarms if needed.
- Be aware of costs: Lambda invocations, EFS storage/throughput, and CloudWatch data ingestion.

### Potential Challenges and Tips
- **Performance**: EFS has latency compared to S3 or CloudWatch—test for your workload. If logs are high-volume, consider batching or using EFS burst credits.
- **Concurrency**: Lambda handles concurrent executions, but EFS file appends could lead to contention; use unique file names per invocation if needed.
- **Security**: Ensure least-privilege IAM and encrypt EFS at rest/transit.
- **Alternatives if This Feels Too Complex**: If Lambda isn't ideal, you could use CloudWatch Logs export to S3, then a separate process (e.g., EC2 or ECS task) to copy to EFS—but that's less straightforward than this streaming approach.
- **Best Practice Reminder**: Long-term, consider if S3 or CloudWatch Logs with queries/exports could meet your needs without EFS.

If this doesn't align with your setup or you run into issues (e.g., with VPC/EFS config), provide more details, and I'll refine it. What specific format are your access logs in currently?


---
