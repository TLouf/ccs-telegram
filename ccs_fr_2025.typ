#import "pretty-metro.typ": *
// #import "@preview/theorion:0.3.3": *
// #import cosmos.fancy: *
// #show: show-theorion

#set strong(delta: 100)
// #set par(justify: true)
#show: metropolis-styling

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: none,
  header-right: none,
  align: top,
  config-methods(cover: utils.semi-transparent-cover.with(alpha: 85%)),
  config-common(new-section-slide-fn: none),
  config-info(
    title: [Uncovering the structure and dynamics of information flow on the Telegram network],
    // subtitle: [Subtitle],
    author: [#underline[Thomas Louf], Aurora Vindimian, Riccardo Gallotti],
    // date: datetime.today().display("[month repr:long] [day padding:none], [year]"),
    date: datetime(year: 2025, month: 6, day: 25).display("[month repr:long] [day padding:none], [year]"),
    // institution: {image("figs/FBK_logo.svg", height: 25%)},
    logo: {
      box(image("figs/logo_unitn_maths.png", height: 15%))
      box(image("figs/FBK_logo.svg", height: 25%), inset: (x: 24pt))
    },
  ),
  config-colors(
    // primary: rgb("#BE95C4"),
    // secondary: rgb("#231942"),
    // tertiary: rgb("#9F86C0"),

    // primary: rgb("#F20089"),
    // secondary: rgb("#B7094C"),
    // tertiary: rgb("#455E89"),

    // primary: rgb("#118ab2"),
    // secondary: rgb("#ef476f"),
    // tertiary: rgb("#ffd166"),

    // primary: rgb("#FF892F"),
    // tertiary: rgb("#FF1361"),
    // secondary: rgb("#231557"),

    // secondary: rgb("#2a1e5c"),
    // tertiary: rgb("#3cbbb1"),
    // primary: rgb("#ee4266"),

    // primary: rgb("#ff99c8"),
    // secondary: rgb("#cdb4db"),
    // tertiary: rgb("#a2d2ff"),

    // text-on-palette-bg: black.lighten(20%),
  ),
)


#title-slide()

= Introduction

== Context


HAHA

$ a = n / 2 $

// ---

// new slide



= Structural analysis

== Network creation

#image("figs/strucure.png", height: 70%)


== Assortativity

#slide(setting: align.with(center + horizon))[

  #image("figs/lang_assort.png", width: 90%)

][
  a
  #image("figs/communities_3_group_top_11_u.png", width: 90%)
]



= Temporal analysis

== Inter-event times

#image("figs/event_sequence_ex.png", width: 60%)

#figure(image("figs/tau_distrib_3fits.svg"))

== Burstiness

#figure(image("figs/trainsss.svg", height: 20%))
#image("figs/burst_train_log_binn.png")


== Memory

#figure(image("figs/memo_func.png", height: 80%))


== Tie allocation

#slide[
  Aversion to form too many ties \
  #fa-arrow-right() probability to form new ties should decrease with in-degree $k_("in")$.

  Model from @UbaldiAsymptoticTheory2016
  $p_("new")(k_("in"))= (1 + k_("in") / c)^(-b)$
][
  // TODO: add correct reinforcement plot
  #figure(image("figs/reinforcement.svg", height: 80%))
]



= Modelling

Simple-enough mmodel that can reproduce these properties?

#implies() can simulate contagion model or equivalent and test effect of interventions on synthetic networks

Existing model to reproduce clustering, strength distribution, assortativity and burstiness? #emph()[#text(fill: primary)[No!]]


== Time

#only("1")[#figure(image("figs/time_model.svg"))]

#only("2")[#figure(image("figs/time_model_regimes_focus.svg"))]

#only("3")[#figure(image("figs/tau_distrib_3fits.svg"))]

#only("4-")[#figure(image("figs/time_model.svg"))]




== Topology

#figure(image("figs/top_model.svg"))




= Final remarks

#empty-slide[
  #v(1fr)
  #titled-box("What we've shown...", color: secondary, align: center)[
    // What we've shown...
    - Network of Telegram channels is very social-network-like
    - Main mechanisms behind its emergence: tie reinforcement, clustering, language assortativity + memory process
  ]

  #v(1fr)

  #titled-box("...and what this leads to", color: tertiary, align: center)[
    // What this leads to...
    - Model information propagation and effect of interventions
    - Very global view of temporal process: what about local coordination?
  ]

  #v(1fr)
]

== hmmmm

#focus-slide()[
  #v(1fr)

  #text(1.5em)[Thanks for your attention 🤗]

  #v(1fr)

  #fa-bluesky() #link("https://bsky.app/profile/tlouf.bsky.social")[\@TLouf] \
  #fa-github() #link("https://github.com/TLouf")[\@TLouf] \
  #fa-icon("envelope", solid: true) #link("mailto:tlouf\@fbk.eu")[tlouf\@fbk.eu] \
]


#bibliography("tg-net.bib", style: "apa")


// #slide(config: config-page(header: none, footer: none))[
//   hahaadsada
// ]


// #slide(title: [merrrde])[

//   mais non

//   #pause
// // #let original = read("figs/FBK_logo.svg")
// // #image.decode(original.replace("fill-opacity=\"1\"", "fill-opacity=\"0.5\""))

//   #image("figs/FBK_logo.jpg", height: 5em)

//   #pause

//   use #uncover("2-")[`#uncover` function] for reserving space,

//   hehaaaaadse #alert(implies()) #implies() hehe

//   #pause

//   hooooo
// ]


// // If want to access theme color inside a slide:
// #slide(self => [
//   #text(fill: self.colors.primary)[adsada]
// ])
