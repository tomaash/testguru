require 'prawn/layout'
pdf.font "./lib/fonts/Verdana Bold.ttf"
pdf.text "Výsledky testu z předmětu Webové Technologie", :align => :center, :size => 15
pdf.font "./lib/fonts/Verdana.ttf", :size => 10
pdf.text " "
pdf.text "Verze testu: #{@exam.name}", :align => :center
pdf.text " "
rows = []
sorting = @exam.sorting=="reverse" ? -1 : 1
@exam.questions.sort_by{|q| q.id*sorting}.each_with_index do |question,i|
  correct_answers = question.answers.select{|x| x.correct}
  # pdf.font "./lib/fonts/Verdana Bold.ttf"
  # pdf.text "#{i+1}. (#{correct_answers.map{|x| x.choice}.join(',')}) #{question.value[0..50]}... (#{question.points}b) "
  rows << [i+1, correct_answers.map{|x| x.choice}.join(','), question.value.mb_chars[0..50]]
  # pdf.font "./lib/fonts/Verdana.ttf"
end
pdf.table rows, :position => :center
