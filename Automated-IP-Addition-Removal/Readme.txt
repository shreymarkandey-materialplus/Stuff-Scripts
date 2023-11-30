######## Opensearch/Windows ##############
#### To invoke the Lambda Function ##### 
@aws lambda invoke --function-name ip-public --invocation-type Event --payload {"ip": "57.98.76.89","description": "yo"} --region ap-southeast-2


#### To Create Alias for Lambda Function #####
#### Create Function ####
@aws alias create public-ip-add @aws lambda invoke --function-name ip-public --invocation-type Event --payload {"ip": "$ip", "description": "$description"} --region ap-southeast-2


##### To Run that Created Above Alias #####
@aws run public-ip-add --ip 57.98.76.90 --description "shrey" 
                        OR
@aws run public-ip-add 5.5.5.5 shrey


##### Points To be Noted When Creating ChatBot #####
1) Attach Exisiting role of Lambda Function 
2) In guardrail Policies use AWS-Chatbot-LambdaInvoke-Policy & AWS-Chatbot-NotificationsOnly-Policy-c1fd200e-637e-47df-b881-801fe74e628c


########## CMS-Bastion #############
#### To invoke the Lambda Function ##### 
@aws lambda invoke --function-name public-ip-cms --invocation-type Event --payload {"ip": "57.98.76.89","description": "sre"} --region ap-southeast-2


#### To Create Alias for Lambda Function #####
#### Create Function ####
@aws alias create public-ip-add-cms @aws lambda invoke --function-name public-ip-cms --invocation-type Event --payload {"ip": "$ip", "description": "$description"} --region ap-southeast-2


##### To Run that Created Above Alias #####
@aws run public-ip-add --ip 57.98.76.90 --description "shrey" 
                        OR
@aws run public-ip-add 5.5.5.5 shrey 

 



