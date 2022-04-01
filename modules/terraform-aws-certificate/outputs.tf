output "certificate" {
  description = "Objects describing the certificate with: arn and domain_name"
  value = {
    arn         = aws_acm_certificate.this.arn
    domain_name = aws_acm_certificate.this.domain_name
  }
}
