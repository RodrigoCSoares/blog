import blog/data/post.{type Post, Post}
import gleam/dict
import gleam/list
import gleam/result
import gleam/string
import simplifile

const posts_dir = "./posts"

pub fn all() -> List(Post) {
  let assert Ok(files) = simplifile.read_directory(posts_dir)

  files
  |> list.filter(fn(f) { string.ends_with(f, ".md") })
  |> list.filter_map(fn(f) { parse_file(posts_dir <> "/" <> f) })
  |> list.sort(fn(a, b) { string.compare(b.date, a.date) })
}

fn parse_file(path: String) -> Result(Post, Nil) {
  use content <- result.try(simplifile.read(path) |> result.replace_error(Nil))
  use #(frontmatter, body) <- result.try(split_frontmatter(content))
  let meta = parse_frontmatter(frontmatter)

  use id <- result.try(dict.get(meta, "id"))
  use title <- result.try(dict.get(meta, "title"))
  use date <- result.try(dict.get(meta, "date"))
  use summary <- result.try(dict.get(meta, "summary"))

  Ok(Post(
    id: id,
    title: title,
    date: date,
    summary: summary,
    body: string.trim(body),
  ))
}

fn split_frontmatter(content: String) -> Result(#(String, String), Nil) {
  let trimmed = string.trim(content)
  use rest <- result.try(string.split_once(trimmed, "---\n"))
  case rest {
    #("", after_first) -> {
      case string.split_once(after_first, "\n---") {
        Ok(#(frontmatter, body)) -> Ok(#(frontmatter, body))
        Error(_) -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

fn parse_frontmatter(raw: String) -> dict.Dict(String, String) {
  raw
  |> string.split("\n")
  |> list.filter_map(fn(line) {
    case string.split_once(line, ":") {
      Ok(#(key, value)) -> Ok(#(string.trim(key), string.trim(value)))
      Error(_) -> Error(Nil)
    }
  })
  |> dict.from_list()
}
