// ----------------------------------------------------------------------------
// Required Variables
// ----------------------------------------------------------------------------
variable "gcp_project" {
  description = "The name of the GCP project to use"
  type        = string
}

// ----------------------------------------------------------------------------
// Optional Variables
// ----------------------------------------------------------------------------
variable "cluster_name" {
  description = "Name of the Kubernetes cluster to create"
  type        = string
  default     = ""
}

variable "zone" {
  description = "Zone in which to create the cluster (deprecated, use cluster_location instead)"
  type        = string
  default     = ""
}

variable "cluster_location" {
  description = "The location (region or zone) in which the cluster master will be created. If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_network" {
  description = "The name of the network (VPC) to which the cluster is connected"
  type        = string
  default     = "default"
}

variable "cluster_subnetwork" {
  description = "The name of the subnetwork to which the cluster is connected. Leave blank when using the 'default' vpc to generate a subnet for your cluster"
  type        = string
  default     = ""
}

variable "bucket_location" {
  description = "Bucket location for storage"
  type        = string
  default     = "US"
}

variable "jenkins_x_namespace" {
  description = "Kubernetes namespace to install Jenkins X in"
  type        = string
  default     = "jx"
}

variable "force_destroy" {
  description = "Flag to determine whether storage buckets get forcefully destroyed"
  type        = bool
  default     = false
}

variable "parent_domain" {
  description = "**Deprecated** Please use apex_domain variable instead.r"
  type        = string
  default     = ""
}

variable "apex_domain" {
  description = "The parent / apex domain to be used for the cluster"
  type        = string
  default     = ""
}

variable "parent_domain_gcp_project" {
  description = "**Deprecated** Please use apex_domain_gcp_project variable instead."
  type        = string
  default     = ""
}

variable "apex_domain_gcp_project" {
  description = "The GCP project the apex domain is managed by, used to write recordsets for a subdomain if set.  Defaults to current project."
  type        = string
  default     = ""
}

variable "subdomain" {
  description = "Optional sub domain for the installation"
  type        = string
  default     = ""
}

variable "apex_domain_integration_enabled" {
  description = "Flag that when set attempts to create delegation records in apex domain to point to domain created by this module"
  type        = bool
  default     = true
}

variable "tls_email" {
  description = "Email used by Let's Encrypt. Required for TLS when apex_domain is specified"
  type        = string
  default     = ""
}

variable "create_ui_sa" {
  description = "Whether the service accounts for the UI should be created"
  type        = bool
  default     = true
}

// ----------------------------------------------------------------------------
// Vault
// ----------------------------------------------------------------------------
variable "vault_url" {
  description = "URL to an external Vault instance in case Jenkins X shall not create its own system Vault"
  type        = string
  default     = ""
}

// ----------------------------------------------------------------------------
// Velero/backup
// ----------------------------------------------------------------------------
variable "enable_backup" {
  description = "Whether or not Velero backups should be enabled"
  type        = bool
  default     = false
}

variable "velero_namespace" {
  description = "Kubernetes namespace for Velero"
  type        = string
  default     = "velero"
}

variable "velero_schedule" {
  description = "The Velero backup schedule in cron notation to be set in the Velero Schedule CRD (see [default-backup.yaml](https://github.com/jenkins-x/jenkins-x-boot-config/blob/master/systems/velero-backups/templates/default-backup.yaml))"
  type        = string
  default     = "0 * * * *"
}

variable "velero_ttl" {
  description = "The the lifetime of a velero backup to be set in the Velero Schedule CRD (see [default-backup.yaml](https://github.com/jenkins-x/jenkins-x-boot-config/blob/master/systems/velero-backups/templates/default-backup))"
  type        = string
  default     = "720h0m0s"
}

// ----------------------------------------------------------------------------
// cluster configuration
// ----------------------------------------------------------------------------
variable "enable_private_endpoint" {
  type        = bool
  description = "(Beta) Whether the master's internal IP address is used as the cluster endpoint. Requires VPC-native"
  default     = false
}

variable "enable_private_nodes" {
  type        = bool
  description = "(Beta) Whether nodes have internal IP addresses only. Requires VPC-native"
  default     = false
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network.  This range must not overlap with any other ranges in use within the cluster's network, and it must be a /28 subnet"
  default     = "10.0.0.0/28"
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically allowlists)."
  default     = []
}

variable "ip_range_pods" {
  type        = string
  description = "The IP range in CIDR notation to use for pods. Set to /netmask (e.g. /18) to have a range chosen with a specific netmask. Enables VPC-native"
  default     = ""
}

# Max Pods per Node --- CIDR Range per Node
# 8                     /28
# 9–16                  /27
# 17–32                 /26
# 33–64                 /25
# 65–110                /24
variable "max_pods_per_node" {
  type        = number
  description = "Max gke nodes = 2^($CIDR_RANGE_PER_NODE-$POD_NETWORK_CIDR) (see [gke docs](https://cloud.google.com/kubernetes-engine/docs/how-to/flexible-pod-cidr))"
  default     = 64 # 2^(25-21) = 16 max nodes
}

variable "ip_range_services" {
  type        = string
  description = "The IP range in CIDR notation use for services. Set to /netmask (e.g. /21) to have a range chosen with a specific netmask. Enables VPC-native"
  default     = ""
}

variable "node_machine_type" {
  description = "Node type for the Kubernetes cluster"
  type        = string
  default     = "n1-standard-2"
}

variable "node_preemptible" {
  description = "Use preemptible nodes"
  type        = bool
  default     = false
}

variable "node_spot" {
  description = "Use spot nodes"
  type        = bool
  default     = false
}

// Recommended to initially create this pool because the auth scops with elevated permissions are neccessary for creating the initial buckets and other resources, then you can delete it.
variable "enable_primary_node_pool" {
  description = "create a node pool for primary nodes if disabled you must create your own pool"
  type        = bool
  default     = true
}

variable "initial_cluster_node_count" {
  description = "Initial number of cluster nodes"
  type        = number
  default     = 3
}

variable "initial_primary_node_pool_node_count" {
  description = "Initial primary node pool nodes"
  type        = number
  default     = 3
}

variable "autoscaler_min_node_count" {
  description = "primary node pool min nodes"
  type        = number
  default     = 3
}

variable "autoscaler_max_node_count" {
  description = "primary node pool max nodes"
  type        = number
  default     = 5
}

variable "autoscaler_location_policy" {
  description = "location policy for primary node pool"
  type        = string
  default     = "ANY"
}

variable "node_disk_size" {
  description = "Node disk size in GB"
  type        = string
  default     = "100"
}

variable "node_disk_type" {
  description = "Node disk type, either pd-standard or pd-ssd"
  type        = string
  default     = "pd-standard"
}

variable "release_channel" {
  description = "The GKE release channel to subscribe to.  See https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels"
  type        = string
  default     = "REGULAR"
}

variable "resource_labels" {
  description = "Set of labels to be applied to the cluster"
  type        = map(any)
  default     = {}
}

// ----------------------------------------------------------------------------
// jx-requirements.yml specific variables only used for template rendering
// ----------------------------------------------------------------------------
variable "git_owner_requirement_repos" {
  description = "The git id of the owner for the requirement repositories"
  type        = string
  default     = ""
}

variable "dev_env_approvers" {
  description = "List of git users allowed to approve pull request for dev enviornment repository"
  type        = list(string)
  default     = []
}

variable "lets_encrypt_production" {
  description = "Flag to determine wether or not to use the Let's Encrypt production server."
  type        = bool
  default     = true
}

variable "webhook" {
  description = "Jenkins X webhook handler for git provider"
  type        = string
  default     = "lighthouse"
}

variable "version_stream_url" {
  description = "The URL for the version stream to use when booting Jenkins X. See https://jenkins-x.io/docs/concepts/version-stream/"
  type        = string
  default     = "https://github.com/jenkins-x/jenkins-x-versions.git"
}

variable "version_stream_ref" {
  description = "The git ref for version stream to use when booting Jenkins X. See https://jenkins-x.io/docs/concepts/version-stream/"
  type        = string
  default     = "master"
}

variable "jx2" {
  description = "Is a Jenkins X 2 install"
  type        = bool
  default     = true
}

variable "gsm" {
  description = "Enables Google Secrets Manager, not available with JX2"
  type        = bool
  default     = false
}

variable "jx_git_url" {
  description = "URL for the Jenins X cluster git repository"
  type        = string
  default     = ""
}

variable "jx_bot_username" {
  description = "Bot username used to interact with the Jenkins X cluster git repository"
  type        = string
  default     = ""
}

variable "jx_bot_token" {
  description = "Bot token used to interact with the Jenkins X cluster git repository"
  type        = string
  default     = ""
}

variable "jx_git_operator_version" {
  description = "The jx-git-operator helm chart version"
  type        = string
  default     = "0.0.192"
}

variable "kuberhealthy" {
  description = "Enables Kuberhealthy helm installation"
  type        = bool
  default     = true
}
