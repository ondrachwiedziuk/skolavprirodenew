module Jekyll
  class IncludeContentTag < Liquid::Tag
    def initialize(tag_name, param, tokens)
      super
      @param = param.strip
    end

    def render(context)
      site = context.registers[:site]
      page = context.registers[:page]
      
      # Get directory from front matter, default to "_includes_content/"
      content_dir = "_langs/" + (page["lang"] || "cs")
      base_dir = File.join(site.source, content_dir)

      # Determine file paths
      file_path_md = File.join(base_dir, "#{@param}.md")
      file_path_html = File.join(base_dir, "#{@param}.html")

      # Read content if file exists
      if File.exist?(file_path_md)
        content = File.read(file_path_md)
        ext = ".md"
      elsif File.exist?(file_path_html)
        content = File.read(file_path_html)
        ext = ".html"
      else
        puts("Error: File \"#{@param}\" not found in #{content_dir}/")
        return %Q[<p style="color: red;">Error: File "#{@param}" not found in #{content_dir}/</p>]
      end

      # First, render the content as Liquid
      liquid_content = Liquid::Template.parse(content).render(context)

      # Convert Markdown if necessary
      if ext == ".md"
        converter = site.find_converter_instance(Jekyll::Converters::Markdown)
        content = converter.convert(liquid_content)
      end

      content
    end
  end
end


Liquid::Template.register_tag("lang_include", Jekyll::IncludeContentTag)
