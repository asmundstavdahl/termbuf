# TODO: Write documentation for `Termbuf`
module Termbuf
  VERSION = "0.1.0"

  class Display
    @cells = [] of Cell

    def initialize(@width = 80, @height = 40, init_char = " ")
      @cells = ([nil] * (width * height)).map { |_| Cell.new(init_char) }
    end

    def set_char!(xy, c)
      cell_at(xy).char = c
    end

    def get_char(xy)
      cell_at(xy).char
    end

    def set_style!(xy, style)
      cell_at(xy).style = style
    end

    def get_style(xy)
      cell_at(xy).style
    end

    def cell_at(xy)
      x, y = xy
      x_ = x % @width
      y_ = y % @height
      i = x_ + @width * y_
      @cells[i]
    end

    def render
      prev_style : String? = nil

      output = String.build do |buf|
        (0...@height).each do |y|
          (0...@width).each do |x|
            cell = cell_at({x, y})

            if cell.style != prev_style
              buf << "\e[0m" unless x == 0 && y == 0
              buf << cell.style
            end
            buf << cell.char

            prev_style = cell.style
          end
          buf << "\n" unless y == @height - 1
        end

        unless prev_style.nil?
          buf << "\e[0m"
        end
      end
    end

    def draw_line!(xy1, xy2, c, style = nil)
      x1, y1 = xy1
      x2, y2 = xy2

      # make dx > 0
      if x2 < x1
        x1, x2, y1, y2 = {x2, x1, y2, y1}
      end

      x_diff = x2 - x1
      y_diff = y2 - y1

      n_steps = Math.max(x_diff.abs, y_diff.abs)

      if n_steps == 0
        cell = cell_at({x1, y1})
        cell.char = c
        cell.style = style
      else
        dx = x_diff / n_steps
        dy = y_diff / n_steps

        (0..n_steps).each do |i|
          x = (x1 + dx * i).round.to_i
          y = (y1 + dy * i).round.to_i
          cell = cell_at({x, y})
          cell.char = c
          cell.style = style
        end
      end
    end

    def draw_rectangle!(xy1, xy2, c = "\e[7m \e[0m")
      x1, y1 = xy1
      x2, y2 = xy2

      draw_line!({x1, y1}, {x1, y2}, c)
      draw_line!({x2, y2}, {x1, y2}, c)
      draw_line!({x2, y2}, {x2, y1}, c)
      draw_line!({x1, y1}, {x2, y1}, c)
    end
  end

  class Cell
    def initialize(@char = " ", @style : String? = nil)
    end

    getter :char
    setter :char

    getter :style
    setter :style
  end
end
