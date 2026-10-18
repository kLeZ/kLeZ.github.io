# frozen_string_literal: true

# Static blog indexes, built at generation time:
#
# - pagination of every page whose front matter sets `paginate: true`
#   (page 1 keeps its permalink, page N lives at `<permalink>page/N/`);
# - one paginated page per tag at `/tag/<slug>/`, plus `site.data.tag_index`
#   for the tag overview page;
# - one page per series at `/serie/<id>/`, plus `site.data.series_index`;
# - `related_by_tag` on every post (latest posts sharing a tag);
# - Liquid filters `tag_url`, `tag_slug`, `plain_text`, `local_date`, `span_label`.
#
# Under jekyll-polyglot every language is built in its own process after the
# documents have been coordinated, so `site.posts` already holds the posts of
# the active language (and the default-language fallbacks).
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

    class << self
      # Tags and series of every post file of every language, recorded before
      # jekyll-polyglot drops the posts of the other languages: [{url, tags, series}].
      attr_writer :all_posts

      def all_posts
        @all_posts || []
      end
    end

    module_function

    def slug(name)
      Jekyll::Utils.slugify(name.to_s, :mode => "latin")
    end

    def tag_path(site)
      dir_path(site.config["tag_path"] || "/tag/")
    end

    def series_path(site)
      dir_path(site.config["series_path"] || "/serie/")
    end

    def tag_url(site, name)
      s = slug(name)
      s.empty? ? nil : "#{tag_path(site)}#{s}/"
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
    # Before jekyll-sitemap and jekyll-feed (priority :lowest).
    priority :high

    LIST = "{% include posts.html posts=paginator.posts %}\n{% include pagination.html %}\n"

    def generate(site)
      @site = site
      @posts = site.posts.docs.reverse
      @loc = site.data.dig("locales", site.active_lang || site.config["lang"]) || {}
      seo_message
      paginate_pages
      tag_pages
      series_pages
      related_posts
    end

    private

    def seo_message
      message = @loc["seo_page_of"]
      @site.config["seo_paginator_message"] = message if message
    end

    def paginate_pages
      @site.pages.select { |p| p.data["paginate"] }.each do |page|
        base = Klez::BlogArchive.dir_path(page.url.sub(%r!index\.html\z!, ""))
        size = Klez::BlogArchive.per_page(@site, page.data["paginate"])
        Klez::BlogArchive.each_page(@posts, size, base) do |_, pg|
          target = page
          if pg["page"] > 1
            target = Jekyll::Page.new(@site, @site.source, File.dirname(page.relative_path), page.name)
            target.data["permalink"] = pg["pages"][pg["page"] - 1]["path"]
            target.data["sitemap"] = false
            @site.pages << target
          end
          target.pager = pg
        end
      end
    end

    def tag_pages
      index = tag_groups(@posts.map { |p| [p, p.data["tags"]] }).map { |url, g| tag_entry(url, g) }
      index.sort_by! { |t| [t["name"].unicode_normalize(:nfd).downcase, t["name"]] }
      @site.data["tag_index"] = index
      # Same tags, most used first (alphabetical among equals): /tag/classifica/
      @site.data["tag_ranking"] = index.each_with_index.sort_by { |t, i| [-t["count"], i] }.map(&:first)

      # Tags used only by another language version of a post still get a page
      # (outside the index and the sitemap), so the language switcher of every
      # tag page has a target.
      by_url = @posts.each_with_object({}) { |p, h| h[p.url] = p }
      known = index.map { |t| t["url"] }
      others = Klez::BlogArchive.all_posts.map { |e| [by_url[e["url"]], e["tags"]] }.select(&:first)
      extra = tag_groups(others).reject { |url, _| known.include?(url) }.map { |url, g| tag_entry(url, g) }

      ranking_url = "#{Klez::BlogArchive.tag_path(@site)}classifica/"
      if (index + extra).any? { |t| t["url"] == ranking_url }
        Jekyll.logger.warn "BlogArchive:", "tag page #{ranking_url} collides with the tag ranking page"
      end

      title = @loc["tag_title"] || "Tag: %s"
      (index + extra).each do |tag|
        listed = known.include?(tag["url"])
        Klez::BlogArchive.each_page(tag["posts"], Klez::BlogArchive.per_page(@site), tag["url"]) do |_, pg|
          url = pg["pages"][pg["page"] - 1]["path"]
          data = { "layout" => "page", "title" => format(title, tag["name"]), "tag" => tag["name"],
                   "sitemap" => listed && pg["page"] == 1, }
          page = Klez::GeneratedPage.new(@site, url, data, LIST)
          page.pager = pg
          @site.pages << page
        end
      end
    end

    # [[post, tags], ...] -> { tag_url => { "names" => {spelling => uses}, "posts" => [...] } }
    def tag_groups(pairs)
      groups = {}
      pairs.each do |post, tags|
        Array(tags).compact.uniq.each do |tag|
          url = Klez::BlogArchive.tag_url(@site, tag)
          next unless url

          g = (groups[url] ||= { "names" => Hash.new(0), "posts" => [] })
          g["names"][tag.to_s] += 1
          g["posts"] << post unless g["posts"].include?(post)
        end
      end
      groups
    end

    def tag_entry(url, group)
      # Tags differing only in case or accents share a page; show the most used spelling.
      names = group["names"]
      name = names.max_by { |n, c| [c, -names.keys.index(n)] }.first
      { "name" => name, "slug" => url.split("/").last, "url" => url, "count" => group["posts"].size,
        "posts" => group["posts"], }
    end

    def series_pages
      # A translation without `series` stays in the series of its original.
      inherited = Klez::BlogArchive.all_posts.select { |e| e["series"] }.to_h { |e| [e["url"], e["series"]] }
      @posts.each { |p| p.data["series"] ||= inherited[p.url] }

      meta = @site.data["series"] || {}
      groups = @posts.reverse.select { |p| p.data["series"] }.group_by { |p| p.data["series"].to_s }
      index = groups.map do |id, posts|
        info = meta[id] || {}
        url = "#{Klez::BlogArchive.series_path(@site)}#{Klez::BlogArchive.slug(id)}/"
        # gaps[i]: whole days between part i and part i-1 (nil for the first part)
        gaps = posts.each_cons(2).map { |a, b| ((b.date - a.date) / 86_400).floor }.unshift(nil)
        { "id" => id, "title" => info["title"] || id, "description" => info["description"],
          "parts" => info["parts"], "url" => url, "posts" => posts, "count" => posts.size,
          "date" => posts.last.date, "first_date" => posts.first.date, "last_date" => posts.last.date,
          "gaps" => gaps, }
      end
      index.sort_by! { |s| s["date"] }.reverse!
      @site.data["series_index"] = index.each_with_object({}) { |s, h| h[s["id"]] = s }

      title = @loc["series_title"] || "Series: %s"
      index.each do |s|
        data = { "layout" => "page", "title" => format(title, s["title"]), "series_id" => s["id"] }
        @site.pages << Klez::GeneratedPage.new(@site, s["url"], data, "{% include series-page.html %}\n")
      end
    end

    # `related_by_tag` on every post: the most recent posts sharing at least one
    # tag (compared by slug), without the post itself and the other parts of its
    # series, which the series navigation already links.
    def related_posts
      limit = @site.config["related_posts"]
      limit = 3 unless limit.is_a?(Integer) && limit >= 0
      slugs = @posts.to_h do |p|
        [p, Array(p.data["tags"]).compact.map { |t| Klez::BlogArchive.slug(t) }.reject(&:empty?).uniq]
      end
      @posts.each do |post|
        mine = slugs[post]
        series = post.data["series"]
        post.data["related_by_tag"] = @posts.lazy.select do |other|
          other != post && (series.nil? || other.data["series"] != series) && (slugs[other] & mine).any?
        end.first(limit)
      end
    end
  end

  module BlogArchiveFilters
    # {{ tag | tag_url | relative_url }}
    def tag_url(input)
      Klez::BlogArchive.tag_url(@context.registers[:site], input)
    end

    # {{ tag | tag_slug }}
    def tag_slug(input)
      Klez::BlogArchive.slug(input)
    end

    # {{ post.date | local_date }} -> "21 febbraio 2010", month names from
    # `months` in _data/locales/<lang>.yml (Jekyll's date filter is English only).
    def local_date(input)
      date = Jekyll::Utils.parse_date(input.to_s) unless input.respond_to?(:month)
      date ||= input
      months = locale["months"]
      return date.strftime("%-d %b %Y") unless months.is_a?(Array) && months.size == 12

      "#{date.day} #{months[date.month - 1]} #{date.year}"
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

    def locale
      site = @context.registers[:site]
      site.data.dig("locales", site.active_lang || site.config["lang"]) || {}
    end
  end
end

# Priority :high runs this before jekyll-polyglot's coordination hook (:normal).
Jekyll::Hooks.register :site, :post_read, :priority => :high do |site|
  lang_segments = site.respond_to?(:document_url_regex) ? site.document_url_regex : nil
  Klez::BlogArchive.all_posts = site.posts.docs.map do |doc|
    # Built by hand: Document#url memoizes, and polyglot changes the permalink afterwards.
    url = Jekyll::URL.new(
      :template     => doc.url_template,
      :placeholders => doc.url_placeholders,
      :permalink    => doc.permalink
    ).to_s
    url = url.gsub(lang_segments, "/") if lang_segments
    { "url" => url, "tags" => doc.data["tags"], "series" => doc.data["series"] }
  end
end

Liquid::Template.register_filter(Klez::BlogArchiveFilters)
