# This script creates the storage account where the terraform state will be stored. 
# It also creates a service principal to be used for deploying the azure resources using terraform
# The credentials of this principal must then be stored as secrets in the github repository.

# Define variables
randomSuffix=$(LC_ALL=C tr -dc 'a-z' < /dev/urandom | head -c 4) # Generates a random 4-character suffix
resourceGroupName="rg-smartoffice-tfstate-$randomSuffix"
location="westeurope"
storageAccountName="smartofficetfstate$randomSuffix"
containerName="tfstate"
servicePrincipalName="deploymentuser"

# Retrieve subscription id
subscriptionId=$(az account show --query id --output tsv)

# Create a resource group (if it doesn't already exist)
az group create -n $resourceGroupName --location $location
 
# Create a storage account
az storage account create \
    -g $resourceGroupName \
    -n $storageAccountName \
    --location $location \
    --sku Standard_LRS \
    --allow-blob-public-access false
 
# Get the storage account key
accountKey=$(az storage account keys list -g $resourceGroupName --account-name $storageAccountName --query "[0].value" --output tsv)

# Create a storage container
az storage container create \
    -n $containerName \
    --account-name $storageAccountName \
    --account-key $accountKey

# Create Service Principal 
az ad sp create-for-rbac \
    -n $servicePrincipalName \
    --role contributor \
    --scopes "/subscriptions/$subscriptionId"

az ad sp create-for-rbac -n sp-smartoffice --role contributor --role rg-temp-aruv --scopes "/subscriptions/$subscriptionId"

# Create service principal
service_principal=$(az ad sp create-for-rbac -n sp-smartoffice-githubdeploy --role contributor --scope "/subscriptions/$subscriptionId" --json-auth --query '{appId:appId, tenant:tenant, secret:password}' -o tsv)



echo $service_principal

app_id = $service_principal.appId

# Assign User Access Administrator role
az role assignment create \
    --assignee "$app_id" \
    --role "User Access Administrator" \
    --scope "/subscriptions/$subscriptionId" \
    --condition-version "2.0" \
    --condition "((!(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {516239f1-63e1-4d78-a4de-a74fb236a071, 5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b, 00482a5a-887f-4fb3-b363-3b7fe8e74483, 4633458b-17de-408a-b874-0445c86b69e6})) AND ((!(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {516239f1-63e1-4d78-a4de-a74fb236a071, 5ae67dd6-50cb-40e7-96ff-dc2bfa4b606b, 00482a5a-887f-4fb3-b363-3b7fe8e74483, 4633458b-17de-408a-b874-0445c86b69e6}))"

# az role assignment list --assignee "$app_id"