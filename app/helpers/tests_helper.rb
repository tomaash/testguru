module TestsHelper
  # def value_column(record)
  #   h record.value
  # end
  # 
  # def correct_form_column(record, input_name)
  #   check_box :record, :correct, :name  => input_name
  # end
  # 
  # def value_form_column(record, input_name)
  #   text_area :record, :value, :name  => input_name, :cols => 35, :rows => 3
  # end
  # 
  # def points_form_column(record, input_name)
  #   text_field :record, :points, :name  => input_name, :size => 1
  # end
  # 
  # def multiple_form_column(record, input_name)
  #   check_box :record, :multiple, :name  => input_name
  # end
  # 
  def questions_column(record)
    record.questions.size
  end
end
