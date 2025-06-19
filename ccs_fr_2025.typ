#import "pretty-metro.typ": *
#import "@preview/zero:0.3.3": *

#set strong(delta: 100)
// #set par(justify: true)
#show: metropolis-styling

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: none,
  header-right: none,
  align: top,
  // config-methods(cover: (self: none, body) => box(scale(x: 0%, body))),
  // config-methods(cover: utils.semi-transparent-cover.with(alpha: 85%)),
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
)


#title-slide()

= Introduction

== Context

Telegram is...

- Not just a messaging app, it hosts *millions of public channels*, some gathering tens / hundreds of thousands of users

#pause

- An online social media = large-scale, privately-owned "public" spheres #fa-arrow-right() hard to limit *spread of misinformation, hate speech* and other goodies

#pause

- Increasingly *popular*, and already very popular in some countries (Russia, Iran)

so...

#pause

#figure(
  grid(
    columns: 5,
    rows: 1,
    gutter: 16pt,
    grid.cell(
      colspan: 2,
      image("figs/Telegram_logo.svg", height: 23%),
    ),
    grid.cell(colspan: 1, align: horizon, text(size: 48pt)[$eq.quest$]),
    grid.cell(
      colspan: 2,
      image("figs/Logo_of_Twitter.svg", height: 23%),
    )
  ),
)
// #pause
// - Is _largely unregulated_
// #pause
// - ... and also _under-studied_ scientifically

---

Not exactly!

- Its structure is based on channels \
#pause
// #fa-arrow-right()
#h(1em) #implies() information is more containerised \
#pause
#h(1em) #implies() not easy to _search_ for content

#pause

#grid(
  columns: (1fr, 1fr),
  [- Largely *unregulated*], only("4")[#image("figs/durov_arrest.jpg", height: 40%)],
)
// - Largely *unregulated*

// #only("4")[#image("figs/durov_arrest.jpg", height: 40%)]

#pause

- ... and also *under-studied* scientifically

#pause

#v(1fr)
#text(size: 36pt)[#fa-arrow-right() Lots of work to be done]
#v(1fr)


== Scope

#v(1fr)
#text(fa-users-rectangle(), size: 32pt, baseline: 6pt) Is the network of Telegram channels anything like a social network?

#text(fa-cogs(), size: 32pt, baseline: 6pt) What are the main mechanisms giving rise to it?

#v(1fr)
#fa-arrow-right() Analysis of the Telegram network using the Pushshift dataset @BaumgartnerPushshiftTelegram2020

#fa-arrow-right() Model that reproduces its _topological_ and _temporal_ features

#v(1fr)

= Structural analysis

== A network of information flow

- Nodes: #num(29609) channels
- Edge from B to A when A forwards a message from B #fa-arrow-right() #num(501897) directed edges


#figure(image("figs/strucure.png", height: 60%))


== Assortativity

#slide(setting: align.with(center + horizon))[

  Ties formed preferably with same language...
  #v(1fr)
  #image("figs/lang_assort.png", width: 85%)

][
  ...also reflected in community partition (SBM)
  #v(1fr)
  #image("figs/communities_3_group_top_11_u_cropped.png", width: 100%)
  #v(1fr)
]

== Tie allocation

#slide(setting: align.with(horizon))[
  #v(1fr)
  Aversion to form too many ties \
  #fa-arrow-right() probability to form new ties should decrease with in-degree $k_("in")$.
  #v(1fr)
  Model from @UbaldiAsymptoticTheory2016
  $ p_("new")(k_("in"))= (1 + k_("in") / c)^(-b) $
  #v(1fr)
][
  #figure(image("figs/reinforcement.svg", height: 80%))
]



= Temporal analysis

== Inter-event times

#grid(
  columns: (1fr, 2fr),
  rows: (1fr, 2fr),
  align: horizon,
  [For all channels, get times between two forwarded messages = _inter-event times_ $tau$],
  figure(image("figs/event_sequence_ex.png", width: 90%)),
// )

// #grid(
  // columns: (1fr, 1.5fr),
  [#implies() $f(tau)$ is piecewise power-law, with two main regimes separated by $tau=1 "day"$],
  figure(image("figs/tau_distrib_3fits.svg", height: 90%)),
)


== Burstiness

Investigate shape of distribution of _burst train sizes_ $E$ @KarsaiUniversalFeatures2012:

#figure(image("figs/trainsss.svg", height: 20%))


#grid(
  columns: (1fr, 1.5fr),
  grid.cell(
    align: horizon,
    [
      We do have

      $ p(E) ~ E^(-beta) $

      #implies() forwarding is bursty

    ],
  ),
  image("figs/burst_train_log_binn.png", height: 51%),
)





= Modelling

Simple-enough model that can reproduce these properties?

#implies() can simulate contagion model or equivalent and test effect of interventions on synthetic networks

Existing model to reproduce clustering, strength distribution, assortativity and burstiness? #emph()[#text(fill: primary)[No!]]


== Time

// == Memory
#grid(
  columns: (1fr, 4fr),
  align: horizon,
  [
    With already $n$ events in a burst train, probability $p(n)$ to generate another within the same train?
  ],
  figure(image("figs/memo_func_cropped.png", height: 55%)),
)


#fa-arrow-right() Train size distribution generated from memory process @KarsaiUniversalFeatures2012

$ p(E) ~ E^(-beta) <=> p(n) = ( n / (n+1) )^nu #h(2em) "with" nu approx beta - 1 $


---

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
