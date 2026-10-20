# frozen_string_literal: true

# Liquid filter `heading_anchors`: a "§" link before every h2-h6 that kramdown gave
# an id, <h2 id="x"><a class="heading-anchor" href="#x">§</a>Title</h2>. No
# JavaScript; style in _sass/bootkyll/_heading-anchors.scss.
# Used in the post and page layouts ({{ content | heading_anchors }}), so feeds and
# excerpts, which take post.content, stay without. Only Markdown sources get it, and
# not the `localize: true` listings (home, blog), whose content is post excerpts.
# The link label comes from `heading_anchor` in _data/locales/<lang>.yml.

require "cgi"

module Klez
  module HeadingAnchors
    HEADING = %r{<(h[2-6]) id="([^"]+)"([^>]*)>(.*?)</\1>}m
    MARKDOWN = %w[.md .markdown .mkdown .mkdn .mkd .draft].freeze

    def heading_anchors(html)
      site = @context.registers[:site]
      page = @context.registers[:page] || {}
      return html if page["localize"] || !MARKDOWN.include?(File.extname(page["path"].to_s))

      default = site.config["default_lang"].to_s
      label = site.data.dig("locales", (page["lang"] || default).to_s, "heading_anchor") ||
              site.data.dig("locales", default, "heading_anchor")
      aria = label ? %( aria-label="#{CGI.escapeHTML(label)}") : ""

      html.to_s.gsub(HEADING) do
        tag, id, attrs, text = Regexp.last_match.captures
        %(<#{tag} id="#{id}"#{attrs}><a class="heading-anchor" href="##{id}"#{aria}>§</a>#{text}</#{tag}>)
      end
    end
  end
end

Liquid::Template.register_filter(Klez::HeadingAnchors)
