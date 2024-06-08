# azure_ai_search_terraform
Azure AI SearchをTerraformで構築するサンプル

## azure-cli
インストールしていない場合は

```sh
brew install azure-cli
```

※ azure-cliを使用するためには認証が必要です。以下記事ではサービスプリンシパルを作成し実行する手順を記載しているので必要であれば参考にしてください。

[【Azure】AI SearchをTerraformで構築する](https://zenn.dev/i_shinya/articles/928687c8b1c14d)

## Terraform

```sh
terraform init
```

```sh
terraform plan
```

```sh
terraform apply
```

```sh
terraform destroy
```
