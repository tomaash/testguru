require 'prawn/layout'
pdf.font "./lib/fonts/Verdana Bold.ttf"
pdf.text @exam.heading_text, :align => :center, :size => 15
pdf.font "./lib/fonts/Verdana.ttf", :size => 10
pdf.text " "
pdf.text "Verze testu: #{@exam.version_text}", :align => :center
pdf.text " "
pdf.font "./lib/fonts/Verdana Bold.ttf"
pdf.text @exam.signature_text
# pdf.text " "
# pdf.text "Datum: __________________"
pdf.text " "
pdf.font "./lib/fonts/Verdana.ttf"
pdf.text @exam.description_text
# pdf.text "Test obsahuje 10 otázek po 4b a 15 otázek po 2b. Maximální počet bodů z testu je 70b. Otázky za 2b mají právě 1 správnou odpověď. Otázky za 4b mají 1 nebo více správných odpovědí a za každou chybu se strhávají 2b (ale ne do mínusu). Správné odpovědi označte kolečkem. Pokud opravujete, přeškrtněte kolečko křížkem. V případě dalších oprav proškrtněte všechna písmena svislou čarou a vypište vedle písmena správných odpovědí (např. a, b, e). Na vypracování testu máte 45 minut, přeji hodně zdaru."
pdf.text " "
sorting = case @exam.sorting
when "reverse" : proc{-1}
when "random" : proc{rand(1000)}
when "id" : proc{1}
else proc{0}
end
amount = 13
@exam.questions.sort_by{|q| q.id*sorting.call}.each_with_index do |question,i|
  pdf.start_new_page if pdf.cursor < 200
  question_lines = question.value.split("\n")
  question_header = question_lines[0].strip
  question_body = question_lines[1..1000].join("\n")
  pdf.font "./lib/fonts/Verdana Bold.ttf"
  pdf.text "#{i+1}."
  pdf.move_up(pdf.font_size+0.7)
  amount += 7 if i > 8
  # nbsp = 0xC2.chr+ 0xA0.chr
  pdf.span(pdf.bounds.width-amount, :position => amount) do
    pdf.text "#{question_header} (#{question.points}b)\n#{question_body.pdf_hard_indent}"
  end
  pdf.font "./lib/fonts/Verdana.ttf"
  pdf.pad(8) do
    # pdf.span(500, :position => :center) do
    if question.answers.empty?
      pdf.text " "
      pdf.text " "
      pdf.text " "
      pdf.text " "
      pdf.text " "
      pdf.text " "
    else
      # rows = []
      question.answers.each do |answer|
        # rows << [answer.choice+")",answer.value]
        pdf.pad(3) do
          pdf.font "./lib/fonts/Verdana Bold.ttf"
          pdf.text "#{answer.choice})"
          pdf.font "./lib/fonts/Verdana.ttf"
          amount = 15
          pdf.span(pdf.bounds.width-amount, :position => amount) do
            pdf.move_up(pdf.font_size)
            pdf.text "#{answer.value.pdf_hard_indent}"
          end
        end
      end
      # pdf.table rows, {
      #   :position => :left,
      #   :border_width => 0
      #   }
    end
    # end
  end
  # pdf.text "Author: #{book.author}", :spacing => 16
  # pdf.text book.description
end
