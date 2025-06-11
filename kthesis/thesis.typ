#import "@preview/kthesis:0.1.1": kth-thesis, setup-appendices

// The template is extensible and plays well with other dependencies;
// For example, a table of acronyms can be generated using glossarium
#import "@preview/glossarium:0.5.6": make-glossary, register-glossary, print-glossary
#import "./acronyms.typ": acronyms
#show: make-glossary
#register-glossary(acronyms)

#set math.equation(
  numbering: "(1)",
  // supplement: equation => "("+equation.number+")",
  supplement: [Eq.],
)
// Configure formatting options before invoking the template;
// For example, uncomment below to set another font (except for covers)
// #set text(font: "New Computer Modern")

// --------------------------------------------------------------------- //
// ---------- MAIN THESIS TEMPLATE ENTRYPOINT & CONFIGURATION ---------- //
// --------------------------------------------------------------------- //
#show: kth-thesis.with(
  // Primary document language; either "en" or "sv"
  primary-lang: "en",
  // Language-specific title, subtitle, abstract, and keywords.
  // Grouped by language, with only values for "en" and "sv" being mandatory.
  // Localized abstract/keywords headings may be omitted only for "en" and "sv".
  // Field "alpha-3" is the language's ISO 639-3 code, for non-"en"/"sv" langs.
  localized-info: (
    en: (
      title: "Lightweight Memory Networks for Interaction Prediction",
      subtitle: "Generalization of the LiMNet Architecture",
      abstract: include "./content/abstract-1-en.typ",
      keywords: (
        "Graph Representation Learning",
        "Temporal Interaction Networks",
        "Interaction Prediction",
        "Link Prediction",
        "Data Mining",
        "Machine Learning",
        "Recommendations",
      ),
    ),
    sv: (
      title: "Lightweight Memory Networks för interaktion prediktion", // TODO: Check translation
      subtitle: "Generalization av LiMNet Arkitektur",
      abstract: include "./content/abstract-2-sv.typ",
      keywords: (
        "Graph Representation Learning",
        "Temporal Interaction Networks",
        "Link Prediction",
        "Data Mining",
        "Machine Learning",
        "Rekommendation",
      ),
    ),
    fr: (
      title: "Prédiction d'interaction à l'aide de Lightweight Memory Networks",
      subtitle: "Généralization de l'architecture LiMNet",
      abstract: include "./content/abstract-3-fr.typ",
      keywords: (
        "Apprentissage de représentation de graphes.",
        "Réseaux d'interaction temporels",
        "Prédiction de liens",
        "Data Mining",
        "Machine Learning",
        "Recommendations",
      ),
    ),
  ),
  // Ordered author information; only first and last names fields are mandatory
  authors: (
    (
      first-name: "Titouan",
      last-names: "Mazier",
      email: "mazier@kth.se",
      user-id: "",
      school: "School of Electrical Engineering and Computer Science",
      department: "Department of Computer Science",
    ),
  ),
  // Ordered supervisor information; "external-org" replaces userid/school/dept
  supervisors: (
    (
      first-name: "Šarūnas",
      last-names: "Girdzijauskas",
      email: "sarunasg@kth.se",
      user-id: "",
      school: "School of Electrical Engineering and Computer Science",
      department: "Department of Computer Science",
    ),
    (
      first-name: "Lodovico",
      last-names: "Giaretta",
      email: "lodovico.giaretta@ri.se",
      external-org: "RISE, Research Institute of Sweden",
    ),
  ),
  // Thesis examiner; must be internal to the school so all fields are mandatory
  examiner: (
    first-name: "Viktoria",
    last-names: "Fodor",
    email: "vjfodor@kth.se",
    school: "School of Electrical Engineering and Computer Science",
    department: "Department of Computer Science",
  ),
  // Degree project course within which the thesis is being conducted.
  // All fields are mandatory; credits are the course's ECTS credits (hp).
  course: (code: "DA250X", credits: 30),
  // Degree as part of which the thesis is conducted; all fields are mandatory.
  // Subject area is main field of study as listed in the second dropdown here:
  // https://www.kth.se/en/student/studier/examen/examensregler-1.5685
  // Kind is the degree title conferred as listed in the third dropdown above.
  // Cycle is either 1 (Bachelor's) or 2 (Master's), per Bologna.
  degree: (
    code: "CDATE",
    name: "Master's Program, Computer Science",
    subject-area: "Computer Science and Engineering",
    kind: "Master of Science in Engineering",
    cycle: 2,
  ),
  // National subject category codes; mandatory for DiVA classification.
  // One or more 3-to-5 digit codes, with preference for 5-digit codes, from:
  // https://www.scb.se/contentassets/10054f2ef27c437884e8cde0d38b9cc4/standard-for-svensk-indelning--av-forskningsamnen-2011-uppdaterad-aug-2016.pdf
  national-subject-categories: "10201",
  // School that the thesis is part of (abbreviation)
  school: "EECS",
  // TRITA number assigned to thesis after final examiner approval
  trita-number: "2024:0000",
  // Host company collaborating for this thesis; may be none
  host-company: "RISE, Research Institute of Sweden",
  // Host organization collaborating for this thesis; may be none
  host-org: none,
  // Names of opponents for this thesis; may be none until they're assigned
  opponents: (),
  // Thesis presentation details; may be none until it's scheduled and set.
  // Either "online" or "location" fields may be none, but not both.
  presentation: (
    language: "en",
    slot: datetime(year: 2025, month: 6, day: 23, hour: 13, minute: 0, second: 0),
    online: (service: "Zoom", link: ""),
    location: (room: "", address: "", city: "Stockholm"),
  ),
  // Acknowledgements body
  acknowledgements: include "content/acknowledgements.typ",
  // Additional front-matter sections, each with keys "heading" and "body"
  extra-preambles: ((heading: "Acronyms and Abbreviations", body: print-glossary(acronyms)),),
  // Document date; hardcode for determinism/reproducibility
  doc-date: datetime.today(),
  // Document city (where it's being signed/authored/submitted)
  doc-city: "Stockholm",
  // Extra keywords, embedded in document metadata but not listed in text
  doc-extra-keywords: ("master thesis",),
  // Whether to include trailing "For DiVA" metadata structure section
  with-for-diva: false,
)
// Tip: when tagging elements, scope labels like <intro:goals:example>

#set table(stroke: none)

#include "./content/ch01-introduction.typ"
#include "./content/ch02-background.typ"
#include "./content/ch03-method.typ"
#include "./content/ch04-results.typ"
#include "./content/ch0X-conclusion.typ"

#bibliography("../../../bibliography.bib", title: "References")

#show: setup-appendices
