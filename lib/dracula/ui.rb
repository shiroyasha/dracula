class Dracula
  class UI

    # Prints a table. Shamelesly copied from thor.
    #
    # ==== Parameters
    # Array[Array[String, String, ...]]
    #
    # ==== Options
    # indent<Integer>:: Indent the first column by indent value.
    # colwidth<Integer>:: Force the first column to colwidth spaces wide.
    #
    def self.print_table(array, options = {}) # rubocop:disable MethodLength
      return if array.empty?

      formats = []
      indent = options[:indent].to_i
      colwidth = options[:colwidth]
      options[:truncate] = terminal_width if options[:truncate] == true

      formats << "%-#{colwidth + 2}s".dup if colwidth
      start = colwidth ? 1 : 0

      colcount = array.max { |a, b| a.size <=> b.size }.size

      maximas = []

      start.upto(colcount - 1) do |index|
        maxima = array.map { |row| row[index] ? row[index].to_s.size : 0 }.max
        maximas << maxima
        formats << if index == colcount - 1
                     # Don't output 2 trailing spaces when printing the last column
                     "%-s".dup
                   else
                     "%-#{maxima + 2}s".dup
                   end
      end

      formats[0] = formats[0].insert(0, " " * indent)
      formats << "%s"

      array.each do |row|
        sentence = "".dup

        row.each_with_index do |column, index|
          maxima = maximas[index]

          f = if column.is_a?(Numeric)
            if index == row.size - 1
              # Don't output 2 trailing spaces when printing the last column
              "%#{maxima}s"
            else
              "%#{maxima}s  "
            end
          else
            formats[index]
          end
          sentence << f % column.to_s
        end

        sentence = truncate(sentence, options[:truncate]) if options[:truncate]
        puts sentence
      end
    end
  end
end
