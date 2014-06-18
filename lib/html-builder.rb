class HtmlBuilderNode
  INDENT = "\t"

  def initialize parent, name, *args
    @attrs = args.last.is_a?(Hash) ? args.pop : {}
    @name = name
    if not args.empty?
      @text = args.collect do |a|
        if a.is_a? HtmlBuilderNode
          parent.children.delete a
          a.to_s(0, true)
        else
          a.to_s
        end
      end.join
    end
    parent.children << self if parent
    @children = []
  end
  attr_accessor :children
  def format_node_inner
    [@name, *@attrs.collect{|k,v| "#{k}=\"#{v}\""}].join ' '
  end
  def to_s ind = 0, inl = false
    raise "Cannot own text and child both!" if @text and not @children.empty?
    if inl
      if @text
        return "<#{format_node_inner}>#{@text}</#{@name}>"
      elsif not @children.empty?
        return ["<#{format_node_inner}>", *@children.collect{|c| c.to_s 0, true}, "</#{@name}>"].join
      else
        return "<#{format_node_inner}/>"
      end
    else
      if @text
        return "#{INDENT * ind}<#{format_node_inner}>#{@text}</#{@name}>\n"
      elsif not @children.empty?
        return ["#{INDENT * ind}<#{format_node_inner}>\n", *@children.collect{|c| c.to_s(ind + 1)}, "#{INDENT * ind}</#{@name}>\n"].join
      else
        return "#{INDENT * ind}<#{format_node_inner}/>\n"
      end
    end
  end
end

class HtmlBuilder
  def self.html *args, &block
    generate :html, *args, &block
  end
  def self.generate root_ele, *args, &block
    x = self.new
    x.build_tree root_ele, *args, &block
    x.to_s
  end
  def initialize
    @root = nil
    @stack = []
  end
  def inspect
    nil
  end
  def to_s *args
    @root.to_s *args
  end
  def build_tree root_name, *args, &block
    @root = HtmlBuilderNode.new nil, root_name, *args
    yield_block @root, &block
  end
  def yield_block e, &block
    return unless block
    @stack << e
    instance_eval &block
    @stack.pop
  end
  def add_child name, *args, &block
    e = HtmlBuilderNode.new @stack.last, name, *args
    yield_block e, &block
  end
  def self.def_tag name
    define_method name do |*args, &block|
      add_child name, *args, &block
    end
  end
  def_tag :a
  def_tag :abbr
  def_tag :acronym
  def_tag :address
  def_tag :applet
  def_tag :area
  def_tag :article
  def_tag :aside
  def_tag :audio
  def_tag :b
  def_tag :base
  def_tag :basefont
  def_tag :bdi
  def_tag :bdo
  def_tag :big
  def_tag :blockquote
  def_tag :body
  def_tag :br
  def_tag :button
  def_tag :canvas
  def_tag :caption
  def_tag :center
  def_tag :cite
  def_tag :code
  def_tag :col
  def_tag :colgroup
  def_tag :command
  def_tag :datalist
  def_tag :dd
  def_tag :del
  def_tag :details
  def_tag :dir
  def_tag :div
  def_tag :dfn
  def_tag :dialog
  def_tag :dl
  def_tag :dt
  def_tag :em
  def_tag :embed
  def_tag :fieldset
  def_tag :figcaption
  def_tag :figure
  def_tag :font
  def_tag :footer
  def_tag :form
  def_tag :frame
  def_tag :frameset
  def_tag :h1
  def_tag :h2
  def_tag :h3
  def_tag :h4
  def_tag :h5
  def_tag :h6
  def_tag :head
  def_tag :header
  def_tag :hr
  def_tag :html
  def_tag :i
  def_tag :iframe
  def_tag :img
  def_tag :input
  def_tag :ins
  def_tag :isindex
  def_tag :kbd
  def_tag :keygen
  def_tag :label
  def_tag :legend
  def_tag :li
  def_tag :link
  def_tag :map
  def_tag :mark
  def_tag :menu
  def_tag :menuitem
  def_tag :meta
  def_tag :meter
  def_tag :nav
  def_tag :noframes
  def_tag :noscript
  def_tag :object
  def_tag :ol
  def_tag :optgroup
  def_tag :option
  def_tag :output
  def_tag :p
  def_tag :param
  def_tag :pre
  def_tag :progress
  def_tag :q
  def_tag :rp
  def_tag :rt
  def_tag :ruby
  def_tag :s
  def_tag :samp
  def_tag :script
  def_tag :section
  def_tag :select
  def_tag :small
  def_tag :source
  def_tag :span
  def_tag :strike
  def_tag :strong
  def_tag :style
  def_tag :sub
  def_tag :summary
  def_tag :sup
  def_tag :table
  def_tag :tbody
  def_tag :td
  def_tag :textarea
  def_tag :tfoot
  def_tag :th
  def_tag :thead
  def_tag :time
  def_tag :title
  def_tag :tr
  def_tag :track
  def_tag :tt
  def_tag :u
  def_tag :ul
  def_tag :var
  def_tag :video
  def_tag :wbr
  def_tag :xmp
end

