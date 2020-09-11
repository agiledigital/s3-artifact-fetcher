# S3 Artifact Fetcher

An image that can be used as an init container to fetch artifacts for runner containers from S3.

The S3 URL to fetch the artifact from should be specified with the SOURCE_URL environment variable (e.g. "s3://some-bucket/some/folder). It should be a folder that will be synced into the container, rather than a singular file.

It will use the [standard AWS environment variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html) for authentication (e.g. AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION).

### Usage Example (k8s)

    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: my-app-deployment
    labels:
      app: my-app
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: my-app
      template:
        metadata:
          labels:
            app: my-app
        spec:
          containers:
            - name: api
              image: runner
          initContainers:
            - name: fetcher
              image: s3-artifact-fetcher
              env:
                - name: SOURCE_URL
                  value: "s3://{your s3 bucket name}/{path to your artifacts}"
                - name: AWS_ACCESS_KEY_ID
                  value: ABCDEF
                - name: AWS_SECRET_ACCESS_KEY
                  valueFrom:
                    secretKeyRef:
                      name: aws-secrets
                      key: artifacts-secret-key
                - name: AWS_DEFAULT_REGION
                  value: {your aws region}
