# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.  
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at 
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  vpc_layouts = {
    # https://www.davidc.net/sites/default/subnets/subnets.html?network=192.168.0.0&mask=24&division=7.31
    workload_one_private_3az = {
      number_of_az = 3
      netmask      = 24
      subnets = {
        application = {
          type          = "private"
          newbits       = 2
          netnum_offset = 0
          route_to_tgw  = true
          tgw_attach    = true
        }
      }
    }

    workload_one_private_2az = {
      number_of_az = 2
      netmask      = 25
      subnets = {
        application = {
          type          = "private"
          newbits       = 2
          netnum_offset = 0
          route_to_tgw  = true
          tgw_attach    = true
        }
      }
    }

     workload_one_public_and_private_2az = {
      number_of_az = 2
      netmask      = 24
      subnets = {
        application = {
          type          = "private"
          newbits       = 2
          netnum_offset = 0
          route_to_tgw  = true
          tgw_attach    = true
        },
        public = {
          type          = "public"
          newbits       = 4
          netnum_offset = 12
          route_to_tgw  = false
          tgw_attach    = false
        }
      }
    }
  }
}
