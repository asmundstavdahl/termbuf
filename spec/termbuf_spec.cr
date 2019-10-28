require "./spec_helper"

describe Termbuf do
  # TODO: Write tests

  it "lets you make a display of 10x10" do
    (Termbuf::Display.new(10, 10)).nil?.should be_false
  end

  it "allows setting and getting cell value" do
    d = Termbuf::Display.new(2, 2)
    d.set_char!({0, 0}, "+")
    d.get_char({0, 0}).should eq("+")
    d.set_char!({0, 0}, "-")
    d.get_char({0, 0}).should eq("-")
    d.set_char!({1, 1}, "?")
    d.get_char({1, 1}).should eq("?")
  end

  it "can render to string" do
    d = Termbuf::Display.new(2, 2)
    d.set_char!({0, 0}, "1")
    d.set_char!({1, 0}, "2")
    d.set_char!({0, 1}, "3")
    d.set_char!({1, 1}, "4")
    d.render.should contain("1")
    d.render.should contain("2")
    d.render.should contain("3")
    d.render.should contain("4")
    d.render.should eq("12\n" \
                       "34")
  end

  it "can draw horizontal line" do
    d = Termbuf::Display.new(3, 3)
    d.draw_line!({0, 1}, {2, 1}, "-")
    d.render.should eq("   \n" \
                       "---\n" \
                       "   ")
  end

  it "can draw vertical line" do
    d = Termbuf::Display.new(3, 3)
    d.draw_line!({1, 0}, {1, 2}, "|")
    d.render.should eq(" | \n" \
                       " | \n" \
                       " | ")
  end

  it "can draw diagonal lines" do
    d1 = Termbuf::Display.new(3, 3)
    d1.draw_line!({2, 0}, {0, 2}, "/")
    d1.render.should eq("  /\n" \
                        " / \n" \
                        "/  ")

    d2 = Termbuf::Display.new(3, 3)
    d2.draw_line!({2, 0}, {0, 1}, "/")
    d2.render.should eq("  /\n" \
                        "// \n" \
                        "   ")

    d3 = Termbuf::Display.new(5, 2)
    d3.draw_line!({0, 0}, {4, 1}, "-")
    d3.render.should eq("--   \n" \
                        "  ---")
  end

  it "can draw rectangles" do
    d = Termbuf::Display.new(3, 3)
    d.draw_rectangle!({0, 0}, {2, 2}, "-")
    d.render.should eq("---\n" \
                       "- -\n" \
                       "---")
  end

  it "can set style" do
    d = Termbuf::Display.new(1, 1)
    d.set_char!({0, 0}, ".")
    d.set_style!({0, 0}, "\e[1m")
    d.render.should eq("\e[1m.\e[0m")
  end

  it "can draw styled line" do
    d = Termbuf::Display.new(2, 1)
    d.draw_line!({0, 0}, {1, 0}, ".", "\e[1m")
    d.render.should eq("\e[1m..\e[0m")
  end
end
