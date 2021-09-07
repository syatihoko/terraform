//Задание 1. Создать bucket S3 и разместить там файл с картинкой.
# - Создать бакет в S3 с произвольным именем (например, имя_студента_дата).
# - Положить в бакет файл с картинкой.
# - Сделать доступным из VPN используя ACL.

//Блок провайдеров
//registry.terraform.io/providers/hashicorp/aws/latest/docs

provider "aws" {
  region = "eu-west-3"
}


//Создание bucket
resource "aws_s3_bucket" "kaa_b" {
  bucket = "kaa-20210903"
  acl    = "private"

  versioning {
    enabled = true
  }
}

//Предоставляет ресурс объекта корзины S3 (ффайл-картинку).
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
////https://coderoad.ru/47745443/%D0%9A%D0%B0%D0%BA-%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B8%D1%82%D1%8C-%D1%81%D0%BF%D0%B8%D1%81%D0%BE%D0%BA-%D0%BE%D0%B1%D1%8A%D0%B5%D0%BA%D1%82%D0%BE%D0%B2-s3-%D1%81-%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E-%D0%B8%D1%81%D1%82%D0%BE%D1%87%D0%BD%D0%B8%D0%BA%D0%B0-%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85-aws_s3_bucket_object
resource "aws_s3_bucket_object" "kaa_foto" {
  //Имя сегмента, в который будет помещен файл. В качестве альтернативы можно указать ARN точки доступа S3.
  bucket = "kaa-20210903"
  //Имя объекта, когда он находится в bucket.
  key    = "kaa_foto.jpg"
  //(Optional, conflicts with content and content_base64) Path to a file that will be read and uploaded as raw bytes for the object content.
  source = "files/foto.jpg"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("files/foto.jpg")
}

//Предоставляет подробную информацию о конкретном  S3 bucket.
//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket
data "aws_s3_bucket" "kaa_b" {
  bucket = aws_s3_bucket.kaa_b.id
}

# Источник данных объекта S3 позволяет получить доступ к метаданным и, при необходимости к содержимому объекта, хранящегося в корзине S3.
data "aws_s3_bucket_object" "kaa_foto" {
  bucket = aws_s3_bucket.kaa_b.id
  key    = aws_s3_bucket_object.kaa_foto.id
}
