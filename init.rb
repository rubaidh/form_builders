# Automatically include the new form helpers in ApplicationHelper
[Rubaidh::TabularForm].each do |form_builder|
  ApplicationHelper.send :include, form_builder
end