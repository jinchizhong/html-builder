#!/usr/bin/ruby

class HtmlBuilder
  def initialize name, attrs, text
    @name = name
    @attrs = attrs
    @text = text
    @children = []
    @refed = false
  end
  attr_accessor :refed
  def escape str
    # TODO
    str.to_s
  end
  def quote str
    '"' + escape(str) + '"'
  end
  def self.html *args, &block
    attrs, text = HtmlBuilder.parse_arg *args
    h = HtmlBuilder.new "html", attrs, text
    h.instance_eval &block if block
    h.generate
  end
  def format_node
    str = escape @name
    if @attrs
      @attrs.each do |k, v|
        str += " #{escape k}=#{quote v}"
      end
    end
    str
  end
  def generate_internel lines, dep, inl
    if @name == nil
      @text.each_line do |l|
        lines << "  " * dep + l.chomp
      end
      return
    end
    dep = 0 if inl
    cs = @children.keep_if {|c| !c.refed}
    raise "Cannot own block and text both." if @text and not cs.empty?

    if not cs.empty?
      lines << "  " * dep + "<" + format_node + ">"
      cs.each do |c|
        c.generate_internel lines, dep + 1, inl
      end
      lines << "  " * dep + "</#{escape @name}>"
    elsif @text
      lines << "  " * dep + "<#{format_node}>#{escape @text}</#{escape @name}>"
    else
      lines << "  " * dep + "<#{format_node}/>"
    end
  end
  def generate dep = 0, inl = false
    lines = []
    generate_internel lines, dep, inl
    if inl
      return lines.join
    else
      return lines.join "\n"
    end
  end
  # do not def to_s for this class!!!
  def self.parse_arg *args
    if args.last.class == Hash
      attrs = args.pop
    else
      attrs = {}
    end
    text = ""
    args.each do |arg|
      if arg.instance_of? HtmlBuilder
        text += arg.generate(0, true)
      else
        text += arg.to_s
      end
    end
    text = nil if text == ""
    return attrs, text
  end
  def sub_node name, *args, &block
    attrs, text = HtmlBuilder.parse_arg *args
    args.each do |a|
      @children.delete a if a.instance_of? HtmlBuilder
    end
    @children << HtmlBuilder.new(name, attrs, text)
    if block
      @children.last.instance_eval &block
    end
    @children.last
  end
  def self.def_node name
    define_method name do |*args, &block|
      sub_node name, *args, &block
    end
  end
  def text *args, &block
    sub_node nil, *args, &block
  end
  def_node :head
  def_node :title
  def_node :meta
  def_node :link
  def_node :script
  def_node :body
  def_node :a
  def_node :h1
  def_node :div
  def_node :img
  def_node :span
  def javascript code
    script(:type => "text/javascript"){
      text code
    }
  end
end


