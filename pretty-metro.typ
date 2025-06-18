// This theme is inspired by https://github.com/matze/mtheme
// The origin code was written by https://github.com/Enivex
#import "@preview/touying:0.6.1": *
#import "@preview/showybox:2.0.4": showybox
#import "@preview/fontawesome:0.5.0": *

#let _typst-builtin-align = align

#let implies() = box(rotate(fa-reply(solid: true), 180deg))


#let display-headings-up-to(self, level: 1, color: auto) = context {
  let text_color = color
  if color == auto {
    text_color = self.colors.text-on-palette-bg
  }
  let heading = utils.current-heading(depth: self.slide-level)
  let max_level = level
  if heading != none {
    max_level = calc.min(heading.level, level)
  }
  for lvl in range(1, max_level) {
    utils.display-current-heading(
      depth: self.slide-level,
      level: lvl,
      style: current-heading => text(text_color.rgb().transparentize(40%), current-heading.body),
    )
    h(.3em)
    fa-angle-right(size: 0.8em, fill: self.colors.primary)
    h(.3em)
  }
  utils.display-current-heading(
    depth: self.slide-level,
    level: max_level,
    style: current-heading => text(fill: text_color, current-heading.body),
  )
  h(.3em)
  fa-angle-down(size: 0.8em, fill: self.colors.primary)
}


/// Default slide function for the presentation.
///
/// - title (string): The title of the slide. Default is `auto`.
///
/// - config (dictionary): The configuration of the slide. You can use `config-xxx` to set the configuration of the slide. For several configurations, you can use `utils.merge-dicts` to merge them.
///
/// - repeat (int, string): The number of subslides. Default is `auto`, which means touying will automatically calculate the number of subslides.
///
///   The `repeat` argument is necessary when you use `#slide(repeat: 3, self => [ .. ])` style code to create a slide. The callback-style `uncover` and `only` cannot be detected by touying automatically.
///
/// - setting (function): The setting of the slide. You can use it to add some set/show rules for the slide.
///
/// - composer (function, array): The composer of the slide. You can use it to set the layout of the slide.
///
///   For example, `#slide(composer: (1fr, 2fr, 1fr))[A][B][C]` to split the slide into three parts. The first and the last parts will take 1/4 of the slide, and the second part will take 1/2 of the slide.
///
///   If you pass a non-function value like `(1fr, 2fr, 1fr)`, it will be assumed to be the first argument of the `components.side-by-side` function.
///
///   The `components.side-by-side` function is a simple wrapper of the `grid` function. It means you can use the `grid.cell(colspan: 2, ..)` to make the cell take 2 columns.
///
///   For example, `#slide(composer: 2)[A][B][#grid.cell(colspan: 2)[Footer]]` will make the `Footer` cell take 2 columns.
///
///   If you want to customize the composer, you can pass a function to the `composer` argument. The function should receive the contents of the slide and return the content of the slide, like `#slide(composer: grid.with(columns: 2))[A][B]`.
///
/// - bodies (array): The contents of the slide. You can call the `slide` function with syntax like `#slide[A][B][C]` to create a slide.
#let slide(
  title: auto,
  align: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  if align != auto {
    self.store.align = align
  }
  // restore typst builtin align function
  let align = _typst-builtin-align
  let has_header = (
    config.at("page", default: (:)).at("header", default: "a") != none and title != none
  )
  let header(self) = if has_header {
    set align(horizon)
    set text(fill: self.colors.text-on-palette-bg, weight: "medium", size: 1.2em)
    grid(
      rows: (2.5em, 2pt),
      row-gutter: 0pt,
      rect(
        fill: gradient.linear(self.colors.secondary, self.colors.tertiary),
        width: 100%,
        height: 100%,
        inset: (x: 1em),
        {
          if title != auto {
            [#title #h(.3em) #fa-angle-down(size: 0.8em, fill: self.colors.primary)]
          } else {
            utils.call-or-display(self, self.store.header)
          }
        },
      ),
      block(
        height: 100%,
        width: 100%,
        spacing: 0pt,
        components.progress-bar(height: 2pt, self.colors.primary, self.colors.primary-light),
      )
    )
  } else { none }
  let footer(self) = {
    set align(bottom)
    set text(size: 0.8em)
    pad(
      .5em,
      components.left-and-right(
        text(fill: self.colors.text-on-default-bg.lighten(40%), utils.call-or-display(self, self.store.footer)),
        text(fill: self.colors.text-on-default-bg, utils.call-or-display(self, self.store.footer-right)),
      ),
    )
    if self.store.footer-progress {
      place(bottom, components.progress-bar(height: 2pt, self.colors.primary, self.colors.primary-light))
    }
  }
  let self = utils.merge-dicts(
    self,
    config-page(
      fill: self.colors.default-bg,
      header: header,
      footer: footer,
    ),
  )
  let new-setting = body => {
    show: align.with(self.store.align)
    set text(fill: self.colors.text-on-default-bg)
    show: setting
    if has_header { v(2.5em) }
    body
  }
  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, ..bodies)
})


#let empty-slide(
  title: none,
  align: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = {
  slide(
    title: title,
    align: align,
    config: utils.merge-dicts(config-page(footer: none), config),
    repeat: repeat,
    setting: setting,
    composer: composer,
    ..bodies,
  )
}


#let current-outline-slide(
  title: none,
  align: horizon,
  level: 1,
) = {
  empty-slide(align: align, title: title)[
    #components.progressive-outline(indent: 1em, level: 1, title: none)
  ]
}

/// Title slide for the presentation. You should update the information in the `config-info` function. You can also pass the information directly to the `title-slide` function.
///
/// Example:
///
/// ```typst
/// #show: metropolis-theme.with(
///   config-info(
///     title: [Title],
///     logo: emoji.city,
///   ),
/// )
///
/// #title-slide(subtitle: [Subtitle], extra: [Extra information])
/// ```
///
/// - extra (string, none): The extra information you want to display on the title slide.
#let title-slide(
  extra: none,
  ..args,
) = touying-slide-wrapper(self => {
  let info = self.info + args.named()
  let body = {
    set text(fill: self.colors.text-on-default-bg)
    set align(horizon)
    block(
      width: 100%,
      inset: 2em,
      {
        text(size: 1.3em, text(weight: "medium", info.title))
        if info.subtitle != none {
          linebreak()
          text(size: 0.9em, info.subtitle)
        }
        line(length: 100%, stroke: (thickness: .2em, paint: self.colors.primary, cap: "round"))
        set text(size: .8em)
        if info.author != none {
          block(spacing: 1em, info.author)
        }
        if info.date != none {
          block(spacing: 1em, utils.display-info-date(self))
        }
        set text(size: .8em)
        if info.institution != none {
          block(spacing: 1em, info.institution)
        }
        if info.logo != none {
          place(bottom + right, dy: 100% - 4em, text(2em, utils.call-or-display(self, info.logo)))
        }
        if extra != none {
          block(spacing: 1em, extra)
        }
      },
    )
  }
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: self.colors.default-bg),
  )
  touying-slide(self: self, body)
})


/// New section slide for the presentation. You can update it by updating the `new-section-slide-fn` argument for `config-common` function.
///
/// Example: `config-common(new-section-slide-fn: new-section-slide.with(numbered: false))`
///
/// - level (int): The level of the heading.
///
/// - numbered (boolean): Indicates whether the heading is numbered.
///
/// - body (auto): The body of the section. It will be passed by touying automatically.
#let new-section-slide(level: 1, numbered: true, body) = touying-slide-wrapper(self => {
  let slide-body = {
    set align(horizon)
    show: pad.with(20%)
    set text(size: 1.5em)
    stack(
      dir: ttb,
      spacing: 1em,
      utils.display-current-heading(level: level, numbered: numbered),
      block(
        height: 2pt,
        width: 100%,
        spacing: 0pt,
        components.progress-bar(height: 2pt, self.colors.primary, self.colors.primary-light),
      ),
    )
    body
  }
  self = utils.merge-dicts(
    self,
    config-page(fill: self.colors.default-bg),
  )
  touying-slide(self: self, slide-body)
})


/// Focus on some content.
///
/// Example: `#focus-slide[Wake up!]`
///
/// - align (alignment): The alignment of the content. Default is `horizon + center`.
#let focus-slide(align: horizon + center, body) = touying-slide-wrapper(self => {
  let _align = align
  let align = _typst-builtin-align
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config-page(fill: gradient.linear(self.colors.secondary, self.colors.tertiary), margin: 2em),
  )
  set text(fill: self.colors.text-on-palette-bg, size: 1.5em)
  touying-slide(self: self, align(_align, body))
})


#let primary = rgb("#e76f51")
#let secondary = rgb("#23373b")
#let tertiary = rgb("#35837b")
/// Touying metropolis theme.
///
/// Example:
///
/// ```typst
/// #show: metropolis-theme.with(aspect-ratio: "16-9", config-colors(primary: blue))`
/// ```
///
/// Consider using:
///
/// ```typst
/// #set text(font: "Fira Sans", weight: "light", size: 20pt)`
/// #show math.equation: set text(font: "Fira Math")
/// #set strong(delta: 100)
/// #set par(justify: true)
/// ```
///
/// The default colors:
///
/// ```typ
/// config-colors(
///   primary: rgb("#eb811b"),
///   primary-light: rgb("#d6c6b7"),
///   secondary: rgb("#23373b"),
///   neutral-lightest: rgb("#fafafa"),
///   neutral-dark: rgb("#23373b"),
///   neutral-darkest: rgb("#23373b"),
/// )
/// ```
///
/// - aspect-ratio (string): The aspect ratio of the slides. Default is `16-9`.
///
/// - align (alignment): The alignment of the content. Default is `horizon`.
///
/// - header (content, function): The header of the slide. Default is `self => utils.display-current-heading(setting: utils.fit-to-width.with(grow: false, 100%), depth: self.slide-level)`.
///
/// - header-right (content, function): The right part of the header. Default is `self => self.info.logo`.
///
/// - footer (content, function): The footer of the slide. Default is `none`.
///
/// - footer-right (content, function): The right part of the footer. Default is `context utils.slide-counter.display() + " / " + utils.last-slide-number`.
///
/// - footer-progress (boolean): Whether to show the progress bar in the footer. Default is `true`.

#let metropolis-theme(
  aspect-ratio: "16-9",
  align: horizon,
  header: self => display-headings-up-to(self, level: 2),
  header-right: self => self.info.logo,
  footer: none,
  footer-right: context utils.slide-counter.display(),
  footer-progress: false,
  ..args,
  body,
) = {
  set text(size: 20pt)

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      header-ascent: 30%,
      footer-descent: 30%,
      margin: (y: 2em, x: 2em),
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: primary,
      primary-light: rgb("#d6c6b7"),
      secondary: secondary,
      tertiary: tertiary,
      default-bg: rgb("#ffffff"),
      text-on-default-bg: rgb("#23373b"),
      text-on-palette-bg: rgb("#fafafa"),
    ),
    // save the variables for later use
    config-store(
      align: align,
      header: header,
      header-right: header-right,
      footer: footer,
      footer-right: footer-right,
      footer-progress: footer-progress,
    ),
    ..args,
  )

  body
}


#let metropolis-styling(it) = {
  set text(font: "Fira Sans", weight: "regular", size: 20pt)
  show heading.where(level: 1): it => { }
  show outline.entry: it => it.element.body
  it
}

#let titled-box(title, color: secondary, align: left, ..args, body) = {
  showybox(
    title-style: (
      weight: 600,
      color: white,
      sep-thickness: 0pt,
      align: align,
    ),
    frame: (
      body-color: color.lighten(90%),
      title-color: color,
      thickness: 0pt,
      radius: 0pt
    ),
    title: title,
  )[#body]
}
