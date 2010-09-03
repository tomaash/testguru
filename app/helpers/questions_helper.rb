module QuestionsHelper
  def value_column(record)
    h record.value
  end

  def correct_form_column(record, input_name)
    check_box :record, :correct, :name  => input_name
  end

  def value_form_column(record, input_name)
    text_area :record, :value, :name  => input_name, :cols => 35, :rows => 3
  end

  def points_form_column(record, input_name)
    text_field :record, :points, :name  => input_name, :size => 1
  end

  def multiple_form_column(record, input_name)
    check_box :record, :multiple, :name  => input_name
  end
  
  # def topic_form_column(record, input_name)
  #   select :record, :topic, Topic.all.map{|x| [x.name, x.id]} 
  # end


  def answers_column(record)
    record.answers.map{|answer| "
      #{answer.correct ? '<span style="font-weight: bold;">' : ''}
      #{h answer.choice}) #{h answer.value} 
      #{answer.correct ? '</span>' : ''}
      "}.join('<br/>')
  end
end
