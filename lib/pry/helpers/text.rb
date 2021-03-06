class Pry
  module Helpers

    # The methods defined on {Text} are available to custom commands via {Pry::CommandContext#text}.
    module Text

      COLORS =
      {
        "black"   => 0,
        "red"     => 1,
        "green"   => 2,
        "yellow"  => 3,
        "blue"    => 4,
        "purple"  => 5,
        "magenta" => 5,
        "cyan"    => 6,
        "white"   => 7
      }

      class << self

        COLORS.each_pair do |color, value|
          define_method color do |text|
            Pry.color ? "\033[0;#{30+value}m#{text}\033[0m" : text.to_s
          end

          define_method "bright_#{color}" do |text|
            Pry.color ? "\033[1;#{30+value}m#{text}\033[0m" : text.to_s
          end
        end

        alias_method :grey, :bright_black
        alias_method :gray, :bright_black


        # Remove any color codes from _text_.
        #
        # @param  [String, #to_s] text
        # @return [String] _text_ stripped of any color codes.
        def strip_color text
          text.to_s.gsub(/\e\[.*?(\d)+m/ , '')
        end

        # Returns _text_ as bold text for use on a terminal.
        # _Pry.color_ must be true for this method to perform any transformations.
        #
        # @param [String, #to_s] text
        # @return [String] _text_
        def bold text
          Pry.color ? "\e[1m#{text}\e[0m" : text.to_s
        end

        # Executes _block_ with _Pry.color_ set to false.
        #
        # @param [Proc]
        # @return [void]
        def no_color &block
          boolean = Pry.color
          Pry.color = false
          yield
        ensure
          Pry.color = boolean
        end

        # Returns _text_ in a numbered list, beginning at _offset_.
        #
        # @param  [#each_line] text
        # @param  [Fixnum] offset
        # @return [String]
        def with_line_numbers(text, offset, color=:blue)
          lines = text.each_line.to_a
          max_width = (offset + lines.count).to_s.length
          lines.each_with_index.map do |line, index|
            adjusted_index = (index + offset).to_s.rjust(max_width)
            "#{self.send(color, adjusted_index)}: #{line}"
          end.join
        end
      end

    end

  end
end

