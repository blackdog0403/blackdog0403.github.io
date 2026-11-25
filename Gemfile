source "https://rubygems.org"

gem "jekyll", "~> 4.4"

group :jekyll_plugins do
  gem "jekyll-paginate"
  gem "jekyll-sitemap"
  gem "jekyll-gist"
  gem "jekyll-feed"
  gem "jekyll-include-cache"
  # The legacy GitHub Pages build rendered front-matter-less Markdown (gosample/)
  # and gave it the "page" layout; these two plugins reproduce that.
  gem "jekyll-optional-front-matter"
  gem "jekyll-default-layout"
end

# Ruby 3.x no longer bundles webrick, which `jekyll serve` needs.
gem "webrick", "~> 1.8"
