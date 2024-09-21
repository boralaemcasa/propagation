from pytube import YouTube, Playlist

playlist_link = "https://www.youtube.com/playlist?list=UULFdcL3nma0HpYkWFH52YE06Q"

video_links = Playlist(playlist_link).video_urls

for link in video_links:
	print("\"" + YouTube(link).title + "\",\"" + link + "&list=UULFdcL3nma0HpYkWFH52YE06Q\"")
	# break