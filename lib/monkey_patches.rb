# module Prawn
#   class Document
#     module Text
#       include Wrapping
#
#       private
#
#       def process_text_options(options)
#         Prawn.verify_options [:style, :kerning, :size, :at, :wrap,
#         :spacing, :align, :rotate, :final_gap ], options
#
#         # if options[:style]
#         #   raise "Bad font family" unless font.family
#         #   font(font.family,:style => options[:style])
#         # end
#
#         unless options.key?(:kerning)
#           options[:kerning] = font.has_kerning_data?
#         end
#
#         options[:size] ||= font_size
#       end
#     end
#   end
# end

class String
  def html_newlines
    self.gsub("\n","<br/>")
  end
end
