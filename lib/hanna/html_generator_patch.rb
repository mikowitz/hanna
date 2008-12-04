require 'rdoc/generator/html'

RDoc::Generator::HTML.class_eval do
  private
  
  alias :original_write_style_sheet :write_style_sheet
  
  def write_style_sheet
    unless @options.css then
      styles = template_page hanna::STYLE
      
      open(RDoc::Generator::CSS_NAME, 'w') do |css|
        styles.output(css)
      end
    end
  end
  
  # helper methods:
  
  def hanna
    @template
  end
  
  def read(*names)
    hanna.read(*names)
  end
  
  def template_page(*templates)
    RDoc::TemplatePage.new(*templates)
  end
end