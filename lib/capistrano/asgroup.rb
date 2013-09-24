require 'right_aws'

unless Capistrano::Configuration.respond_to?(:instance)
  abort 'capistrano/asgroup requires Capistrano >= 2'
end

module Capistrano
  class Configuration
    module Asgroup

      def asgroupname(which, *args)

        # Get Auto Scaling API obj
        @as_api ||= RightAws::AsInterface.new(fetch(:aws_access_key_id), fetch(:aws_secret_access_key), {:region => fetch(:aws_region)})
        # Get EC2 API obj
        @ec2_api ||= RightAws::Ec2.new(fetch(:aws_access_key_id), fetch(:aws_secret_access_key), {})

        # Get descriptions of all the Auto Scaling groups
        @autoScaleDesc = @as_api.describe_auto_scaling_groups
        # Get descriptions of all the EC2 instances
        @ec2DescInst = @ec2_api.describe_instances

        # Find the right Auto Scaling group
        @autoScaleDesc.each do |asGroup|
            # Look for an exact name match or Cloud Formation style match (<cloud_formation_script>-<as_name>-<generated_id>)
            if asGroup[:auto_scaling_group_name] == which or asGroup[:auto_scaling_group_name].scan("-#{which}-").length > 0
                # For each instance in the Auto Scale group
                asGroup[:instances].each do |asInstance|
                    # Get description of all instances so that we can find the DNS names based on instance ID
                    @ec2DescInst.delete_if{|i| i[:aws_state] != "running"}.each do |instance|
                        # Match the instance IDs
                        if instance[:aws_instance_id] == asInstance[:instance_id]
                            puts "AS Instance ID: #{asInstance[:instance_id]} DNS: #{instance[:dns_name]}"
                            server(instance[:dns_name], *args)
                        end
                    end
                end
            end
        end
      end
    end

    include Asgroup
  end
end

