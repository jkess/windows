actions :create, :delete

default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :display_name, :kind_of => String, :required => true
attribute :binary_path_name, :kind_of => String, :required => true
attribute :description, :kind_of => String, :default => ""
attribute :start_type, :default => "manual", :regex => /^(manual|auto|disabled)$/

attr_accessor :exists, :current_state