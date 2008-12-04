require 'rdoc/generator/html'
require 'stringio'

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
  
  def generate_html
    @main_url = main_url

    # the individual descriptions for files and classes
    gen_into(@files)
    gen_into(@classes)

    # and the index file
    #gen_file_index
    #gen_class_index
    #gen_method_index
    generate_main_index
  end
  
  def generate_main_index
    main = template_page hanna::INDEX
    
    open('index.html', 'w')  do |index|
      main.write_html_on index,
        'initial_page'  => @main_url,
        'style_url'     => style_url('', @options.css),
        'title'         => @options.title,
        'charset'       => @options.charset,
        'file_index'    => generate_inline(@files, hanna::FILE_INDEX)
    end
  end
  
  def generate_inline(collection, template)
    inline = template_page(template)
    
    entries = collection.sort.inject([]) do |items, item|
      if item.document_self
        items << { "href" => item.path, "name" => item.index_name }
      end
      items
    end
    
    out = StringIO.new
    inline.write_html_on(out, 'entries' => entries)
    out.string
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