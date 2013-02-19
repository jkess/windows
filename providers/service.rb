#
# Author:: James Kessler (<james.kessler@tradingtechnologies.com>) 
# Cookbook Name:: windows
# Provider:: service
#
# Copyright:: 2013, Trading Technologies, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'win32/service'

def whyrun_supported?
  true
end

action :create do
  if @current_resource.exists
    Chef::Log.info("#{@new_resource} already exists - nothing to do")
  else
    converge_by("Create #{@new_resource}") do
      ::Win32::Service.create(
        :service_name       => @new_resource.name,
        :binary_path_name   => @new_resource.binary_path_name,
        :display_name       => @new_resource.display_name,        
        :description        => @new_resource.description,
        :start_type         => start_type,
      )
    end
  end
end

action :delete do
  if @current_resource.exists
    converge_by("Delete #{@new_resource}") do
      ::Win32::Service.delete(@new_resource.name)
    end
  else
    Chef::Log.info("#{@new_resource} doesn't exist - nothing to delete")    
  end
end

def load_current_resource
  @current_resource = Chef::Resource::WindowsService.new(@new_resource.name)
  @current_resource.name(@new_resource.name)

  if ::Win32::Service.exists?(@current_resource.name)
    @current_resource.exists = true
    @current_resource.current_state = ::Win32::Service.status(@current_resource.name).current_state
  end
end


private

def start_type
  case @new_resource.start_type
  when "manual"
    ::Win32::Service::DEMAND_START
  when "auto"
    ::Win32::Service::AUTO_START
  when "disabled"
    ::Win32::Service::DISABLED
  else
    raise "invalid start type '#{@new_resource.start_type}'"
  end
end