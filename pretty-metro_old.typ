#import "@preview/polylux:0.3.1": *
#import "@preview/fontawesome:0.1.0": *

// This theme is inspired by https://github.com/matze/mtheme

#let polylux-slide(body) = {
  locate( loc => {
    if logical-slide.at(loc).first() > 0 {
      pagebreak(weak: false) // CHANGED
    }
  })
  logical-slide.step()
  subslide.update(1)
  repetitions.update(1)
  pause-counter.update(0)

  show par: paused-content
  show math.equation: paused-content
  show box: paused-content
  show block: paused-content
  show path: paused-content
  show rect: paused-content
  show square: paused-content
  show circle: paused-content
  show ellipse: paused-content
  show line: paused-content
  show polygon: paused-content
  show image: paused-content

  // Having this here is a bit unfortunate concerning separation of concerns
  // but I'm not comfortable with logic depending on pdfpc...
  let pdfpc-slide-markers(curr-subslide) = locate( loc => [
    #metadata((t: "NewSlide")) <pdfpc>
    #metadata((t: "Idx", v: counter(page).at(loc).first() - 1)) <pdfpc>
    #metadata((t: "Overlay", v: curr-subslide - 1)) <pdfpc>
    #metadata((t: "LogicalSlide", v: logical-slide.at(loc).first())) <pdfpc>
  ])

  pdfpc-slide-markers(1)

  body

  subslide.step()
  set heading(outlined: false)

  locate( loc => {
    let reps = repetitions.at(loc).first()
    for curr-subslide in range(2, reps + 1) {
      pause-counter.update(0)
      pagebreak(weak: true)

      pdfpc-slide-markers(curr-subslide)

      body
      subslide.step()
    }
  })
}

#let mcolor-primary = state("mcolor-primary", rgb("#23373b"))
#let mcolor-secondary = state("mcolor-secondary", rgb("#d15306"))
#let mcolor-tertiary = state("mcolor-tertiary", rgb("#35837b"))
#let mcolor-light-grey = black.lighten(60%)
#let m-footer = state("m-footer", [])

#let m-cell = block.with(
  width: 100%,
  height: 100%,
  above: 0pt,
  below: 0pt,
  breakable: false
)

#let alert(body) = locate( loc => {
  set text(fill: mcolor-secondary.at(loc))
  body
})

#let mute(body) = locate( loc => {
  set text(fill: mcolor-primary.at(loc).lighten(60%))
  body
})

#let current-heading(level: 1) = locate(loc => {
  let h = query(heading.where(level: level).before(loc), loc).last()
  link(h.location(), h.body)
})

#let m-progress-bar = locate( loc => {
  let bar-color = mcolor-secondary.at(loc)
  utils.polylux-progress( ratio => {
    grid(
      columns: (ratio * 100%, 1fr),
      m-cell(fill: bar-color),
      m-cell(fill: bar-color.desaturate(80%))
    )
  })
})

#let metropolis-theme(
  aspect-ratio: "16-9",
  footer: [],
  primary: rgb("#23373b"),
  secondary: rgb("#d15306"),
  tertiary: rgb("#35837b"),
  body
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    fill: white,
    margin: 0em,
    header: none,
    footer: none,
  )
  set text(fill: primary)

  mcolor-primary.update(primary)
  mcolor-secondary.update(secondary)
  mcolor-tertiary.update(tertiary)
  m-footer.update(footer)

  body
}

#let title-slide(
  title: [],
  subtitle: none,
  author: none,
  date: none,
  extra: none,
  body
) = {
  let content = locate( loc => {
    let line-color = mcolor-secondary.at(loc)
    set align(horizon)
    block(width: 100%, inset: 2em, {
      text(size: 1.3em, strong(title))
      if subtitle != none {
        linebreak()
        text(size: 0.9em, subtitle)
      }
      line(length: 100%, stroke: .05em + line-color)
      set text(size: .8em)
      if author != none {
        block(spacing: 1em, author)
      }
      if date != none {
        block(spacing: 1em, date)
      }
      set text(size: .8em)
      if extra != none {
        block(spacing: 1em, extra)
      }

    })
  })

  logic.polylux-slide(content + body)
}

#let print_heading(t) = {
  if type(t) == int {
    current-heading(level: t)
  // } else if type(t) == content and t.has("body") {
  //   t.body
  }
  else {t}
}

#let slide(title: none, body) = {
  let header = locate( loc => {
    let secondary = mcolor-secondary.at(loc)
    let primary = mcolor-primary.at(loc)
    let tertiary = mcolor-tertiary.at(loc)
    let header-gradient = gradient.linear(primary, tertiary)
    show heading: it => {text(size: 26pt, weight: "regular", it.body)}
    set align(top)
    if title != none {
      let title_array = if type(title) != array {(title,)} else {title}
      grid(
        rows: (3em, 2pt),
        row-gutter: 0pt,
        rect(
          fill: header-gradient, width: 100%, height: 100%, inset: (x: 2em),
          {
            set align(horizon)
            set text(fill: white, weight: "regular", size: 26pt)
            if title_array.len() > 1 {
              for t in title_array.slice(0, -1) {
                text(fill: white.darken(30%), print_heading(t))
                h(.5em)
                fa-angle-right(size: 0.8em, fill: secondary)
                h(.5em)
              }
            }
            print_heading(title_array.at(-1))
            h(.5em)
            fa-angle-down(size: 0.8em, fill: secondary)
          }
        ),
        block(height: 100%, width: 100%, spacing: 0pt, m-progress-bar),
      )
    } else { [] }
  })

  let footer = {
    set text(size: 0.8em)
    show: pad.with(.5em)
    set align(bottom)
    m-footer.display()
    h(1fr)
    logic.logical-slide.display()
  }

  set page(
    header: header,
    footer: footer,
    margin: (top: 3em, bottom: 1em),
    fill: white,
  )

  let content = {
    show: align.with(horizon)
    show: pad.with(2em)
    body
  }

  logic.polylux-slide(content)
}

#let metropolis-outline(list-args: (marker: []), padding: 40pt) = locate( loc => {
  let sections = query(heading.where(level: 1), loc)
  let sections-until-now = query(heading.where(level: 1).before(loc), loc)
  let current-section = if sections-until-now.len() > 0 {
    sections-until-now.last()
  } else {
    heading("")
  }
  let section-idx = sections.position(sec => sec == current-section)
  let subsections-of-current-section = if sections-until-now.len() > 0 {
    query(
      if section-idx != none and section-idx + 1 < sections.len() {
        heading.where(level: 2).after(loc).before(sections.at(section-idx + 1).location())
      } else {
        heading.where(level: 2).after(loc)
      },
      loc,
    )
  } else {
    []
  }

  pad(
    padding,
    list(
      ..list-args,
      ..sections.map(
        section => if section == current-section {
          link(section.location(), section.body)
          list(
            ..(
              for s in subsections-of-current-section {
                (link(s.location(), s.body),)
              }
            ),
            indent: 1em,
            ..list-args,
          )
        } else {
          link(section.location(), mute[#section.body])
        }
      )
    )
  )
})

#let outline-slide() = {
  slide()[
    #metropolis-outline()
  ]
}

#let new-section-slide(name) = {
  let content = {
    utils.register-section(name)
    set align(horizon)
    show: pad.with(20%)
    set text(size: 1.5em)
    name
    block(height: 2pt, width: 100%, spacing: 0pt, m-progress-bar)
  }
  logic.polylux-slide(content)
}

#let focus-slide(body) = {
  let bg = locate(loc => {
    let primary = mcolor-primary.at(loc)
    let tertiary = mcolor-tertiary.at(loc)
    rect(fill: gradient.linear(primary, tertiary), height: 100%, width: 100%)
  })
  set page(background: bg, margin: 2em)
  set text(fill: white, size: 1.5em)
  logic.polylux-slide(align(horizon + center, body))
}
