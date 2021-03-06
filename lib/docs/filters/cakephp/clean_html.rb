module Docs
  class Cakephp
    class CleanHtmlFilter < Filter
      def call
        css('.breadcrumbs', 'a.permalink', 'a.anchor').remove

        css('.section', '#content', '.description', '.list').each do |node|
          node.before(node.children).remove
        end

        css('h1').drop(1).each do |node|
          node.name = 'h2'
        end

        css('> h6').each do |node|
          node.name = 'h2'
        end

        css('h6').each do |node|
          node.name = 'h4'
        end

        css('.property-name').each do |node|
          node.name = 'h3'
        end

        css('var').each do |node|
          node.name = 'code'
        end

        # Move dummy anchor to method and property name

        css('.method-detail').each do |node|
          node.at_css('.method-name')['id'] = node.at_css('a')['id']
        end

        css('.property-detail').each do |node|
          node.at_css('.property-name')['id'] = node['id']
          node.remove_attribute('id')
        end

        # Break out source link to separate element

        css('.method-name', '.property-name').each do |node|
          source = node.at_css('a')
          source.before(%(<span class="name">#{source.content}</span>))
          source.content = 'source'
          source['class'] = 'source'
        end

        css('.method-signature').each do |node|
          node.name = 'pre'
          node.content = node.content.strip
          node['data-language'] = 'php'
        end

        css('span.name > code').each do |node|
          node.content = node.content.strip
        end

        css('code code').each do |node|
          node.before(node.children).remove
        end

        css('code').each do |node|
          node.inner_html = node.inner_html.squish
        end

        doc
      end
    end
  end
end
