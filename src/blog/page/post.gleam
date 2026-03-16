import blog/data/post.{type Post}
import blog/layout
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import mork
import mork/to_lustre

pub fn view(p: Post) -> Element(a) {
  let body_elements = p.body |> mork.parse |> to_lustre.to_lustre
  layout.base(
    p.title,
    html.article([attribute.class("post")], [
      html.header([], [
        html.h1([], [element.text(p.title)]),
        html.time([attribute.attribute("datetime", p.date)], [
          element.text(p.date),
        ]),
      ]),
      html.div([attribute.class("post-body")], body_elements),
      html.a([attribute.href("/blog"), attribute.class("back-link")], [
        element.text("Back to posts"),
      ]),
    ]),
  )
}
