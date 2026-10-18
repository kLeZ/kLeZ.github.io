# frozen_string_literal: true

# Site languages, built in a single Jekyll process (replaces jekyll-polyglot).
#
# A language is an entry in `languages:` (_config.yml) plus its
# `_data/locales/<lang>.yml`: interface strings, `language` (flag, name,
# locale...), titles of the localized pages (`page_translations`) and of
# the series (`series_translations`). Nothing else in the site names a language.
#
# - Every page and document has `lang`: `default_lang` (via the `_config.yml`
#   defaults), or the language folder it sits in (`_posts/en/x.md`,
#   `_pages/en/about.md`), which wins over front matter. Items in a language
#   folder also get `locale` and the `/<lang>` URL prefix: posts take the
#   site permalink under it (`/en/:year/:month/:day/:title/`), pages get it
#   prepended to their permalink. URLs are not rewritten after rendering.
# - Translations are paired by file path without the language folder
#   (`_posts/2026-09-17-x.md` <-> `_posts/en/2026-09-17-x.md`), so the
#   translation may set its own `slug`. `i18n_key` in front matter overrides
#   the pairing. `page.translations` maps each language to {url, title, lang}.
# - Pages with `localize: true` (home, blog, tags, series, search and its
#   index) are cloned for each other language under /<lang>/; the clone takes
#   its title (and any other field) from `page_translations["<url>"]` in
#   that language's locale file.
# - One Atom feed per language at /<lang>/feed.xml (_includes/atom.xml).
# - `site.data.i18n.posts[lang]`: one entry per post, newest first, in that
#   language when a version exists, otherwise in the language it was written in.
# - Posts and pages without a version in some language get a redirect stub at
#   the URL polyglot used to serve a copy at in that language (/en/<url> for
#   an Italian page, /<url> for an English-only post), pointing to the
#   translation if there is one, else to the page itself. Only for the
#   languages in `i18n_legacy_languages`, the ones polyglot served.
# - Liquid filter `i18n_url`: {{ '/blog/' | i18n_url: page.lang }} is the
#   localized path when that page exists, the path itself otherwise.
#   `language_name`: {{ 'en' | language_name: page.lang }} is "inglese".

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

    def locale(site, lang)
      site.data.dig("locales", lang.to_s) || {}
    end

    def meta(site, lang)
      locale(site, lang)["language"] || {}
    end

    # Language of the folder right below a top-level folder (`_posts/en/x.md`).
    def folder_lang(site, item)
      segs = item.relative_path.to_s.split("/")
      lang = segs[1] if segs.size > 2
      (languages(site) - [default_lang(site)]).include?(lang) ? lang : nil
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

  class I18nFeed < Jekyll::PageWithoutAFile
    def initialize(site, lang)
      # dir/name give relative_path _pages/feeds/<lang>.xml (jekyll_tidy exclude)
      super(site, site.source, "_pages/feeds", "#{lang}.xml")
      data.merge!("layout" => nil, "permalink" => "/#{lang}/feed.xml", "lang" => lang,
                  "sitemap" => false)
      self.content = %({% include atom.xml lang="#{lang}" %}\n)
    end
  end

  # Runs first: applies folder languages, adds the feeds, clones localized
  # pages, copies `series` across translations, builds the per-language post
  # lists used by _plugins/blog_archive.rb.
  class I18nEarlyGenerator < Jekyll::Generator
    safe true
    priority :highest

    def generate(site)
      I18n.reset(site)
      @site = site
      @default = I18n.default_lang(site)
      @others = I18n.languages(site) - [@default]
      folder_languages
      I18n.languages(site).each { |lang| site.pages << I18nFeed.new(site, lang) }
      clone_localized_pages
      groups = post_groups
      share_series(groups)
      site.data["i18n"] = { "posts" => post_views(groups) }
    end

    private

    def folder_languages
      (@site.pages + @site.posts.docs).each do |item|
        lang = I18n.folder_lang(@site, item) or next
        prefix = I18n.prefix(@site, lang)
        permalink = item.data["permalink"]
        if permalink.nil? && item.is_a?(Jekyll::Document)
          item.data["permalink"] = "#{prefix}#{@site.config["permalink"]}"
        elsif permalink && !permalink.start_with?("#{prefix}/")
          item.data["permalink"] = "#{prefix}#{permalink}"
        end
        item.data["lang"] = lang
        item.data["locale"] ||= I18n.meta(@site, lang)["locale"] || lang
        item.instance_variable_set(:@url, nil)
      end
    end

    def clone_localized_pages
      @site.pages.select { |p| p.data["localize"] && I18n.lang_of(@site, p) == @default }.each do |page|
        @others.each do |lang|
          clone = I18n.reread(@site, page)
          clone.data["lang"] = lang
          clone.data["permalink"] = "#{I18n.prefix(@site, lang)}#{page.url}"
          clone.data.merge!(I18n.locale(@site, lang).dig("page_translations", page.url) || {})
          clone.data["locale"] = I18n.meta(@site, lang)["locale"] || lang
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
      legacy = Array(@site.config["i18n_legacy_languages"]).map(&:to_s) & I18n.languages(@site)
      sources.each do |src|
        from = I18n.lang_of(@site, src)
        next unless legacy.include?(from)

        bare = src.url.delete_prefix(I18n.prefix(@site, from))
        (legacy - [from]).each do |lang|
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

    # {{ 'en' | language_name: page.lang }} -> "inglese": from `language_names`
    # in the page's locale, else the language's own name.
    def language_name(lang, in_lang = nil)
      site = @context.registers[:site]
      I18n.locale(site, in_lang || I18n.default_lang(site)).dig("language_names", lang.to_s) ||
        I18n.meta(site, lang)["name"] || lang.to_s
    end
  end
end

Liquid::Template.register_filter(Klez::I18nFilters)
