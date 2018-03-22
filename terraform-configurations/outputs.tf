output "demo_frontend_url" {
  value = "http://${module.demo_frontend_elb.elb_dns_name}"
}

output "demo_backend_url" {
  value = "http://${module.demo_backend_elb.elb_dns_name}"
}
