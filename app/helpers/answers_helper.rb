module AnswersHelper
  def value_column(record)
    h record.value
  end

  def correct_form_column(record, input_name)
    check_box :record, :correct, :name  => input_name
  end

  def value_form_column(record, input_name)
    text_area :record, :value, :name  => input_name, :cols => 35, :rows => 3
  end

  def choice_form_column(record, input_name)
    text_field :record, :choice, :name  => input_name, :size => 1
  end


  def answers_column(record)
    record.answers.map{|answer| "#{answer.choice}) #{h(answer.value)}"}.sort.join('<br/>')
  end
  
end
