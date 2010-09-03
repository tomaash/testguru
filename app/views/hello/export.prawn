pdf.font "Helvetica"
pdf.font "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf", :style => :bold

@questions.each_with_index do |question,i|
  pdf.start_new_page if pdf.cursor < 200
  pdf.text "#{i+1}. #{question.value}", :size => 15
  pdf.pad(8) do
    # pdf.span(500, :position => :center) do
    question.answers.each do |answer|
      pdf.pad(3) do
        pdf.text "#{answer.choice}) #{answer.value}"
      end
    end
    # end
  end
  # pdf.text "Author: #{book.author}", :spacing => 16
  # pdf.text book.description
end
