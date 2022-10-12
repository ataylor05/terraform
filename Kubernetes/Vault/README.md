# terraform-kubernetes-vault
A Terraform module to deploy Vault on Kubernetes with helm.

## Environment Variables
The follwing environment variables should be set to use the Vault deployment.
```
export VAULT_ADDR=https://vault.teokyllc.internal
export VAULT_TOKEN=s.y65<omitted>

$env:VAULT_ADDR = "https://vault.teokyllc.internal
$env:VAULT_TOKEN = "s.y65<omitted>"
```
<br> 

## Using this module
This is an example of using this module.<br>

```
module "vault" {
  source                = "github.com/teokyllc/terraform-kubernetes-vault"
  vault_namespace       = var.vault_namespace
  vault_values_filename = var.vault_values_filename
  vault_crt             = var.vault_crt
  vault_key             = var.vault_key
  vault_ca              = var.vault_ca
  registry_server       = var.registry_server
  registry_username     = var.registry_username
  registry_password     = var.registry_password
}
```


variable "vault_config" {
  type    = string
  description = "The vault HCL config."
  sensitive = true
}


## Initializing a new Vault instance
If the storage backend is new, you will need to init it which gives you the root key and unseal keys.<br>
```
kubectl -n vault exec -ti vault-0 -- vault operator init
```
<br>


## Unsealing a Vault instance
The Vault can be unsealed either by putting unseal keys into the UI, or with CLI commands as shown below.<br>
```
export VAULT_ADDR=https://vault.teokyllc.internal
kubectl -n vault exec -ti vault-0 -- vault operator unseal <Unseal_Key_1>
kubectl -n vault exec -ti vault-0 -- vault operator unseal <Unseal_Key_2>
kubectl -n vault exec -ti vault-0 -- vault operator unseal <Unseal_Key_3>
```
<br>


## Vault Intermediate CA
```
vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int

cat vault-intermediate-ca.key > vault-init-ca.pem
cat vault-intermediate-ca.crt >> vault-init-ca.pem
 
vault write pki_int/intermediate/set-signed certificate=@vault-init-ca.pem

vault write pki_int/roles/teokyllc-internal allowed_domains="teokyllc.internal" allow_subdomains=true max_ttl="720h"

# Test new cert request
vault write pki_int/issue/teokyllc-internal common_name="test.teokyllc.internal" ttl="24h"
vault write pki_int/revoke serial_number=<serial_number>
vault write pki_int/tidy tidy_cert_store=true tidy_revoked_certs=true
```
<br>

## Removal
```
helm uninstall vault --namespace vault
```
<br>
