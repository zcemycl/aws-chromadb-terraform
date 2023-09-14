module "loggings" {
  source = "../../modules/loggings"
  loggings = [
    {
      name              = "chroma"
      group_name        = "chroma-container-logs"
      stream_name       = "chroma-container-stream"
      retention_in_days = 3
    },
    {
      name              = "vpn"
      group_name        = "vpn-logs"
      stream_name       = "vpn-stream"
      retention_in_days = 1
    }
  ]
}
