module ExamsHelper

  def heading_text_form_column(record, input_name)
    text_area :record, :heading_text, :name  => input_name, :cols => 32, :rows => 3
  end

  def signature_text_form_column(record, input_name)
    text_area :record, :signature_text, :name  => input_name, :cols => 32, :rows => 3
  end

  def description_text_form_column(record, input_name)
    text_area :record, :description_text, :name  => input_name, :cols => 32, :rows => 3
  end
  
  
end