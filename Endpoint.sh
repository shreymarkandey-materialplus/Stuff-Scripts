#!/bin/bash

#  ██╗ ██╗     ███████╗██████╗ ██╗     ██╗ █████╗ ███╗   ██╗
# ████████╗    ██╔════╝██╔══██╗██║     ██║██╔══██╗████╗  ██║
# ╚██╔═██╔╝    ███████╗██████╔╝██║     ██║███████║██╔██╗ ██║
# ████████╗    ╚════██║██╔══██╗██║██   ██║██╔══██║██║╚██╗██║
# ╚██╔═██╔╝    ███████║██║  ██║██║╚█████╔╝██║  ██║██║ ╚████║
#  ╚═╝ ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝ ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝
#  ██╗ ██╗     ████████╗███████╗ ██████╗██╗  ██╗███╗   ██╗ ██████╗ ██╗      ██████╗  ██████╗ ██╗███████╗███████╗
# ████████╗    ╚══██╔══╝██╔════╝██╔════╝██║  ██║████╗  ██║██╔═══██╗██║     ██╔═══██╗██╔════╝ ██║██╔════╝██╔════╝
# ╚██╔═██╔╝       ██║   █████╗  ██║     ███████║██╔██╗ ██║██║   ██║██║     ██║   ██║██║  ███╗██║█████╗  ███████╗
# ████████╗       ██║   ██╔══╝  ██║     ██╔══██║██║╚██╗██║██║   ██║██║     ██║   ██║██║   ██║██║██╔══╝  ╚════██║
# ╚██╔═██╔╝       ██║   ███████╗╚██████╗██║  ██║██║ ╚████║╚██████╔╝███████╗╚██████╔╝╚██████╔╝██║███████╗███████║
#  ╚═╝ ╚═╝        ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚══════╝


#### Copyright (c) 2023       ####
#### All rights reserved.     ####
#### Author : Shrey Markandey ####

set -e
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

AWS_REGION="ap-southeast-2"

# Array of instance tags
INSTANCE_TAGS=("RDP-Jumphost" "Win-JumpHost" "Win-JumpHost-1")

# Initialize message variable
MESSAGE=""

# Function to append to the message
append_message() {
    local instance_tag="$1"
    local public_dns="$2"

    if [ -n "$public_dns" ]; then
        MESSAGE+="<b>Name:</b> $instance_tag <br> <b>For Connection Use This:</b> $public_dns \n\n"
    else
        MESSAGE+="Instance not found with tag: $instance_tag\n\n"
    fi
}

# Replace with your Microsoft Teams webhook URL
TEAMS_WEBHOOK_URL="https://lrw1.webhook.office.com/webhookb2/941fc57b-ba1d-4f9d-b568-45805a5b2388@98f2bd9e-cd04-40db-9cee-2f94e6e676c1/IncomingWebhook/bceb3c6473d042048975d71d3c18fb22/26d5b84b-87e8-4f0a-9e4e-d37f21ed7305"

# Loop through the instance tags
for INSTANCE_TAG in "${INSTANCE_TAGS[@]}"; do
    # Get the public IPv4 DNS of the instance
    PUBLIC_DNS=$(aws ec2 describe-instances --region "$AWS_REGION" \
        --filters "Name=tag:Name,Values=$INSTANCE_TAG" \
        --query "Reservations[0].Instances[0].PublicDnsName" \
        --output text)

    # Call the function to append to the message
    append_message "$INSTANCE_TAG" "$PUBLIC_DNS"
done

# Send the combined message to Microsoft Teams with HTML content
curl -H "Content-Type: application/json" -d "{\"text\":\"$MESSAGE\",\"textFormat\":\"html\"}" "$TEAMS_WEBHOOK_URL"

echo "Message sent to Teams channel."