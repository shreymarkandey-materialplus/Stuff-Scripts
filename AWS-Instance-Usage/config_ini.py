import boto3
import configparser

# Create an EC2 client
ec2 = boto3.client("ec2")

# Call the describe_tags API to get all tags
response = ec2.describe_tags()

# Extract the tag names
tag_names = set(tag["Key"] for tag in response["Tags"])

# Create a new configparser instance
config = configparser.ConfigParser()

# Add the [AWS] section
config["AWS"] = {
    "region": "us-west-2"
}

# Add the [TAGS] section with the fetched tag names
config["TAGS"] = {}
for tag_name in tag_names:
    config["TAGS"][f";{tag_name}"] = ""

# Write the config to a file
with open("config.ini", "w") as config_file:
    config.write(config_file)

