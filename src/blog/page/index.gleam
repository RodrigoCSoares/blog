import blog/data/post.{type Post}
import blog/layout
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn view(posts: List(Post)) -> Element(a) {
  let recent_posts = list.take(posts, 3)

  layout.base(
    "Home",
    html.div([], [
      // About section
      html.section([attribute.class("about")], [
        html.h1([], [element.text("Hey, I'm Rodrigo")]),
        html.p([attribute.class("about-intro")], [
          element.text(
            "Software Engineer based in the Netherlands. I'm passionate about how software and technology can change the world and improve people's lives. Currently working as a Sr. Software Engineer at ",
          ),
          html.a(
            [
              attribute.href("https://www.justeattakeaway.com/"),
              attribute.target("_blank"),
            ],
            [element.text("Just Eat Takeaway.com")],
          ),
          element.text(", building and architecting systems at scale."),
        ]),
        html.p([attribute.class("about-details")], [
          element.text(
            "I hold a BSc in Software Engineering and an MSc in Computer Science from the University of Sao Paulo. My interests span software architecture, cloud development, data engineering, and distributed systems. I've worked across startups and multinationals, and I enjoy writing about the things I learn along the way.",
          ),
        ]),
        html.div([attribute.class("about-links")], [
          html.a(
            [
              attribute.href("https://github.com/rodrigocsoares"),
              attribute.target("_blank"),
              attribute.class("about-link"),
            ],
            [element.text("GitHub")],
          ),
          html.a(
            [
              attribute.href("https://www.linkedin.com/in/soarescrodrigo"),
              attribute.target("_blank"),
              attribute.class("about-link"),
            ],
            [element.text("LinkedIn")],
          ),
        ]),
      ]),
      // Latest posts section
      html.section([attribute.class("latest-posts")], [
        html.div([attribute.class("section-header")], [
          html.h2([], [element.text("Latest posts")]),
          html.a([attribute.href("/blog"), attribute.class("see-all")], [
            element.text("See all"),
          ]),
        ]),
        html.ul(
          [attribute.class("post-list")],
          list.map(recent_posts, fn(p) {
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
    ]),
  )
}
