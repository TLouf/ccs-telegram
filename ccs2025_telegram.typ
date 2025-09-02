#import "pretty-metro.typ": *
#import "@preview/zero:0.3.3": num

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
    date: datetime(year: 2025, month: 9, day: 2).display("[month repr:long] [day padding:none], [year]"),
    // institution: {image("figs/FBK_logo.svg", height: 25%)},
    logo: {
      only("1")[
        #box(image("figs/logo_unitn_maths.png", height: 15%))
        #box(image("figs/FBK_logo.svg", height: 25%), inset: (x: 24pt))
      ]
      only("2")[
        #box(image("figs/round_aurora.png", height: 40%), inset: (x: 100pt))
      ]
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

#figure(grid(
  columns: 5,
  rows: 1,
  gutter: 16pt,
  grid.cell(colspan: 2, image("figs/Telegram_logo.svg", height: 23%)),
  grid.cell(colspan: 1, align: horizon, text(size: 48pt)[$eq.quest$]),
  grid.cell(colspan: 2, image("figs/Logo_of_Twitter.svg", height: 23%)),
))
// #pause
// - Is _largely unregulated_
// #pause
// - ... and also _under-studied_ scientifically

---

Not exactly!

- Its *structure is based on channels* \
#pause
// #fa-arrow-right()
#h(1em) #implies() information is more containerised \
#pause
#h(1em) #implies() not easy to _search_ for content

#pause

#grid(
  columns: (1fr, 1fr),
  [- Largely *unregulated*], only("4")[#image("figs/durov_arrest.jpg", height: 30%)],
)

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

== A forwarding network

- Nodes: #num(29609) channels
- Edge from B to A when A forwards a message from B #fa-arrow-right() #num(501897) directed edges


#figure(image("figs/strucure.png", height: 55%))

#fa-arrow-right() Network of information flow

== Strength distributions

Do we have the usual Pareto law?

#figure(image("figs/strength_2.png", height: 70%))

== Clustering

Tendency to forward from friends of my friends?

#figure(image("figs/cluster.png", height: 70%))


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
  grid.cell(align: horizon, [
    We do have

    $ p(E) ~ E^(-beta) $

    #implies() forwarding is bursty

  ]),
  image("figs/burst_train_log_binn.png", height: 51%),
)





= Modeling

== Mechanisms at play


#v(1fr)

#table(
  columns: (1.5fr, 1fr),
  stroke: none,
  [
    #text(tertiary, size: 30pt)[Topology]

    - clustering
    - power-law in/out-strength distributions
    - language assortativity
    - tendency to reinforce existing ties
  ],
  [
    #text(primary, size: 30pt)[Time]

    - two regimes
    - burstiness
  ],
)

#pause

#v(1fr)

Simple-enough model that can reproduce these features?

#implies() Could help simulate contagion model or equivalent and test effect of interventions on synthetic networks

#v(1fr)


== Time

// == Memory
#grid(
  columns: (1.2fr, 3fr),
  align: horizon,
  [
    With already $n$ events in a burst train, probability $p(n)$ to generate another within the same train?
  ],
  figure(image("figs/memo_func_cropped.png", height: 55%)),
)


#fa-arrow-right() Train size distribution generated from memory process @KarsaiUniversalFeatures2012

$ p(E) ~ E^(-beta) <=> p(n) = ( n / (n+1) )^nu #h(2em) "with" nu approx beta - 1 $


---

Generalisation from @KarsaiUniversalFeatures2012

#only("1")[#figure(image("figs/time_model.svg"))]

#only("2")[#figure(image("figs/time_model_regimes_focus.svg"))]

#only("3")[#figure(image("figs/tau_distrib_3fits.svg"))]

#only("4-")[#figure(image("figs/time_model.svg"))]

// say nu is for free


== Topology

Adapted from @LaurentCallsCommunities2015

#figure(image("figs/top_model.svg", height: 75%))

// say which parameters we get for free (all except p_TC, which anyway is just slightly lower than actual value of clustering)

== Results

Fitted time model ($pi$, $mu_(A_("1/2"))$, $mu_B$, $k$) to reproduce piecewise power-law $p(tau)$

#figure(image("figs/sim_taus.svg", height: 60%))
// #figure(image("figs/rescale_tau_groups.png", height: 60%))

#implies() _It fits_ (+ it runs fast: $~10s$) ($pi approx 0.20, mu_(A_1) approx 0.019, mu_(A_2) approx 0.74, mu_B approx 4.8, k = 81$)


---

Can generate synthetic networks by creating event sequence for each node, and then pick who they forward using topology model.

#pause

_Issue_: no guarantee average event rate for nodes is conserved.

#pause

#grid(
  columns: (1.5fr, 2fr),
  // align: horizon,
  [
    #fa-arrow-right() What if we just contract/dilate time to fit event rates?

    #only("3-")[#implies() slight deformation of $p(tau)$]

    #only("4-")[#implies() very similar $beta$ in $p(E) ~ E^(-beta)$]
  ],
  [
    #only("3")[#figure(image("figs/rescaled_sim_taus.svg", height: 60%))]

    #only("4")[#figure(image("figs/rescaled_sim_burst_train_sizes.svg", height: 60%))]
  ],
)


// #pause

// #grid(
//   columns: (1.5fr, 2fr),
//   align: horizon,

//   [#fa-arrow-right() What if we just contract/dilate time to fit event rates?],

//   figure(image("figs/rescaled_sim_taus.svg", height: 60%)),
// )


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
    and much more!
  ]

  #v(1fr)
]


#focus-slide()[
  #v(1fr)

  #text(1.5em)[Thanks for your attention 🤗]

  #v(1fr)

  #fa-bluesky() #link("https://bsky.app/profile/tlouf.bsky.social")[\@TLouf] \
  #fa-github() #link("https://github.com/TLouf")[\@TLouf] \
  #fa-icon("envelope", solid: true) #link("mailto:tlouf\@math.uc3m.es")[tlouf\@math.uc3m.es] \
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
