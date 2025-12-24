resource "aws_ecr_repository" "repo" {
  name = "umami-app"

  # image_scanning_configuration {
  #     scan_on_push = true
  # }

  # encryption_configuration {
  #   encryption_type = "AE256"
  # }
}

# resource "aws_ecr_lifecycle_policy" "" {
#     repository = aws_ecr_repository.repo.name

#     policy = jsonencode({
#         rules = [
#             {
#             rulePriority = 1
#             description = "Keep last 10 images"
#             selection = {
#                 tagStatus = "any"
#                 countType = "imageCountMoreThan"
#                 countNumber = 10
#             }
#             Action = { type = "expire" }
#             }
#         ]
#     })
# }