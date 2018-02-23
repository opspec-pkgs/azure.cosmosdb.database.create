#!/usr/bin/env sh

### begin login
loginCmd='az login -u "$loginId" -p "$loginSecret"'

# handle opts
if [ "$loginTenantId" != " " ]; then
    loginCmd=$(printf "%s --tenant %s" "$loginCmd" "$loginTenantId")
fi

case "$loginType" in
    "user")
        echo "logging in as user"
        ;;
    "sp")
        echo "logging in as service principal"
        loginCmd=$(printf "%s --service-principal" "$loginCmd")
        ;;
esac
eval "$loginCmd" >/dev/null

echo "setting default subscription"
az account set --subscription "$subscriptionId"
### end login

echo "checking for exiting cosmos db database"
if [ "$(az cosmosdb database show --db-name "$name" --name "$cosmosDbAccountName" --resource-group "$resourceGroup")" != "" ]
then
  echo "found exiting cosmos db database with same name"
else
  echo "creating cosmos db database"
  az cosmosdb database create \
    --db-name "$name" \
    --name "$cosmosDbAccountName" \
    --resource-group-name "$resourceGroup"
fi
