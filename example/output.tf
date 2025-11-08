output "cdn_domain" {
  value = module.demo_ecs.cdn_domain
}

# output "dns_url" {
#   value = "https://${cloudflare_record.dns_record.hostname}"
# }
