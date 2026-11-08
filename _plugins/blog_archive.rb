# frozen_string_literal: true

# Static blog indexes, built at generation time:
#
# - pagination of every page whose front matter sets `paginate: true`
#   (page 1 keeps its permalink, page N lives at `<permalink>page/N/`);
# - one paginated page per tag at `/tag/<slug>/`, plus `site.data.tag_index`
#   and `site.data.tag_ranking` for the tag overview pages. Posts list tag
#   ids in `tags:`; name, description and URL slug of each id come from
#   `_data/tags/<lang>.yml` (see `tag_info`), so the same tag has a different
#   URL in each language;
# - one page per series at `/serie/<id>/`, plus `site.data.series_index`
#   (metadata from `_data/series/<lang>.yml`, missing fields from the default
#   language's file);
# - `related_by_tag` on every post (posts sharing the rarest tags first);
# - Liquid filters `tag_infos`, `tag_url`, `tag_name`, `plain_text`,
#   `local_date`, `span_label`.
#
# Everything is built once per language from `site.data.i18n.posts[lang]`
# (_plugins/i18n.rb): non-default languages live under /<lang>/ and the data
# above is keyed by language (`site.data.tag_index.en`).
#
# Settings (all optional) in _config.yml:
#
#   pagination:
#     per_page: 10
#   tag_path: /tag/
#   series_path: /serie/
#   related_posts: 3

require "nokogiri"

module Klez
  module BlogArchive
    DEFAULT_PER_PAGE = 10

    module_function

    def slug(name)
      Jekyll::Utils.slugify(name.to_s, :mode => "latin")
    end

    def tag_path(site, lang = nil)
      "#{Klez::I18n.prefix(site, lang || Klez::I18n.default_lang(site))}#{dir_path(site.config["tag_path"] || "/tag/")}"
    end

    def series_path(site, lang = nil)
      "#{Klez::I18n.prefix(site, lang || Klez::I18n.default_lang(site))}#{dir_path(site.config["series_path"] || "/serie/")}"
    end

    # A tag as written in front matter is reduced to its id, its slug: `Linux`
    # and `linux` are the same tag.
    def tag_id(value)
      slug(value)
    end

    def post_tag_ids(post)
      Array(post.data["tags"]).compact.map { |t| tag_id(t) }.reject(&:empty?).uniq
    end

    def tag_entry(site, id, lang)
      entry = site.data.dig("tags", lang.to_s, id)
      entry.is_a?(Hash) ? entry : nil
    end

    # {"id", "name", "slug", "url", "description", "theme"} of a tag in `lang`:
    # the entry of `lang` in _data/tags/, else the default language's (the
    # build warns), else the id as name. `theme` is language-neutral and lives
    # in the default language's file only. The slug is the slug of the name.
    def tag_info(site, value, lang = nil)
      default = Klez::I18n.default_lang(site)
      lang = (lang || default).to_s
      id = tag_id(value)
      return nil if id.empty?

      cache = ((@tag_info ||= {})[site.object_id] ||= {})
      cache[[id, lang]] ||= begin
        base = tag_entry(site, id, default)
        entry = tag_entry(site, id, lang) || base || {}
        name = (entry["name"] || id).to_s
        s = slug(name)
        { "id" => id, "name" => name, "slug" => s, "url" => "#{tag_path(site, lang)}#{s}/",
          "description" => entry["description"], "theme" => (base || {})["theme"] == true, }
      end
    end

    def reset_tags(site)
      @tag_info&.delete(site.object_id)
    end

    def tag_url(site, value, lang = nil)
      tag_info(site, value, lang)&.fetch("url")
    end

    def locale(site, lang)
      site.data.dig("locales", lang.to_s) || site.data.dig("locales", Klez::I18n.default_lang(site)) || {}
    end

    def dir_path(path)
      path = "/#{path}" unless path.start_with?("/")
      path.end_with?("/") ? path : "#{path}/"
    end

    def per_page(site, value = nil)
      return value if value.is_a?(Integer) && value.positive?

      configured = (site.config["pagination"] || {})["per_page"]
      configured.is_a?(Integer) && configured.positive? ? configured : DEFAULT_PER_PAGE
    end

    def page_path(base, num)
      num == 1 ? base : "#{base}page/#{num}/"
    end

    # The Liquid `paginator` object. Its keys follow jekyll-paginate, so
    # jekyll-seo-tag adds "Pagina N di M" to the title of pages after the first.
    def pager(posts, num, total, size, base, total_posts)
      {
        "page"               => num,
        "per_page"           => size,
        "posts"              => posts,
        "total_posts"        => total_posts,
        "total_pages"        => total,
        "previous_page"      => num > 1 ? num - 1 : nil,
        "previous_page_path" => num > 1 ? page_path(base, num - 1) : nil,
        "next_page"          => num < total ? num + 1 : nil,
        "next_page_path"     => num < total ? page_path(base, num + 1) : nil,
        "pages"              => (1..total).map { |n| { "num" => n, "path" => page_path(base, n) } },
      }
    end

    # Yields [posts_slice, pager] for each page of `posts`.
    def each_page(posts, size, base)
      slices = posts.each_slice(size).to_a
      slices = [[]] if slices.empty?
      slices.each_with_index do |slice, i|
        yield slice, pager(slice, i + 1, slices.size, size, base, posts.size)
      end
    end
  end

  class GeneratedPage < Jekyll::PageWithoutAFile
    def initialize(site, url, data, content)
      super(site, site.source, url, "index.html")
      self.data.merge!(data, "permalink" => url)
      self.content = content
    end
  end

  class BlogArchiveGenerator < Jekyll::Generator
    safe true
    # After _plugins/i18n.rb's early pass (:highest), before its late pass (:low)
    # and before jekyll-sitemap (:lowest).
    priority :high

    LIST = "{% include posts.html posts=paginator.posts %}\n{% include pagination.html %}\n"
    TAG_LIST = "{% if page.description %}<p class=\"tag-description\">{{ page.description | escape }}</p>{% endif %}\n#{LIST}".freeze
    RESERVED_TAG_SLUGS = %w(by-letter by-n-posts).freeze

    def generate(site)
      @site = site
      %w(tag_index tag_ranking series_index).each { |k| site.data[k] = {} }
      Klez::BlogArchive.reset_tags(site)
      views = site.data.dig("i18n", "posts") || {}
      check_tags(views)
      paginate_pages(views)
      views.each do |lang, posts|
        @lang = lang
        @posts = posts
        @loc = Klez::BlogArchive.locale(site, lang)
        tag_pages
        series_pages
      end
      related_posts(views)
    end

    private

    def paginate_pages(views)
      @site.pages.select { |p| p.data["paginate"] }.each do |page|
        posts = views[Klez::I18n.lang_of(@site, page)] || []
        base = Klez::BlogArchive.dir_path(page.url.sub(%r!index\.html\z!, ""))
        size = Klez::BlogArchive.per_page(@site, page.data["paginate"])
        Klez::BlogArchive.each_page(posts, size, base) do |_, pg|
          target = page
          if pg["page"] > 1
            target = Klez::I18n.reread(@site, page)
            target.data.merge!(page.data.slice("lang", "locale", "title", "i18n_key"))
            target.data["i18n_key"] = "#{Klez::I18n.key_of(@site, page)}#page-#{pg["page"]}"
            target.data["permalink"] = pg["pages"][pg["page"] - 1]["path"]
            target.data["sitemap"] = false
            @site.pages << target
          end
          target.pager = pg
        end
      end
    end

    def page_data(extra)
      { "layout" => "page", "lang" => @lang,
        "locale" => Klez::I18n.meta(@site, @lang)["locale"] || @lang, }.merge(extra)
    end

    # Every tag used by a post must be written as its id and have an entry in
    # each language's _data/tags/<lang>.yml (warnings: the build falls back to
    # the default language, then to the id). Two ids with the same URL in a
    # language, or a URL taken by a tag overview page, stop the build.
    def check_tags(views)
      warn = ->(msg) { Jekyll.logger.warn "BlogArchive:", msg }
      used = Hash.new { |h, k| h[k] = [] }
      @site.posts.docs.each do |post|
        Array(post.data["tags"]).compact.each do |tag|
          id = Klez::BlogArchive.tag_id(tag)
          if id.empty?
            warn.call("#{post.relative_path}: tag #{tag.inspect} has no id, ignored")
            next
          end
          warn.call("#{post.relative_path}: tag #{tag.inspect} is written as its id #{id.inspect}") if tag.to_s != id
          used[id] << post
        end
      end
      views.each_key do |lang|
        missing = used.keys.reject { |id| Klez::BlogArchive.tag_entry(@site, id, lang) }.sort
        warn.call("tags missing from _data/tags/#{lang}.yml: #{missing.join(", ")}") unless missing.empty?

        by_slug = used.keys.group_by { |id| Klez::BlogArchive.tag_info(@site, id, lang)["slug"] }
        by_slug.each do |s, ids|
          problem =
            if s.empty? then "tag #{ids.join(", ")}: the name has no URL slug"
            elsif ids.size > 1 then "tags #{ids.sort.join(", ")} share the URL slug #{s.inspect}"
            elsif RESERVED_TAG_SLUGS.include?(s) then "tag #{ids.first} collides with the tag overview #{s.inspect}"
            end
          raise Jekyll::Errors::FatalException, "BlogArchive: #{problem} in #{lang}" if problem
        end
      end
    end

    def tag_pages
      index = tag_groups.map { |id, posts| Klez::BlogArchive.tag_info(@site, id, @lang).merge("count" => posts.size, "posts" => posts) }
      index.sort_by! { |t| [t["name"].unicode_normalize(:nfd).downcase, t["name"]] }
      @site.data["tag_index"][@lang] = index
      # Same tags, most used first (alphabetical among equals): /tag/by-n-posts/
      @site.data["tag_ranking"][@lang] = index.each_with_index.sort_by { |t, i| [-t["count"], i] }.map(&:first)

      title = @loc["tag_title"] || "Tag: %s"
      index.each do |tag|
        Klez::BlogArchive.each_page(tag["posts"], Klez::BlogArchive.per_page(@site), tag["url"]) do |_, pg|
          url = pg["pages"][pg["page"] - 1]["path"]
          # Pages are paired across languages by id: /tag/sicurezza-e-privacy/ <-> /en/tag/security-and-privacy/
          data = page_data("title" => format(title, tag["name"]), "tag" => tag["name"], "tag_id" => tag["id"],
                           "sitemap" => pg["page"] == 1, "i18n_key" => "tag:#{tag["id"]}:#{pg["page"]}")
          data["description"] = tag["description"] if tag["description"]
          page = Klez::GeneratedPage.new(@site, url, data, TAG_LIST)
          page.pager = pg
          @site.pages << page
        end
      end
    end

    # { tag id => [posts of this language's list, newest first] }
    def tag_groups
      groups = Hash.new { |h, k| h[k] = [] }
      @posts.each do |post|
        Klez::BlogArchive.post_tag_ids(post).each { |id| groups[id] << post }
      end
      groups
    end

    def series_pages
      meta = @site.data["series"] || {}
      base = meta[Klez::I18n.default_lang(@site)] || {}
      own = meta[@lang] || {}
      groups = @posts.reverse.select { |p| p.data["series"] }.group_by { |p| p.data["series"].to_s }
      index = groups.map do |id, posts|
        info = (base[id] || {}).merge(own[id] || {})
        url = "#{Klez::BlogArchive.series_path(@site, @lang)}#{Klez::BlogArchive.slug(id)}/"
        # gaps[i]: whole days between part i and part i-1 (nil for the first part)
        gaps = posts.each_cons(2).map { |a, b| ((b.date - a.date) / 86_400).floor }.unshift(nil)
        { "id" => id, "title" => info["title"] || id, "description" => info["description"],
          "parts" => info["parts"], "url" => url, "posts" => posts, "count" => posts.size,
          "date" => posts.last.date, "first_date" => posts.first.date, "last_date" => posts.last.date,
          "gaps" => gaps, }
      end
      index.sort_by! { |s| s["date"] }.reverse!
      @site.data["series_index"][@lang] = index.each_with_object({}) { |s, h| h[s["id"]] = s }

      title = @loc["series_title"] || "Series: %s"
      index.each do |s|
        data = page_data("title" => format(title, s["title"]), "series_id" => s["id"],
                         "i18n_key" => "series:#{s["id"]}")
        @site.pages << Klez::GeneratedPage.new(@site, s["url"], data, "{% include series-page.html %}\n")
      end
    end

    # `related_by_tag` on every post: the posts of its language's list sharing
    # at least one tag, best score first, newest first among equal scores.
    # The score is the sum, over the shared tags, of log(N / n): N posts in the
    # list, n of them with that tag, so a rare tag counts more than a theme
    # used everywhere. Left out: the post itself, its translations and the
    # other parts of its series, which the series navigation already links.
    def related_posts(views)
      limit = @site.config["related_posts"]
      limit = 3 unless limit.is_a?(Integer) && limit >= 0
      ids = Hash.new { |h, p| h[p] = Klez::BlogArchive.post_tag_ids(p) }
      weights = Hash.new do |h, lang|
        list = views[lang] || []
        counts = Hash.new(0)
        list.each { |p| ids[p].each { |id| counts[id] += 1 } }
        h[lang] = counts.to_h { |id, n| [id, Math.log(list.size.to_f / n)] }
      end
      @site.posts.docs.each do |post|
        lang = Klez::I18n.lang_of(@site, post)
        key = Klez::I18n.key_of(@site, post)
        series = post.data["series"]
        own = ids[post]
        scored = (views[lang] || []).each_with_index.filter_map do |other, rank|
          next if Klez::I18n.key_of(@site, other) == key || (series && other.data["series"] == series)

          shared = ids[other] & own
          next if shared.empty?

          [-shared.sum { |id| weights[lang].fetch(id, 0.0) }.round(9), rank, other]
        end
        post.data["related_by_tag"] = scored.min(limit) { |a, b| (a[0] <=> b[0]).nonzero? || a[1] <=> b[1] }.map(&:last)
      end
    end
  end

  module BlogArchiveFilters
    # {{ post.tags | tag_infos: page.lang }}: the tags as `tag_info` hashes
    # (id, name, slug, url, description, theme), sorted by name. Without a
    # language, the language of the page being rendered.
    def tag_infos(input, lang = nil)
      site = @context.registers[:site]
      lang ||= page_lang
      Array(input).compact.filter_map { |t| Klez::BlogArchive.tag_info(site, t, lang) }.uniq { |t| t["id"] }
                  .sort_by { |t| [t["name"].unicode_normalize(:nfd).downcase, t["name"]] }
    end

    # {{ tag | tag_url: page.lang | relative_url }}
    def tag_url(input, lang = nil)
      Klez::BlogArchive.tag_url(@context.registers[:site], input, lang || page_lang)
    end

    # {{ tag | tag_name: page.lang }}
    def tag_name(input, lang = nil)
      Klez::BlogArchive.tag_info(@context.registers[:site], input, lang || page_lang)&.fetch("name")
    end

    # {{ post.date | local_date }} -> "21 febbraio 2010", month names from
    # `months` in _data/locales/<lang>.yml of the page being rendered (Jekyll's
    # date filter is English only). {{ site.time | local_date: "time" }} adds ", 02:59".
    def local_date(input, mode = nil)
      return input if input.nil? || input.to_s.empty?

      date = input.respond_to?(:month) ? input : Jekyll::Utils.parse_date(input.to_s)
      months = locale["months"]
      text =
        if months.is_a?(Array) && months.size == 12
          "#{date.day} #{months[date.month - 1]} #{date.year}"
        else
          date.strftime("%-d %b %Y")
        end
      mode == "time" ? "#{text}, #{date.strftime("%H:%M")}" : text
    end

    # {{ days | span_label }} -> "8 giorni", "4 mesi", "2 anni"
    def span_label(days)
      days = days.to_i
      n, unit =
        if days < 60 then [days, "days"]
        elsif days < 730 then [(days / 30.44).round, "months"]
        else [(days / 365.25).round, "years"]
        end
      key = n == 1 ? "span_#{unit}_one" : "span_#{unit}_other"
      (locale[key] || "%count% #{unit}").sub("%count%", n.to_s)
    end

    # Rendered HTML to plain text (search index, series excerpts): drops
    # scripts and styles, keeps block elements apart, decodes entities,
    # collapses whitespace. {{ html | plain_text: "no_headings" }} also drops
    # h1-h6, which read as run-on sentences in a short excerpt.
    def plain_text(input, mode = nil)
      fragment = Nokogiri::HTML::DocumentFragment.parse(input.to_s)
      fragment.css("script, style").each(&:remove)
      fragment.css("h1, h2, h3, h4, h5, h6").each(&:remove) if mode == "no_headings"
      fragment.css("p, li, h1, h2, h3, h4, h5, h6, blockquote, div, br, tr").each { |n| n.after(" ") }
      fragment.text.gsub(%r!\s+!, " ").strip
    end

    private

    def page_lang
      page = @context.registers[:page]
      page && page["lang"]
    end

    def locale
      Klez::BlogArchive.locale(@context.registers[:site], page_lang)
    end
  end
end

# jekyll-seo-tag reads the "Pagina N di M" title prefix from the site config at
# render time: set it to the language of each page before rendering it.
Jekyll::Hooks.register :pages, :pre_render do |page|
  message = Klez::BlogArchive.locale(page.site, Klez::I18n.lang_of(page.site, page))["seo_page_of"]
  page.site.config["seo_paginator_message"] = message if message
end

Liquid::Template.register_filter(Klez::BlogArchiveFilters)
