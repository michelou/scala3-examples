# <span id="top">Scala 3 Resources</span> <span style="font-size:90%;">[↩](README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;max-width:80px;">
    <a href="https://dotty.epfl.ch/" rel="external"><img style="border:0;width:80px;" src="docs/images/dotty.png" /></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This document gathers <a href="https://dotty.epfl.ch/" rel="external">Scala 3</a> related resources that caught our attention.
  </td>
  </tr>
</table>

## <span id="articles">Articles</span>

- [Unlocking the Power of SBT][article_yadukrishnan] by Yadukrishnan, April 2023.
- [Safer Exceptions in Scala][article_odersky] by Martin Odersky et al., October 2021.
- [Die Top 5 der Neuerungen in Scala 3][article_hupel_top5] by Lars Hupel, August 2021.
- [Stufe 3][article_hupel_stufe3] by Lars Hupel, June 2021.
- [A Practical Unification of Multi-stage Programming and Macros](http://biboudis.github.io/papers/pcp-gpce18.pdf) by Nicolas Stucki et al., [GPCE'18](https://conf.researchr.org/track/gpce-2018/gpce-2018), November 2018.
- [Dependent Object Types](https://infoscience.epfl.ch/record/183030) by Nada Amin et al., October 2012.
- [Deriving Sesion and Union Types for Objects][article_bettini] by Lorenzo Bettini et al., September 2011.

## <span id="blogs">Blogs</span> [**&#x25B4;**](#top)

- [Pierre Ricadat's Tech Blog](https://blog.pierre-ricadat.com/):
  - [Scala 3 Migration: Report from the Field](https://blog.pierre-ricadat.com/scala-3-migration-report-from-the-field), February 2025.
- [Scala blog posts](https://alexn.org/blog/tag/scala/) from Alexandru Nedelcu :
  - [Scala's Future](https://alexn.org/blog/2024/01/10/scala-future/), January 2024.
  - [Scala 3 Enums][blog_nedelcu_enums], May 2023.
  - [Immutable Collections should be Your Default][blog_nedelcu_immutable], October 2022.
  - [Scripting with Scala][blog_nedelcu_scripting], September 2022.
  - [Scala isn't fun anymore][blog_nedelcu_isnt_fun], September 2022.
  - [Tracking Side Effects in Scala][blog_nedelcu_tracking], May 2022.
  - [OOP vs Type Classes, Part 1][blog_nedelcu_ideology1], May 2022.
  - [Implicit vs Scala 3's Given][blog_nedelcu_given], May 2022.
  - [Scala OOFP Design Sample][blog_nedelcu_oofp], April 2022.
- [SOFTWARE**MILL**](https://softwaremill.com/blog/?search=scala) :
   - [Prototype Loom-based concurrency API for Scala][blog_warski_2] by Adam Warski, February 2023.
   - [A solid checklist for configuring new Scala projects][blog_ciesielski] by Krzysztof Ciesielski, February 2023.
   - [The future of effects in Scala?][blog_warski_1] by Adam Warski, July 2022.
- [**VIRTUSLAB**][virtuslab] [Scala News][blog_virtuslab] :
  - [Scala 3 migration: 7 benefits that outweigh the risks](https://www.virtuslab.com/blog/technology/scala-3-migration-benefits-risks/) by Pawel Marks, &lt;year?&gt;.
  - [How to build a simple Scala application with Bazel](https://www.virtuslab.com/blog/introduction-to-bazel-for-scala-developers/), February 2023.
- [Databricks Blog][blog_databricks]
   - [Scala at Scale at Databricks](https://databricks.com/blog/2021/12/03/scala-at-scale-at-databricks.html) by Li Haoyi, December 2021.
   - [Speedy Scala Builds with Bazel at Databricks](https://www.databricks.com/blog/2019/02/27/speedy-scala-builds-with-bazel-at-databricks.html) by Li Haoyi and Ahir Reddy, February 2019.
- [Scala 3 : un nouveau langage ?][blog_sarradin] by François Sarradin, May 2021.
- [47 Degrees Blog][blog_47_degrees]
   - [Smart constructors for case classes][blog_markham] by Noel Markham, December 2021.
   - [Automatically Deriving Typeclass Instances in Scala 3](https://www.47deg.com/blog/scala-3-deriving-typeclasses/), May 2021.
   - [Typeclasses in Scala 3](https://www.47deg.com/blog/scala-3-typeclasses/), May 2021.
   - [Enumerations in Scala 3](https://www.47deg.com/blog/scala-3-enumerations/), April 2021.
   - [Compiler Plugin Development in Scala 3](https://www.47deg.com/blog/compiler-plugin-development-scala3/), March 2021.
- [Rock the JVM Blog](https://blog.rockthejvm.com/).
   - [Scala 3 Inlines Explained ](https://rockthejvm.com/articles/scala-3-inlines), February 2025.
   - [Functional Parallel Programming with Scala and Cats Effect](https://rockthejvm.com/articles/functional-parallel-programming-with-scala-and-cats-effect/) by Anzori Ghurtchumelia, March 2024.
   - [Exploiting Implicit Ambiguity in Scala](https://blog.rockthejvm.com/anti-implicits/) by Daniel Ciocîrlan, July 2021.
   - [Scala 3: Anti-Givens](https://blog.rockthejvm.com/anti-givens/) by Daniel Ciocîrlan, June 2021.
   - [Scala 3: Extension Methods](https://blog.rockthejvm.com/scala-3-extension-methods/) by Daniel Ciocîrlan, April 2021.
   - [Match Types in Scala 3](https://blog.rockthejvm.com/scala-3-match-types/) by Daniel Ciocîrlan, February 2021.
   - [Enums in Scala 3](https://blog.rockthejvm.com/enums-scala-3/) by Daniel Ciocîrlan, September 2020.
   - [New Types in Scala 3](https://blog.rockthejvm.com/new-types-scala-3/) by Daniel Ciocîrlan, September 2020.
- [Scala Blog](https://www.shivamkapoor.com/tag/scala/) by Shivan Kapoor:
  - [Making sense of Functors in Scala][blog_kapoor_functors], June 2021.
  - [Recursive Descent Parsers in Scala - Part 3][blog_kapoor_parsers3], December 2020.
  - [Recursive Descent Parsers in Scala - Part 2][blog_kapoor_parsers2], August 2020.
  - [Recursive Descent Parsers in Scala - Part 1][blog_kapoor_parsers1], June 2020.
- [Figuring out Scala functional programming libraries](https://blog.softwaremill.com/figuring-out-scala-functional-programming-libraries-af8230efccb4) by Krzysztof Atłasik, March 2021.
- [Higher-rank and higher-kinded types](https://www.stephanboyer.com/post/115/higher-rank-and-higher-kinded-types) by Stephan Boyer, April 2016.
- [Sum Types Are Coming: What You Should Know](https://chadaustin.me/2015/07/sum-types/) by Chad Austin, July 2015.

## <span id="books">Books</span> [**&#x25B4;**](#top)

- [Functional Programming in Scala][book_pilquist] (2<sup>nd</sup> Edition) by Michael Pilquist and al., Spring 2023.<br/><span style="font-size:80%;">(Manning, ISBN 978-1-6172-9958-2, 543 pages)</span>
- [Beginning Scala 3][book_pollak] (3<sup>rd</sup> Edition) by David Pollak et al, 2022.<br/><span style="font-size:80%;">(Apress, ISBN 978-1-4842-7421-7)
- [Scala Cookbook][book_alexander] (2<sup>nd</sup> Edition) by Alvin Alexander, August 2021.<br/><span style="font-size:80%;">(O'Reilly, ISBN 978-1-4920-5154-1, 802 pages)</span>
- [Programming Scala][book_wampler] (3<sup>rd</sup> Edition) by Dean Wampler and Alex Payne, June 2021.<br/><span style="font-size:80%;">(O'Reilly, ISBN 978-1-4920-7789-3)</span>
- [Programming in Scala](https://www.artima.com/shop/programming_in_scala_5ed) (5<sup>th</sup> Edition) by Martin Odersky et al., May 2021.<br/><span style="font-size:80%;">(<a href="https://www.artima.com/about">Artima Press</a>, ISBN 978-0-9971-4800-8, 651 pages)</span>
- [Hands-on Scala Programming][book_haoyi] by Li Haoyi, July 2020.<br/><span style="font-size:80%;">(Li Haoyli, ISBN 978-9-8114-5693-0, 414 pages)</span>
- [Essential Scala](https://underscore.io/books/essential-scala/) (v1.3) by Noel Welsh and Dave Gurnell, April 2017.
- [Introduction to Programming and Problem-Solving Using Scala][book_lewis]  (2<sup>nd</sup> edition) by Mark C. Lewis and Lisa Lacher, August 2016.<br/><span style="font-size:80%;">(CRC Press, ISBN 978-1-4987-3095-2, 590 pages)</span>

## <span id="courses">Courses</span> [**&#x25B4;**](#top)

- [Learning to code in Scala](https://scala.zone/courses/scala): [Beginner](https://scala.zone/courses/scala/beginner), [Intermediate](https://scala.zone/courses/scala/intermediate), [Advanced](https://scala.zone/courses/scala/advanced).
- [CSci 555 : Functional Programming][course_csci555] by Conrad Cunningham, Spring Semester 2019.

## <span id="news">News</span>

- [Scala Times](https://scalatimes.com/) - Weekly Scala Newspaper.
- [This week in #Scala](https://petr-zapletal.medium.com/) by Petr Zapletal.

## <span id="papers">Papers</span>

- [Semantics-Preserving Inlining for Metaprogramming][paper_stucki] by Nicolas Stucki et al., November 2020.
- [Towards Improved GADT Reasoning in Scala](http://lptk.github.io/files/%5Bv.2.0.1%5D%20scala19_gadt.pdf)] by L. Parreaux, A Boruch-Gruszecki and P.-G. Giarrusso, 2019.
- [Initialization Patterns in Dotty](http://biboudis.github.io/papers/init-scala18.pdf) by F. Liu, A. Biboudis and M. Odersky, September 2018.
- [Interactive Development using the Dotty Compiler][paper_martres] by Guillaume Martres, October 2017.
- [Implementing Higher-Kinded Types in Dotty][paper_odersky_hkt] by Martin Odersky et al., October 2016.

## <span id="projects">Projects</span> [**&#x25B4;**](#top)

- [borer](https://sirthias.github.io/borer/) &ndash; an efficient [CBOR](https://cbor.io/) and JSON (de)serialization for Scala.
- [Cask](https://github.com/com-lihaoyi/cask) &ndash; a Scala HTTP micro-framework.
- [Decline](https://github.com/bkirwi/decline) &ndash; a composable command-line parser for Scala.
- [enumeratum](https://github.com/lloydmeta/enumeratum) &ndash; a type-safe, reflection-free, powerful enumeration implementation for Scala.
- [iron](https://github.com/Iltotore/iron) &ndash; strong type constraints for Scala.
- [Ox](https://github.com/softwaremill/ox) &ndash; safe direct-style concurrency for Scala.
- [Scala.js][project_scalajs] &ndash; a Scala backend to generate highly efficient JavaScript.
- [ScalaStan][project_scalastan] &ndash; a Scala DSL for [Stan](https://mc-stan.org/), an open-source software for statistical modeling and high-performance statistical computation.
- [Scalalikejdbc](https://github.com/scalikejdbc/scalikejdbc) &ndash; a tidy SQL-based DB access library for Scala developers.
- [Tyrian](https://tyrian.indigoengine.io/) &ndash; an Elm-inspired, purely functional UI library for Scala 3.
- [WartRemover](https://github.com/wartremover/wartremover) &ndash; a flexible Scala code linting tool.
- [Woof](https://github.com/LEGO/woof) &ndash; a pure Scala 3 logging library with no reflection.

## <span id="shell">Shell Scripting</span>

- [Google Shell Guide](https://google.github.io/styleguide/shellguide.html)

## <span id="videos">Videos</span>

- [Debugging Scala 3 in VSCode][video_piquerez] by Adrien Piquerez, January 2023.
- [Simply Scala][video_odersky2022] by Martin Odersky, October 2022 ([ScalaCon 2022](https://www.scalacon.org/)).
- [Type Classes in Scala 3][video_mittal] by Ayush Mittal, March 2022 (Functional Conf 2022).
- [Typeclasses in Scala 3][video_markham] by Noel Markham, January 2022 (Colombia Scala neetup).
- [Scala 3 has landed][video_odersky2021] by Martin Odersky, May 2021.
- [Scala 3, Type Inference and You!][video_martres] by Guillaume Martres, September 2019.
- [Reflection and Compilers][video_odersky2012] by Martin Odersky, April 2012.

<!--
## <span id="git">Git</span>

- [Advanced Git: Power Commands Beyond the Basics](https://kinsta.com/blog/advanced-git/) by Jeremy Holcombe, June 2023.
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/November 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[article_bettini]: http://www.di.unito.it/~capecchi/
[article_hupel_stufe3]: https://www.innoq.com/de/articles/2021/06/stufe-3/
[article_hupel_top5]: https://www.innoq.com/de/articles/2021/08/top5-neuerungen-scala/
[article_odersky]: https://infoscience.epfl.ch/record/290885
[article_yadukrishnan]: https://yadukrishnan.live/unlocking-the-power-of-sbt-a-beginners-guide-to-understanding-not-so-common-features
[blog_47_degrees]: https://www.47deg.com/blog/tags/scala/
[blog_databricks]: https://databricks.com/blog
[blog_kapoor_functors]: https://www.shivamkapoor.com/2021/06/04/making-sense-of-functors-in-scala/
[blog_kapoor_parsers1]: https://www.shivamkapoor.com/2020/06/02/recursive-descent-parsers-in-scala-1-writing-context-free-grammar/
[blog_kapoor_parsers2]: https://www.shivamkapoor.com/2020/08/10/recursive-descent-parsers-in-scala-2-build-parser-using-fastparse-parser-combinators/
[blog_kapoor_parsers3]: https://www.shivamkapoor.com/2020/12/06/recursive-descent-parsers-in-scala-3-cross-compiling-scala-parser-library-to-javascript-using-scala-js/
[blog_nedelcu_enums]: https://alexn.org/blog/2023/05/25/scala-enums/
[blog_nedelcu_given]: https://alexn.org/blog/2022/05/11/implicit-vs-scala-3-given/
[blog_nedelcu_ideology1]: https://alexn.org/blog/2022/05/13/oop-vs-type-classes-part-1-ideology/
[blog_nedelcu_immutable]: https://alexn.org/blog/2022/10/27/immutable-collections-your-default/
[blog_nedelcu_isnt_fun]: https://alexn.org/blog/2022/09/09/scala-isnt-fun-anymore/
[blog_nedelcu_oofp]: https://alexn.org/blog/2022/04/18/scala-oop-design-sample/
[blog_nedelcu_scripting]: https://alexn.org/blog/2022/09/13/scripting-with-scala/
[blog_nedelcu_tracking]: https://alexn.org/blog/2022/05/23/tracking-effects-in-scala/
[blog_sarradin]: https://univalence.io/blog/articles/scala-3-un-nouveau-langage/
[blog_warski_2]: https://softwaremill.com/prototype-loom-based-concurrency-api-for-scala/
[blog_virtuslab]: https://www.virtuslab.com/blog/tag/scala-news/
[blog_warski_1]: https://softwaremill.com/the-future-of-effects-in-scala/
[book_alexander]: https://www.oreilly.com/library/view/scala-cookbook-2nd/9781492051534/
[book_haoyi]: https://www.handsonscala.com/
[book_lewis]: https://www.routledge.com/Introduction-to-Programming-and-Problem-Solving-Using-Scala/Lewis-Lacher/p/book/9781498730952
[book_pilquist]: https://www.manning.com/books/functional-programming-in-scala-second-edition
[book_wampler]: https://www.oreilly.com/library/view/programming-scala-2nd/9781491950135/
[blog_ciesielski]: https://softwaremill.com/new-scala-project-checklist/
[blog_markham]: https://www.47deg.com/blog/smart-constructors-in-scala/
[book_pollak]: https://www.apress.com/gp/book/9781484274217
[course_csci555]: https://john.cs.olemiss.edu/~hcc/csci555/notes/555lectureNotes.html
[paper_martres]: https://conf.researchr.org/details/scala-2017/scala-2017-papers/4/Interactive-Development-using-the-Dotty-Compiler-Tool-Paper-
[paper_odersky_hkt]: https://conf.researchr.org/details/scala-2016/scala-2016/5/Implementing-Higher-Kinded-Types-in-Dotty
[paper_stucki]: https://dl.acm.org/doi/10.1145/3426426.3428486
[project_scalajs]: https://www.scala-js.org/
[project_scalastan]: https://github.com/cibotech/scalastan
[video_martres]: https://youtu.be/lMvOykNQ4zs
[video_markham]: https://www.47deg.com/media/2022/01/27/typeclasses-in-scala-3/
[video_mittal]: https://www.youtube.com/watch?v=G5c0U69QaLE
[video_odersky2022]: https://www.youtube.com/watch?v=QRcD9Zc7eq4
[video_odersky2021]: https://youtu.be/JcLG9Ss9Y-w
[video_odersky2012]: https://learn.microsoft.com/en-us/events/lang-next-2012/reflection-compilers
[video_piquerez]: https://www.47deg.com/blog/lets-talk-scala-3-debugging-scala3-vscode/
[virtuslab]: https://www.virtuslab.com/
