resource "kubernetes_namespace" "metallb" {
  metadata {
    name = "metallb"
  }
}

resource "helm_release" "metallb" {
  name       = "metallb-helm"
  namespace  = kubernetes_namespace.metallb.metadata.0.name
  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  version    = "0.13.5"
}

resource "kubectl_manifest" "metallb-pool" {
  #   namespace = "metallb"
  wait              = true
  server_side_apply = true
  yaml_body         = <<-EOF
    apiVersion: metallb.io/v1beta1
    kind: IPAddressPool
    metadata:
        name: metallb-pool
        namespace: metallb
    spec:
        addresses:
        - 192.168.15.160-192.168.15.170
    EOF
}

resource "kubectl_manifest" "metallb-l2-announce" {
  #   namespace = "metallb"
  wait              = true
  server_side_apply = true
  yaml_body         = <<-EOF
    apiVersion: metallb.io/v1beta1
    kind: L2Advertisement
    metadata:
      name: metallb-announce
      namespace: metallb
    spec:
      ipAddressPools:
      - metallb-pool
    EOF
}

# resource "kubernetes_manifest" "metallb-pool" {
#   manifest = {
#     "apiVersion" = "metallb.io/v1beta1"
#     "kind"       = "IPAddressPool"
#     "metadata" = {
#       "name"      = "metalb-pool"
#       "namespace" = "metallb"
#     }

#     spec = {
#       addresses = ["192.168.15.160-192.168.15.170"]
#     }
#   }
# }


# resource "kubernetes_manifest" "metallb-pool-l2-announce" {
#   manifest = {
#     "apiVersion" = "metallb.io/v1beta1"
#     "kind"       = "L2Advertisement"
#     "metadata" = {
#       "name"      = "metallb-pool-announce"
#       "namespace" = "metallb"
#     }
#     spec = {
#       ipAddressPools = ["metalb-pool"]
#     }
#   }
# }