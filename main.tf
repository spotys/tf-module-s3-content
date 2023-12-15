locals {
  suffix_map = {
    ".vcf" : "text/vcard"
    ".htm" : "text/html"
    ".html" : "text/html"
    ".css" : "text/css"
    ".ttf" : "font/ttf"
    ".woff2" : "font/woff2"
    ".svg" : "image/svg+xml"
  }
}

resource "aws_s3_object" "object" {
  for_each = fileset(var.directory, "**")

  bucket       = var.s3-bucket-id
  key          = "${var.key-prefix}/${each.value}"
  source       = "${var.directory}/${each.value}"
  etag         = filemd5("${var.directory}/${each.value}")
  content_type = try([for ext, content_type in local.suffix_map : content_type if endswith(lower(each.value), ext)][0], null)
}
