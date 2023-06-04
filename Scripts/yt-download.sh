# only Audio
yt-dlp -f 'ba' https://www.youtube.com/watch?v=dQw4w9WgXcQ -o '%(id)s.%(ext)s'

#Audio and Video, best quality
yt-dlp -f 'bv*+ba' https://www.youtube.com/watch?v=dQw4w9WgXcQ -o '%(id)s.%(ext)s'

#Audio and Video, 720p
yt-dlp -f 'bv*[height=720]+ba' https://www.youtube.com/watch?v=dQw4w9WgXcQ -o '%(id)s.%(ext)s'
