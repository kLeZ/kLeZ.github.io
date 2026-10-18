# frozen_string_literal: true

# site.git.last_commit for _pages/build.html, in place of the jekyll-git_metadata
# gem (unmaintained, pinned to Jekyll 3). Same keys as that gem used:
# long_sha, short_sha, message, commit_date.

require "open3"

module Klez
  class GitMetadataGenerator < Jekyll::Generator
    safe true
    priority :highest

    FORMAT = "%H%x00%h%x00%cI%x00%B"

    def generate(site)
      out, status = Open3.capture2("git", "-C", site.source, "log", "-1", "--format=#{FORMAT}")
      return Jekyll.logger.warn("GitMetadata:", "git log failed, site.git is empty") unless status.success?

      long_sha, short_sha, date, message = out.split("\0", 4)
      site.config["git"] = {
        "last_commit" => {
          "long_sha"    => long_sha,
          "short_sha"   => short_sha,
          "commit_date" => Time.parse(date),
          "message"     => message.to_s.strip,
        },
      }
    rescue Errno::ENOENT
      Jekyll.logger.warn "GitMetadata:", "git not found, site.git is empty"
    end
  end
end
