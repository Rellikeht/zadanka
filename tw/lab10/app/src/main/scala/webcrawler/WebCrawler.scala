package webcrawler

object WebCrawler {
  import scala.io.Source
  import org.htmlcleaner.HtmlCleaner
  import java.net.URL
  import java.nio.file.{Paths, Files}
  import java.nio.file.FileAlreadyExistsException
  import scala.collection.mutable

  private val defaultLevel = 2
  private val visited = mutable.Set[String]()
  private val path = Paths.get(".", "html_files")
  if (Files.exists(path)) {
    if (!Files.isDirectory(path)) {
      throw new FileAlreadyExistsException(
        "Cannot create directory for html files"
      )
    }
  } else Files.createDirectory(path)

  private def download(url: String, level: Int): Unit = {
    // println(url)
    if (level <= 0 || visited(url)) return
    visited += url
    println("visiting " + url)

    try {
      val cleanUrl = url
        .replace("https://", "")
        .replace("http://", "")
        .replace("/", "_")
      // println(cleanUrl)
      val fpath = Paths.get(path.normalize().toString(), cleanUrl)
      val html = Source.fromURL(url)
      val htmlString = html.mkString
      Files.write(fpath, htmlString.getBytes())

      val cleaner = new HtmlCleaner
      val props = cleaner.getProperties()
      val rootNode = cleaner.clean(htmlString)

      val elements = rootNode.getElementsByName("a", true)
      elements map { elem =>
        val url = elem.getAttributeByName("href")
        download(url, level - 1)
      }
    } catch {
      case e: Exception => return
    }
  }

  def crawl(url: String, level: Int = defaultLevel) = {
    download(url, level)
  }
}

object App {
  def main(args: Array[String]): Unit = {
    val url = "http://google.com"
    // val url = "https://suckless.org"

    if (args.length > 0) {
      WebCrawler.crawl(url, args(0).toInt)
    } else {
      WebCrawler.crawl(url)
    }
  }
}
