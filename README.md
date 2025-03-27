- Login to Microsoft Azure as Service Principal
az login --service-principal

- Environment Variables are exported as following:

export ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export ARM_CLIENT_SECRET="12345678-0000-0000-0000-000000000000"
export ARM_TENANT_ID="10000000-0000-0000-0000-000000000000"
export ARM_SUBSCRIPTION_ID="20000000-0000-0000-0000-000000000000"

- Generate SSH key pair to connect with Azure

SSH KEY PAIR
ssh-keygen -t rsa -b 4096 -C "yourmail@address.com"
- Use it in /// main.tf :114
