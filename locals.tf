locals {
  name = "karpenter-topology-issue"

  profile  = "ssup"
  region   = "us-east-1"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  vpc_cidr = "10.0.0.0/16"

  cluster_version   = "1.36"
  karpenter_version = "1.14.1"

  # Set to override the Karpenter controller image. Leave empty to use the official image
  # (without the fix, "before" test). Set to the image built from kubernetes-sigs/karpenter#3181
  # for the "after" test.
  # karpenter_image = "ghcr.io/ssup2/karpenter:pr3181"
  karpenter_image = ""
}
