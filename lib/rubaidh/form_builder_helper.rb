module Rubaidh
  module FormBuilderHelper
    # Create the +form_for+ and +remote_form_for+ methods for a particular
    # form builder.
    def create_form_for builder, create_options
      builder_fn = builder.to_s.split('::')[-1].gsub('FormBuilder', '').underscore
      define_method "#{builder_fn}_form_for", Proc.new { |object_name, *args|
        unless args.last.is_a?(Proc)
          raise "Missing block"
        end
        proc = args.pop
        options = args.last.is_a?(Hash) ? args.pop : {}
        concat(form_tag(options.delete(:url) || {}, options.delete(:html) || {}), proc.binding)
        concat(create_options[:fields_pre], proc.binding)
        fields_for(object_name, *(args << options.merge(:builder => builder)), &proc)
        concat(create_options[:fields_post], proc.binding)
        concat(end_form_tag, proc.binding)
      }
      define_method "#{builder_fn}_remote_form_for", Proc.new { |object_name, *args|
        unless args.last.is_a?(Proc)
          raise "Missing block"
        end
        proc = args.pop
        options = args.last.is_a?(Hash) ? args.pop : {}
        concat(form_remote_tag(options), proc.binding)
        concat(create_options[:fields_pre], proc.binding)
        fields_for(object_name, *(args << options.merge(:builder => builder)), &proc)
        concat(create_options[:fields_post], proc.binding)
        concat(end_form_tag, proc.binding)
      }
    end
  end
end