#!/bin/bash 

awesome-client '
awful = require("awful")
awful.spawn("thunderbird", {tag = "1"})
awful.spawn("firefox --new-window \"https://easyjob.mephistomedia.com/\"", {tag = "1", screen = 2})
'

sleep 2
awesome-client '
awful = require("awful")
awful.spawn("firefox --new-window \"https://mephistomedia-my.sharepoint.com/personal/info_mephistomedia_com/_layouts/15/onedrive.aspx?id=%2Fpersonal%2Finfo%5Fmephistomedia%5Fcom%2FDocuments%2FDokumente\"", {tag = "3"})
awful.spawn("pcmanfm", {tag = "3"})
'

sleep 2
awesome-client '
awful = require("awful")
awful.spawn("firefox --new-window \"music.youtube.com\"", {tag = "6"})
'
