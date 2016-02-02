require 'rubygems'
require 'aws-sdk'
require 'capistrano'

module Capistrano
    class Asgroup
        def self.addInstances(which, *args)
            if nil == fetch(:asgroup_use_private_ips)
              set :asgroup_use_private_ips, false
            end
            @ec2_api = Aws::EC2::Client.new(
              region: fetch(:aws_region)
              # credentials from ENV
            )

            @as_api = Aws::AutoScaling::Client.new(region: fetch(:aws_region))

             # Get descriptions of all the Auto Scaling groups
            @autoScaleDesc = @as_api.describe_auto_scaling_groups
             # Get descriptions of all the EC2 instances
            @ec2DescInst = @ec2_api.describe_instances

            # Find the right Auto Scaling group
            @autoScaleDesc[:auto_scaling_groups].each do |asGroup|
                @asGroupInstanceIds = Array.new
                  # Look for an exact name match or Cloud Formation style match (<cloud_formation_script>-<as_name>-<generated_id>)
                if asGroup[:auto_scaling_group_name] == which or asGroup[:auto_scaling_group_name].scan("{which}").length > 0
                    # For each instance in the Auto Scale group
                    asGroup[:instances].each do |asInstance|
                       @asGroupInstanceIds.push(asInstance[:instance_id])
                    end
                end
            end

            # figure out the instance IP's
            @ec2DescInst[:reservations].each do |reservation|
                #remove instances that are either not in this asGroup or not in the "running" state
                reservation[:instances].delete_if{ |a| not @asGroupInstanceIds.include?(a[:instance_id]) or a[:state][:name] != "running" }.each do |instance|
                    puts "Found ASG #{which} Instance ID: #{instance[:instance_id]} in VPC: #{instance[:vpc_id]}"
                    if true == fetch(:asgroup_use_private_ips)
                        server(instance[:private_ip_address], args)
                    else
                        server(instance[:public_ip_address], args)
                    end

                end
            end

       end
    end
end

