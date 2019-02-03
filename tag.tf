locals {
  common_var_tags = {
    ChangedBy = "${module.data.caller_arn}"
    ChangedAt = "${timestamp()}"
  }

  common_fix_tags = {
    Environment = "Sandbox"
    CreatedBy   = "Tiger Peng"
    CreatedAt   = "2019-02-02"
  }
}
