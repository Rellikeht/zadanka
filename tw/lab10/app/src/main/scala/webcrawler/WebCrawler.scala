package webcrawler

object WebCrawler {
  import scala.io.Source
  import org.htmlcleaner.HtmlCleaner
  import java.net.URL
  val defaultLevel = 5

  def crawl(level: Int = defaultLevel) = {
    // println(sys.props.get("user.dir"))
    val path = Paths.get(".", "html_files")
    println(path)
    // if(!(Files.exists(path) && Files.isDirectory(path)))
    Files.createDirectory(path)

    println()
    return

    val url = "http://google.com"
    val html = Source.fromURL(url)

    val cleaner = new HtmlCleaner
    val props = cleaner.getProperties

    val rootNode = cleaner.clean(html.mkString)
    // val rootNode = cleaner.clean(new URL(url))

    val elements = rootNode.getElementsByName("a", true)
    elements map { elem =>
      val url = elem.getAttributeByName("href")
      println(url.toString)
    }
  }
}

object App {
  def main(args: Array[String]): Unit = {
    // val level = if (args.length > 0) args(0).toInt else WebCrawler.defaultLevel
    // WebCrawler.crawl(level)
    if (args.length > 0) {
      WebCrawler.crawl(args(0).toInt)
    } else {
      WebCrawler.crawl()
    }
  }
}
