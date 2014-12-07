# -*- coding: utf-8 -*-
require 'anemone'
require 'nokogiri'
require 'kconv'

# クロールの起点URLを指定
urls = ["http://www.amazon.co.jp/gp/bestsellers/books/",
    "http://www.amazon.co.jp/gp/bestsellers/digital-text/2275256051/"]

# 巡回サイトのURLを指定
Anemone.crawl(urls, :depth_limit => 0, :skip_query_strings => true) do |anemone|

    # 除外対象ページのURLパターンを指定

    # 巡回対象ページのURLを指定
    anemone.focus_crawl do |page|
        page.links.keep_if { |link|
            link.to_s.match(/\/gp\/bestsellers\/books|\/gp\/bestsellers\/digital-text/)
        }
    end

    # 正規表現で一致したページのみ処理
    PATTERN = %r[466298\/+|466282\/+|2291657051\/+|2291905051\/+]
    anemone.on_pages_like(PATTERN) do |page|
        puts page.url
    end

    # すべてのページに対する処理 
    anemone.on_every_page do |page|
        doc = Nokogiri::HTML.parse(page.body.toutf8)
        category = doc.xpath("//*[@id=\"zg_listTitle\"]/span").text
        sub_category = doc.xpath("//*[@id=\"zg_listTitle\"]/span").text

        puts category + "/" + sub_category

        items = doc.xpath("//div[@class=\"zg_itemRow\"]/div[1]/div[2]")
        items += doc.xpath("//div[@class=\"zg_itemRow\"]/div[2]/div[2]")
        items.each{ |item|
            # 順位
            puts item.xpath("div[1]/span[1]").text
            # 書名
            puts item.xpath("div[\"zg_title\"]/a").text
            # ASIN
            puts item.xpath("div[\"zg_title\"]/a").attribute("href").text.match(%r{dp/(.+?)/})[1]
        }

    end

    # ストレージにに対する処理 
    anemone.after_crawl do |page|
        # 処理
    end

end
