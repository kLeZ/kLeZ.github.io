# frozen_string_literal: true

# Workaround for jekyll-polyglot 1.14.0: after {% I18n_Headers %} has written
# the canonical URL, Site#relativize_absolute_urls rewrites every absolute
# href of a non-default-language page to /<lang>/..., canonical included.
# Its exclusion list covers only the default-language and x-default hreflang
# links, so `fallback_canonical_to_default_lang` never reaches the output.
#
# The canonical href is renamed to `ferh` (polyglot's own "do not relativize"
# marker) before that step; correct_nonrelativized_absolute_urls, which runs
# right after, turns it back into href unchanged.

module Klez
  module PolyglotCanonical
    CANONICAL = 'rel="canonical" href='

    def relativize_absolute_urls(doc, regex, url)
      doc.output = doc.output.gsub(CANONICAL, 'rel="canonical" ferh=') if doc.output&.include?(CANONICAL)
      super
    end
  end
end

Jekyll::Site.prepend(Klez::PolyglotCanonical) if Jekyll::Site.method_defined?(:relativize_absolute_urls)
