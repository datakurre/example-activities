import feedparser
import feedsearch


class FeedLibrary:
    def get_entries(self, url):
        for info in feedsearch.search(url):
            return feedparser.parse(info.url).entries
