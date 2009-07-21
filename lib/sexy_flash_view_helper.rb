# SexyFlash
module SexyFlashViewHelper

  #helper for flash messages
  # == Options
  # * timeout: Flash timeout in seconds
  # * hide_duration: Flash effect duration in seconds
  # ==
  # i.e: sexy_flash :timeout => 2, :hide_duration => 1, :show_effect => "highlight", :hide_effect => "highlight"
  # If :timeout is set to be 0 or less then 0. Don't hide the flash message  
  #
  # These same options can be overwritten at when creating the flash, and for that flash message only:
  #
  # i.e:
  # flash[:notice] = 'I just want you to know', {:timeout => 0, :show_effect => 'highlight' }
  def sexy_flash(view_options = {})
    the_flash = ""

    global_timeout = view_options.has_key?(:timeout) ? view_options[:timeout]*1000 : 5
    global_hide_duration = view_options.has_key?(:hide_duration) ? view_options[:hide_duration]*1000 : 1000
    global_show_duration = view_options.has_key?(:show_duration) ? view_options[:show_duration]*1000 : 1
    global_show_effect = view_options[:show_effect] || 'highlight'
    global_hide_effect = view_options[:hide_effect] || 'highlight'

    [:message, :error, :warning, :info, :notice].each do |key|
      if flash.has_key?(key)
        #set options specific to this flash message:
        flash_options = flash[(key.to_s + '_options').to_sym]
        timeout = flash_options.has_key?(:timeout) ? flash_options[:timeout]*1000 : global_timeout
        show_duration = flash_options[:show_duration] || global_show_duration
        hide_duration = flash_options[:hide_duration] || global_hide_duration
        show_effect = flash_options[:show_effect] || global_show_effect
        hide_effect = flash_options[:hide_effect] || global_hide_effect

        the_flash += content_tag(:div, flash[key], :class => 'flash', :id => "flash_#{key}")

        the_flash += content_tag :script, :type => 'text/javascript' do
          "var options = {};" +
          "function callback(){ setTimeout(function(){ $('#flash_#{ key }:visible').removeAttr('style').hide('#{ hide_effect }', options, #{ hide_duration }, callback); }, #{ timeout });}" +
          "$('#flash_#{ key }').show('#{ show_effect }', options, #{ hide_duration }, callback);"
        end
      end #if flash.has_key?(key)
    end #each do |key|
    return the_flash
  end 

end
