# Build a form using tables.
module Rubaidh
  module TabularForm
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

    def tabular_form_for(object_name, *args, &proc)
      raise ArgumentError, "Missing block" unless block_given?
      options = args.last.is_a?(Hash) ? args.pop : {}
      concat(form_tag(options.delete(:url) || {}, options.delete(:html) || {}), proc.binding)
      concat("<table>", proc.binding) 
      fields_for(object_name, *(args << options.merge(:builder => TabularFormBuilder)), &proc)
      concat("</table>", proc.binding) 
      concat('</form>', proc.binding)
    end

    def tabular_remote_form_for(object_name, object, options = {}, &proc)
      raise ArgumentError, "Missing block" unless block_given?
      concat(form_remote_tag(options), proc.binding)
      concat("<table>", proc.binding) 
      fields_for(object_name, object, options.merge(:builder => TabularFormBuilder), &proc)
      concat("</table>", proc.binding) 
      concat('</form>', proc.binding)
    end
  end
end