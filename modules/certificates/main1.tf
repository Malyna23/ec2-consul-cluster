resource "tls_private_key" "root" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "tls_self_signed_cert" "root" {
  key_algorithm   = "ECDSA"
  private_key_pem = "${tls_private_key.root.private_key_pem}"

  validity_period_hours = 26280
  early_renewal_hours   = 8760

  is_ca_certificate = true

  allowed_uses = ["cert_signing"]

  subject {
      common_name         = "Example Inc. Root"
      organization        = "Example, Inc"
      organizational_unit = "Department of Certificate Authority"
      street_address      = ["5879 Cotton Link"]
      locality            = "Pirate Harbor"
      province            = "CA"
      country             = "US"
      postal_code         = "95559-1227"
  }
}
locals {
  public_key_filename  = "${path.root}/keys/public.pub"
  private_key_filename = "${path.root}/keys/private.pem"
}
 resource "local_file" "public_key_openssh" {
  content  = "${tls_private_key.root.public_key_openssh}"
  filename = "${local.public_key_filename}"
}

resource "local_file" "private_key_pem" {
  content  = "${tls_private_key.root.private_key_pem}"
  filename = "${local.private_key_filename}"
}

resource "null_resource" "chmod" {
  depends_on = ["local_file.private_key_pem"]

  triggers {
    key = "${tls_private_key.root.private_key_pem}"
  }
}