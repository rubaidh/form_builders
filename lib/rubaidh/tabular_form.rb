# Build a form using tables.

require 'rubaidh/form_builder_helper'

module Rubaidh
  module TabularForm
    
    include Rubaidh::FormBuilderHelper
    
    class TabularFormBuilder < ActionView::Helpers::FormBuilder 
      (field_helpers - %w(check_box radio_button)).each do |selector| 
        src = <<-END_SRC 
          def #{selector}(field, options = {}) 
            @template.content_tag("tr", 
              @template.content_tag("td", 
                @template.content_tag("label", field.to_s.humanize + ":", {:for => @object_name + "_" + field})
              ) + 
              @template.content_tag("td", super)) 
          end 
        END_SRC
        class_eval src, __FILE__, __LINE__ 
      end
  
      def submit(text, options = {})
        @template.content_tag("tr", @template.content_tag("td", @template.submit_tag(text, options), :colspan => 2, :style => "text-align: right;"))
      end
    end 

    create_form_for TabularFormBuilder, :fields_pre => '<table>', :fields_post => '</table>'
  end
end