# frozen_string_literal: true

# Liquid filter `themed_images`: an image with a dark twin follows the site theme.
# For every <img src="/path/name.ext"> whose source tree also holds
# /path/name-dark.ext, the image is wrapped in
#   <picture><source srcset="/path/name-dark.ext" media="(prefers-color-scheme: dark)"
#            data-theme-dark><img ...></picture>
# Without JavaScript the browser picks the variant from the system preference;
# assets/theme-toggle.js rewrites `media` on those <source> elements when the reader
# forces light or dark with the toggle. The Markdown stays a plain image, IAL
# included ({: .img-fluid }): the dark file next to it is the whole opt-in.
# _scripts/diagrams writes the -dark.svg of every PlantUML diagram that includes
# _includes/plantuml/common.iuml.
# Used in the post, page and profile-page layouts, chained after heading_anchors,
# so feeds and excerpts (post.content) keep the plain <img>.

module Klez
  module ThemedImages
    IMG = /<img\b[^>]*?\bsrc="([^"]+)"[^>]*>/m.freeze

    def themed_images(html)
      site = @context.registers[:site]
      base = site.config["baseurl"].to_s
      html.to_s.gsub(IMG) do
        img = Regexp.last_match(0)
        dark = Klez::ThemedImages.dark_twin(site, base, Regexp.last_match(1))
        next img unless dark

        %(<picture><source srcset="#{dark}" media="(prefers-color-scheme: dark)" data-theme-dark>#{img}</picture>)
      end
    end

    # URL of the dark twin of a local image, or nil.
    def self.dark_twin(site, base, src)
      return nil if src.include?("://") || src.start_with?("//", "data:")

      path = src.split(/[?#]/, 2).first
      path = path.delete_prefix(base) unless base.empty?
      return nil unless path.start_with?("/")

      ext = File.extname(path)
      return nil if ext.empty? || File.basename(path, ext).end_with?("-dark")

      dark = path.delete_suffix(ext) + "-dark" + ext
      @exists ||= {}
      key = File.join(site.source, dark)
      @exists[key] = File.file?(key) unless @exists.key?(key)
      @exists[key] ? base + dark : nil
    end
  end
end

Liquid::Template.register_filter(Klez::ThemedImages)

# The existence cache must not outlive a build (jekyll serve rebuilds in-process).
Jekyll::Hooks.register :site, :after_reset do
  Klez::ThemedImages.instance_variable_set(:@exists, nil)
end
