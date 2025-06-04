/* All theses at KTH are required to have an abstract in both English and Swedish.

Exchange students may want to include one or more abstracts in the language(s) used in their home institutions to avoid the need to write another thesis when returning to their home institution.
Keep in mind that most of your potential readers are only going to read your title and abstract.
This is why the abstract must give them enough information so that they can decide if this document is relevant to them or not.
Otherwise, the likely default choice is to ignore the rest of your document.
An abstract should stand on its own, i.e., no citations, cross-references to the body of the document, acronyms must be spelled out, ….
Write this early and revise as necessary.
This will help keep you focused on what you are trying to do.
*/
User-item recommendation is a central challenge for search engines, social media platforms, and streaming services, due to the need to model both relational structures and temporal dynamics. Many existing solutions address these two aspects separately, limiting their ability to fully capture user behavior.

In this work, we attempt to bridge that gap by evaluating Lightweight Memory Networks (LiMNet), a model designed to preserve causal relationships within sequences of temporal interactions. To assess its potential, we developed a benchmarking framework for user-item interaction prediction. We compared LiMNet against Jodie, a state-of-the-art baseline, across three real-world datasets: Wikipedia page edits, Reddit post submissions, and LastFM music streams. These datasets vary in scale and interaction patterns, providing a comprehensive testbed.

Our results show that while LiMNet offers advantages in efficiency and adaptability, it consistently underperforms compared to Jodie in predictive accuracy. Additionally, our findings hint at a consistent bias across all datasets toward short-term global popularity. This suggests that existing models may be overfitting to recent trends rather than learning long-term user preferences, highlighting a potential limitation in the current evaluation paradigms.
/*
An abstract is (typically) about 250 and 350 words (1/2 A4-page) with the following components:
- What is the topic area?
  (optional) Introduces the subject area for the project.
- Short problem statement
- Why was this problem worth a Bachelor’s/Master’s thesis project?
  (i.e., why is the problem both significant and of a suitable degree of difficulty for a Bachelor’s/Master’s thesis project?
  Why has no one else solved it yet?)
- How did you solve the problem?
  What was your method/insight?
- Results/Conclusions/Consequences/Impact: What are your key results/ conclusions?
  What will others do based on your results?
  What can be done now that you have finished - that could not be done before your thesis project was completed?

*/
/*
The following are some notes about what can be included (in terms of LaTeX) in your abstract.
Choice of typeface with \textit, \textbf, and \texttt: x, x, and x.
Text superscripts and subscripts with \textsubscript and \textsuperscript: Ax and Ax.
Some symbols that you might find useful are available, such as: \textregistered, \texttrademark, and \textcopyright.
For example, the copyright symbol: \textcopyright Maguire 2022 results in ©Maguire 2022.
Additionally, here are some examples of text superscripts (which can be com- bined with some symbols): \textsuperscript{99m}Tc, A\textsuperscript{*}, A\textsuperscript{\textregistered}, and A\texttrademark resulting in 99mTc, A*, A®, and A™.
Two examples of subscripts are: H\textsubscript{2}O and CO\textsubscript{2} which produce H2O and CO2.
You can use simple environments with begin and end: itemize and enumerate and within these use instances of \item.
The following commands can be used: \eg, \Eg, \ie, \Ie, \etc, and \etal: e.g., E.g., i.e., I.e., etc., and et al.
The following commands for numbering with lowercase Roman numerals: \first, \Second, \third, \fourth, \fifth, \sixth, \seventh, and \eighth: (i), (ii), (iii), (iv), (v), (vi), (vii), and (viii).
Note that the second case is set with a capital ’S’ to avoid conflicts with the use of second of as a unit in the siunitx package.
Equations using \( xxxx \) or \[ xxxx \] can be used in the abstract.
*Note that you cannot use an equation between dollar signs.*
Even LaTeX comments can be handled by using a backslash to quote the percent symbol, for example: % comment.
Note that one can include percentages, such as: 51% or 51 %
*/
