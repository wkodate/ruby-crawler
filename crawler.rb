# -*- coding: utf-8 -*-
require 'open-uri'

def parse(source)
    title = source.scan(%r!<title>(.+?)</title>!)
    return title
end

def format_text(title)
    s = "Title: #{title[0][0]}\n"
    return s
end

#puts format_text(parse(`/usr/local/bin/wget -q -O- http://www.yahoo.co.jp`))
puts format_text(parse(open('http://www.yahoo.co.jp', &:read)))

