# data "airbyte_workspace" "by_id" {
#   id = "d659aac3-2507-4a12-8255-363f4cdcff0d"
# }

# # Super basic custom source
# resource "airbyte_source_definition" "custom" {
#   name              = "custom_source_definition"
#   docker_repository = "airbyte/source-postgres"
#   docker_image_tag  = "1.0.39"
#   documentation_url = "https://github.com/eabrouwer3/airbyte-test-data-source"
#   workspace_id      = data.airbyte_workspace.by_id.id
# }

# resource "airbyte_source" "custom" {
#   definition_id = airbyte_source_definition.custom.id
#   workspace_id  = data.airbyte_workspace.by_id.id
#   name          = "custom_source"
#   # The source definition above takes no parameters
#   # Note that no terraform validation happens for this - just errors directly from the API
#   connection_configuration = jsonencode({
#     host     = "pg-jhodb-replica.jhodb"
#     database = "jhodb"
#     port     = 5432
#     username = "user_jhodb"
#     password = "jhodb"
#   })
# }
