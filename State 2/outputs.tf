output "podinfo_url" {
  description = "Public URL for Podinfo"
  value = try(
    "http://${data.kubernetes_ingress_v1.podinfo.status[0].load_balancer[0].ingress[0].hostname}",
    "ALB is still provisioning in AWS."
  )
}