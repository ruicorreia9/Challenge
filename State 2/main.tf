module "load_balancer_controller_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                              = "aws-load-balancer-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.infra.outputs.oidc_provider_arn
      namespace_service_accounts = ["web-production:aws-load-balancer-controller"]
    }
  }
}

module "helm" {
  source                            = "./modules/helm"
  cluster_name                      = data.terraform_remote_state.infra.outputs.cluster_name
  load_balancer_controller_role_arn = module.load_balancer_controller_irsa_role.iam_role_arn
  region                            = data.terraform_remote_state.infra.outputs.region
  vpc_id                            = data.terraform_remote_state.infra.outputs.vpc_id

}

resource "kubernetes_namespace_v1" "challenge-namespace" {
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "podinfo" {
  name       = "podinfo"
  repository = "https://stefanprodan.github.io/podinfo"
  chart      = "podinfo"
  namespace  = var.namespace_name

  values = [
    file("${path.module}/custom-values.yaml"),

    yamlencode({
      service = {
        type = "ClusterIP"
      }

      ingress = {
        enabled   = true
        className = "alb"
        annotations = {
          "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
          "alb.ingress.kubernetes.io/target-type" = "ip"
          "alb.ingress.kubernetes.io/subnets"     = join(", ", data.terraform_remote_state.infra.outputs.public_subnets)
        }
        hosts = [
          {
            paths = [
              {
                path     = "/"
                pathType = "Prefix"
              }
            ]
          }
        ]
      }
    })
  ]

  depends_on = [module.load_balancer_controller_irsa_role, module.helm]
}

data "kubernetes_ingress_v1" "podinfo" {
  metadata {
    name      = "podinfo"
    namespace = var.namespace_name
  }

  depends_on = [helm_release.podinfo]
}