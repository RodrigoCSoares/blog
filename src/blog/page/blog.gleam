import blog/data/post.{type Post}
import blog/layout
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view(posts: List(Post)) -> Element(a) {
  layout.base(
    "Posts",
    html.div([], [
      html.h1([], [element.text("Posts")]),
      html.ul(
        [attribute.class("post-list")],
        list.map(posts, fn(p) {
          html.li([], [
            html.a([attribute.href("/blog/" <> p.id)], [
              html.article([attribute.class("post-card")], [
                html.h2([], [element.text(p.title)]),
                html.time([attribute.attribute("datetime", p.date)], [
                  element.text(p.date),
                ]),
                html.p([], [element.text(p.summary)]),
              ]),
            ]),
          ])
        }),
      ),
    ]),
  )
}
