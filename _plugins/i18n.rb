# frozen_string_literal: true

# Site languages, built in a single Jekyll process (replaces jekyll-polyglot).
#
# - Every page and document has `lang` (front matter; `_config.yml` defaults
#   give `it` everywhere and `en` under `_posts/en/` and `_pages/en/`).
#   Non-default languages get their URL from the same defaults
#   (`/en/:year/:month/:day/:title/`) or from an explicit permalink: nothing
#   is rewritten after rendering.
# - Translations are paired by file path without the language folder
#   (`_posts/2026-09-17-x.md` <-> `_posts/en/2026-09-17-x.md`), so the
#   translation may set its own `slug`. `i18n_key` in front matter overrides
#   the pairing. `page.translations` maps each language to {url, title, lang}.
# - Pages with `localize: true` (home, blog, tags, series, search and its
#   index) are cloned for each other language under /<lang>/; `title_<lang>`
#   gives the clone its title.
# - `site.data.i18n.posts[lang]`: one entry per post, newest first, in that
#   language when a version exists, otherwise in the language it was written in.
# - Posts and pages without a version in some language get a redirect stub at
#   the URL polyglot used to serve a copy at in that language (/en/<url> for
#   an Italian page, /<url> for an English-only post), pointing to the
#   translation if there is one, else to the page itself.
# - Liquid filter `i18n_url`: {{ '/blog/' | i18n_url: page.lang }} is the
#   localized path when that page exists, the path itself otherwise.

module Klez
  module I18n
    module_function

    def languages(site)
      Array(site.config["languages"]).map(&:to_s)
    end

    def default_lang(site)
      (site.config["default_lang"] || languages(site).first || "it").to_s
    end

    def lang_of(site, item)
      (item.data["lang"] || default_lang(site)).to_s
    end

    def prefix(site, lang)
      lang == default_lang(site) ? "" : "/#{lang}"
    end

    # Pairing key: explicit `i18n_key`, else the source path without the
    # language folder, else the URL (generated pages that set no key).
    def key_of(site, item)
      return item.data["i18n_key"].to_s if item.data["i18n_key"]

      path = item.respond_to?(:relative_path) ? item.relative_path.to_s : ""
      return item.url if path.empty? || item.is_a?(Jekyll::PageWithoutAFile)

      others = languages(site) - [default_lang(site)]
      path.split("/").reject { |seg| others.include?(seg) }.join("/")
    end

    def html?(item)
      item.output_ext == ".html"
    end

    # A second Page read from the same file (Page.new wants the source dir,
    # "" rather than "." for files at the site root).
    def reread(site, page)
      dir = File.dirname(page.relative_path)
      Jekyll::Page.new(site, site.source, dir == "." ? "" : dir, page.name)
    end

    # Registry of the URLs of real (non-redirect) pages, filled by LateGenerator.
    def urls(site)
      @urls ||= {}
      @urls[site.object_id] ||= Set.new
    end

    def reset(site)
      @urls&.delete(site.object_id)
    end

    def localize(site, path, lang)
      path = path.to_s
      return path if lang.to_s.empty? || lang == default_lang(site) || !path.start_with?("/")

      candidate = "#{prefix(site, lang)}#{path}"
      registry = urls(site)
      variants = [candidate, "#{candidate}/", candidate.sub(%r!/\z!, ""), "#{candidate.chomp("/")}/index.html"]
      variants.any? { |v| registry.include?(v) } ? candidate : path
    end
  end

  class I18nRedirect < Jekyll::PageWithoutAFile
    def initialize(site, url, target, lang)
      dir, name = url.end_with?("/") ? [url, "index.html"] : [File.dirname(url), File.basename(url)]
      super(site, site.source, dir, name)
      data.merge!("layout" => "redirect", "redirect_to" => target, "lang" => lang,
                  "sitemap" => false, "permalink" => url, "i18n_redirect" => true)
      self.content = ""
    end
  end

  # Runs first: clones localized pages, copies `series` across translations,
  # builds the per-language post lists used by _plugins/blog_archive.rb.
  class I18nEarlyGenerator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      I18n.reset(site)
      @site = site
      @default = I18n.default_lang(site)
      @others = I18n.languages(site) - [@default]
      clone_localized_pages
      groups = post_groups
      share_series(groups)
      site.data["i18n"] = { "posts" => post_views(groups) }
    end

    private

    def clone_localized_pages
      @site.pages.select { |p| p.data["localize"] && I18n.lang_of(@site, p) == @default }.each do |page|
        @others.each do |lang|
          clone = I18n.reread(@site, page)
          clone.data["lang"] = lang
          clone.data["permalink"] = "#{I18n.prefix(@site, lang)}#{page.url}"
          clone.data["title"] = page.data["title_#{lang}"] if page.data["title_#{lang}"]
          clone.data["locale"] = @site.data.dig("languages", lang, "locale") || lang
          clone.data["i18n_key"] = I18n.key_of(@site, page)
          @site.pages << clone
        end
      end
    end

    def post_groups
      @site.posts.docs.group_by { |d| I18n.key_of(@site, d) }.transform_values do |docs|
        docs.to_h { |d| [I18n.lang_of(@site, d), d] }
      end
    end

    # A translation without `series` stays in the series of its original.
    def share_series(groups)
      groups.each_value do |versions|
        series = versions.values.map { |d| d.data["series"] }.compact.first
        versions.each_value { |d| d.data["series"] ||= series } if series
      end
    end

    def post_views(groups)
      I18n.languages(@site).to_h do |lang|
        picked = groups.values.map { |v| v[lang] || v[@default] || v.values.first }
        [lang, picked.sort_by { |d| [d.date, d.relative_path] }.reverse]
      end
    end
  end

  # Runs after the generators that add pages (blog_archive: :high) and before
  # jekyll-sitemap (:lowest): pairs translations, records the URL registry,
  # adds redirect stubs for the old /<lang>/ copies.
  class I18nLateGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      @site = site
      all = (site.pages + site.posts.docs).reject { |i| i.data["i18n_redirect"] }
      registry = I18n.urls(site)
      all.each { |i| registry << i.url }
      items = all.select { |i| I18n.html?(i) }
      translations(items)
      redirects(items, registry)
    end

    private

    def translations(items)
      items.group_by { |i| I18n.key_of(@site, i) }.each_value do |group|
        map = group.each_with_object({}) do |i, h|
          h[I18n.lang_of(@site, i)] ||= { "url" => i.url, "title" => i.data["title"], "lang" => I18n.lang_of(@site, i) }
        end
        group.each { |i| i.data["translations"] = map }
      end
    end

    # polyglot served every page in every language: a page written in one
    # language also existed under the other languages' prefixes (/en/<url> for
    # an Italian page, /<url> for an English-only post). Only posts and
    # file-backed pages, the URLs it actually published, get a redirect stub.
    def redirects(items, registry)
      sources = items.reject do |i|
        i.is_a?(Jekyll::PageWithoutAFile) || i.data["localize"] || i.data["redirect_to"] || i.url == "/404.html"
      end
      taken = registry.dup
      sources.each do |src|
        from = I18n.lang_of(@site, src)
        bare = src.url.delete_prefix(I18n.prefix(@site, from))
        (I18n.languages(@site) - [from]).each do |lang|
          old = "#{I18n.prefix(@site, lang)}#{bare}"
          next if taken.include?(old)

          taken << old
          target = src.data["translations"]&.dig(lang, "url") || src.url
          @site.pages << I18nRedirect.new(@site, old, target, lang)
        end
      end
    end
  end

  module I18nFilters
    # {{ '/blog/' | i18n_url: page.lang | relative_url }}
    def i18n_url(path, lang = nil)
      I18n.localize(@context.registers[:site], path, lang)
    end
  end
end

Liquid::Template.register_filter(Klez::I18nFilters)
