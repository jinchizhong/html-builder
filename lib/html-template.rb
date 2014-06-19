require 'html-builder'

class HtmlTemplate
  def template opts = {}
    @opts = opts
    html(:xmlns => "http://www.w3.org/1999/xhtml") {
      head {
        title @args[:title] if @args[:title]
      }
      body {
        div(:id => "header") {
          header_part
        }
        div(:id => "main") {
          main_part
        }
      }
    }
  end
  def header_part
  end
  def main_part
  end
end
