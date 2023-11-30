import boto3

def lambda_handler(event, context):
    SECURITY_GROUP_ID = "sg-0dd787441ab5f35e2"
    PUBLIC_IP = event['ip']
    DESCRIPTION = event['description']
    
    ec2 = boto3.client('ec2')

    ##### List existing ingress rules for the security group
    response = ec2.describe_security_groups(GroupIds=[SECURITY_GROUP_ID])
    existing_ingress_rules = response['SecurityGroups'][0]['IpPermissions']

    #### Create a new ingress rule to be added
    new_ingress_rule = {
        'IpProtocol': 'tcp',
        'FromPort': 3389,
        'ToPort': 3389,
        'IpRanges': [
            {
                'CidrIp': f'{PUBLIC_IP}/32',
                'Description': DESCRIPTION,
            },
        ],
    }

    #### Create a list to store the new rule and rules to be removed
    rules_to_authorize = [new_ingress_rule]
    rules_to_remove = []

    #### Check if a rule with the same description exists
    for rule in existing_ingress_rules:
        for ip_range in rule.get('IpRanges', []):
            if ip_range.get('Description') == DESCRIPTION:
                # Create a copy of the rule to remove only the specific IP range
                rule_to_remove = rule.copy()
                rule_to_remove['IpRanges'] = [ip_range]
                rules_to_remove.append(rule_to_remove)

    # Revoke existing rules with the same description
    for rule_to_remove in rules_to_remove:
        ec2.revoke_security_group_ingress(
            GroupId=SECURITY_GROUP_ID,
            IpPermissions=[rule_to_remove]
        )

    # Authorize the new ingress rule
    ec2.authorize_security_group_ingress(
        GroupId=SECURITY_GROUP_ID,
        IpPermissions=rules_to_authorize
    )

    return {
        'statusCode': 200,
        'body': 'Ingress rules updated successfully.'
    }
