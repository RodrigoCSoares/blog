import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn base(title: String, content: Element(a)) -> Element(a) {
  html.html([attribute.attribute("lang", "en")], [
    html.head([], [
      html.meta([attribute.attribute("charset", "UTF-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.attribute("content", "width=device-width, initial-scale=1.0"),
      ]),
      html.title([], title <> " | Blog"),
      html.link([
        attribute.rel("icon"),
        attribute.type_("image/svg+xml"),
        attribute.href("/favicon.svg"),
      ]),
      html.link([
        attribute.rel("stylesheet"),
        attribute.href("/css/style.css"),
      ]),
      html.link([
        attribute.rel("alternate"),
        attribute.type_("application/atom+xml"),
        attribute.attribute("title", "Rodrigo C. Soares"),
        attribute.href("/feed.xml"),
      ]),
    ]),
    html.body([], [
      html.nav([attribute.class("nav")], [
        html.a([attribute.href("/"), attribute.class("nav-brand")], [
          element.text("Blog"),
        ]),
        html.div([attribute.class("nav-links")], [
          html.a([attribute.href("/")], [element.text("Home")]),
          html.a([attribute.href("/blog")], [element.text("Posts")]),
          html.a([attribute.href("/feed.xml")], [element.text("Feed")]),
        ]),
      ]),
      html.main([attribute.class("container")], [content]),
      html.footer([attribute.class("footer")], [
        html.p([], [
          element.text("Built with "),
          html.a(
            [
              attribute.href("https://gleam.run"),
              attribute.target("_blank"),
            ],
            [element.text("Gleam")],
          ),
          element.text(" & "),
          html.a(
            [
              attribute.href("https://github.com/lustre-labs/ssg"),
              attribute.target("_blank"),
            ],
            [element.text("Lustre SSG")],
          ),
        ]),
      ]),
    ]),
  ])
}
