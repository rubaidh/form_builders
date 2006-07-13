require 'rubaidh/form_builder_helper'

# Build a form using tables.
module Rubaidh
  module TabularForm
    class TabularFormBuilder < ActionView::Helpers::FormBuilder 
      (field_helpers - %w(check_box radio_button)).each do |selector| 
        src = <<-END_SRC 
          def #{selector}(field, options = {})
            label_text = options[:label] || options["label"] || field.to_s.humanize
            generic_field(field, super, label_text)
          end 
        END_SRC
        class_eval src, __FILE__, __LINE__ 
      end
      
      %w(check_box radio_button).each do |selector|
        src = <<-END_SRC
          def #{selector}(field, options = {})
            label_text = options[:label] || options["label"] || field.to_s.humanize
            generic_field(field, super, label_text, :label => :after)
          end
        END_SRC
        class_eval src, __FILE__, __LINE__ 
      end
      
      def submit(text, options = {})
        generic_field(nil, @template.submit_tag(text, options))
      end
      
      def file_column_field(field, options = {})
        label_text = options[:label] || options["label"] || field.to_s.humanize
        generic_field(field, @template.file_column_field(@object_name, field, options), label_text)
      end
      
      protected
      def generic_field(fieldname, field, label_text = nil, options = {})
        unless label_text.blank?
          if options[:label] == :after
            tr(td('') + td(field + label(label_text, "#{@object_name}_#{fieldname}", true)))
          else
            tr(
              td(label(label_text, "#{@object_name}_#{fieldname}")) +
              td(field)
            ) 
          end
        else # No label
          tr(td(field, :colspan => 2, :style => "text-align: right;"))
        end
      end
      
      def tr content, options = {}
        @template.content_tag 'tr', content, options
      end
      def td content, options = {}
        @template.content_tag 'td', content, options
      end
      def label text, for_field, after = false
        @template.content_tag 'label', "#{text}#{after ? '' : ':'}", :for => for_field
      end
    end 

    def tabular_form_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.last : {}
      custom_form_for(
        TabularFormBuilder, '<table>', '</table>',
        form_tag(options.delete(:url) || {}, options.delete(:html) || {}),
        object_name, *args, &proc)
    end
    
    def tabular_remote_form_for(object_name, *args, &proc)
      options = args.last.is_a?(Hash) ? args.last : {}
      custom_form_for(
        TabularFormBuilder, '<table>', '</table>',
        form_remote_tag(options),
        object_name, *args, &proc)
    end
  end
end