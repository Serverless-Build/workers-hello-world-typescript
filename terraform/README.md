# Terraform deployment (TypeScript)

This recipe uploads JavaScript built from the same `src/index.ts` as the Wrangler deployment. Terraform 1.6+ and Cloudflare provider 5.26.x are required.

Validation: `terraform init`, `validate`, and a local plan pass with a built artifact. Live Terraform apply and the deployed response have not been verified.

1. Run `npm ci`, then `npm run check` and `npx wrangler deploy --dry-run --outdir terraform/dist --config wrangler.jsonc`. Check that `terraform/dist/index.js` exists; Terraform does not compile TypeScript.
2. Set `CLOUDFLARE_API_TOKEN` in your shell to a token with Workers Scripts Write permissions. Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars` and fill in your account ID and `workers.dev` subdomain.
3. Run `terraform -chdir=terraform init`, `terraform -chdir=terraform validate`, then `terraform -chdir=terraform plan -out=hello.tfplan` and `terraform -chdir=terraform apply hello.tfplan`.
4. Run `terraform -chdir=terraform output -raw worker_url` and `curl -i "$(terraform -chdir=terraform output -raw worker_url)"`. Check the TypeScript marker and response headers.
5. Run a second `terraform -chdir=terraform plan` to check for drift. Run `terraform -chdir=terraform destroy` to clean up.

Rebuild after source changes before planning. Terraform state, plans, and variable values are ignored by Git. Keep this Worker name separate from Wrangler and cf deployments.
