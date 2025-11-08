# # ########################################
# # Cloudflare
# # ########################################

# resource "cloudflare_record" "dns_record" {
#   zone_id = var.cloudflare_zone_id
#   name    = var.dns_domain
#   content = module.demo_ecs.cdn_domain
#   type    = "CNAME"
#   ttl     = 1
#   proxied = true
# }
