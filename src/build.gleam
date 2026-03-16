import blog/data/post.{type Post}
import blog/data/posts
import blog/page/blog
import blog/page/index
import blog/page/post as post_page
import gleam/dict
import gleam/io
import gleam/list
import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/ssg
import lustre/ssg/atom

const base_url = "https://rodrigocsoares.com"

pub fn main() {
  let posts = posts.all()
  let posts_dict =
    list.map(posts, fn(p) { #(p.id, p) })
    |> dict.from_list()

  let build =
    ssg.new("./dist")
    |> ssg.add_static_dir("./static")
    |> ssg.use_index_routes()
    |> ssg.add_static_route("/", index.view(posts))
    |> ssg.add_static_route("/blog", blog.view(posts))
    |> ssg.add_dynamic_route("/blog", posts_dict, post_page.view)
    |> ssg.add_static_xml("/feed", build_feed(posts))
    |> ssg.build

  case build {
    Ok(_) -> io.println("Build succeeded!")
    Error(e) -> {
      io.println("Build failed!")
      echo e
      Nil
    }
  }
}

fn build_feed(posts: List(Post)) -> Element(a) {
  let latest_date = case posts {
    [first, ..] -> first.date <> "T00:00:00Z"
    [] -> ""
  }

  atom.feed([], [
    atom.title([], "Rodrigo C. Soares"),
    atom.subtitle(
      [],
      "A blog about software, architecture, and things I find interesting.",
    ),
    atom.link([
      attribute("href", base_url <> "/feed.xml"),
      attribute("rel", "self"),
      attribute("type", "application/atom+xml"),
    ]),
    atom.link([
      attribute("href", base_url),
      attribute("rel", "alternate"),
      attribute("type", "text/html"),
    ]),
    atom.id([], base_url <> "/"),
    atom.updated([], latest_date),
    atom.author([], [
      atom.name([], "Rodrigo C. Soares"),
      atom.uri([], base_url),
    ]),
    ..list.map(posts, fn(p) {
      atom.entry([], [
        atom.title([], p.title),
        atom.link([
          attribute("href", base_url <> "/blog/" <> p.id),
          attribute("rel", "alternate"),
        ]),
        atom.id([], base_url <> "/blog/" <> p.id),
        atom.published([], p.date <> "T00:00:00Z"),
        atom.updated([], p.date <> "T00:00:00Z"),
        atom.summary([], p.summary),
      ])
    })
  ])
}
