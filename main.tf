terraform {
  required_version = ">= 1.8.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.107.0" # 執筆時点の最新バージョン
    }
  }
}

provider "azurerm" {
  features {}
}

variable "name" {
  type        = string
  description = "The name of the search service."
  default     = "azure-ai-search"
}

variable "location" {
  type        = string
  description = "Location for all resources."
  default     = "japaneast"
}

variable "sku" {
  type        = string
  description = "The pricing tier of the search service you want to create (for example, basic or standard)."
  default     = "free"
  validation {
    condition = contains([
      "free", "basic", "standard", "standard2", "standard3", "storage_optimized_l1", "storage_optimized_l2"
    ], var.sku)
    error_message = "The sku must be one of the following values: free, basic, standard, standard2, standard3, storage_optimized_l1, storage_optimized_l2."
  }
}

variable "replica_count" {
  type        = number
  description = "Replicas distribute search workloads across the service. You need at least two replicas to support high availability of query workloads (not applicable to the free tier)."
  default     = 1
  validation {
    condition     = var.replica_count >= 1 && var.replica_count <= 12
    error_message = "The replica_count must be between 1 and 12."
  }
}

variable "partition_count" {
  type        = number
  description = "Partitions allow for scaling of document count as well as faster indexing by sharding your index over multiple search units."
  default     = 1
  validation {
    condition     = contains([1, 2, 3, 4, 6, 12], var.partition_count)
    error_message = "The partition_count must be one of the following values: 1, 2, 3, 4, 6, 12."
  }
}

variable "semantics_search_sku" {
  type        = string
  description = "The pricing tier of the semantic search feature."
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.semantics_search_sku)
    error_message = "The semantics_search_sku must be one of the following values: free, standard."
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-resource-group"
  location = var.location
}

resource "azurerm_search_service" "search" {
  name                          = "${var.name}-search"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  sku                           = var.sku
  replica_count                 = var.replica_count
  partition_count               = var.partition_count
  public_network_access_enabled = true # 公開設定、プライベートネットワークで使用する場合はfalse
  # freeの場合はnullとしないとエラーになるため、条件分岐を追加
  semantic_search_sku           = var.sku != "free" ? var.semantics_search_sku : null
}
