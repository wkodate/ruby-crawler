# -*- coding: utf-8 -*-
require 'anemone'

Anemone.crawl("http://www.yahoo.co.jp") do |anemone|
    # リンクからパターンマッチさせる正規表現
    anemone.skip_links_like /yahoo\//
    anemone.on_every_page do |page|
        puts page.url
    end
end
