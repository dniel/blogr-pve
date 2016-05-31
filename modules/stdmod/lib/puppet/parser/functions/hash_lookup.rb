#
# hash_lookup.rb
#
# This fuction takes 3 arguments (hash key, default value and parameter name) and looks for the given
# option key in the calling modules hash parameter, and returns the value.
# The function is intended to be used in templates.
# If no option is found in the hash parameter key, default value (second argument), is returned.
#
# Example usages:
#
# Default value of no
#   <%= scope.function_hash_lookup(['PasswordAuthentication', 'no']) %>
# Empty default value
#   <%= scope.function_hash_lookup(['PasswordAuthentication', '']) %>
# Fact or param based default value
#   <%= scope.function_hash_lookup(['Listen', ipaddress]) %>
# Lookup inside a custom hash - in this case client_options_hash
#   <%= scope.function_hash_lookup(['PasswordAuthentication', 'no', 'client_options_hash']) %>
#
#
# Michal Nowak <mailto:michal@casanowak.com>
#
module Puppet::Parser::Functions
  newfunction(:hash_lookup, :type => :rvalue, :doc => <<-EOS
This fuction takes 3 arguments (hash key, default value and name of the hash parameter) and looks
for the given hash key in the calling modules parameter hash, and returns the value.
The function is intended to be used in templates.
If no option is found in the parameter hash (default name: config_file_options_hash), default value (second argument), is returned.

Default value of no
  <%= scope.function_hash_lookup(['PasswordAuthentication', 'no']) %>
Empty default value
  <%= scope.function_hash_lookup(['PasswordAuthentication', '']) %>
Fact or param based default value
   <%= scope.function_hash_lookup(['Listen', ipaddress]) %>
Lookup inside a custom hash - in this case client_options
   <%= scope.function_hash_lookup(['PasswordAuthentication', 'no', 'client_options']) %>

EOS
  ) do |args|

    raise ArgumentError, ("hash_lookup(): wrong number of arguments (#{args.length}; must be 2 or 3)") if (args.length != 2 and args.length != 3)

    value = ''
    option_name = args[0]
    default_val = args[1]
    hash_name = args[2]
    module_name = parent_module_name

    hash_name = "config_file_options_hash" if (hash_name == :undefined || hash_name == '' || hash_name == nil)
    value = lookupvar("#{module_name}::#{hash_name}")["#{option_name}"] if (lookupvar("#{module_name}::#{hash_name}").size > 0)
    value = "#{default_val}" if (value == :undefined || value == '' || value == nil)

    return value
  end
end
