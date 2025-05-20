= Results

- Jodie is sensitive to the embedding size
- Adding layers to LiMNet doesn't improve the performance for link prediction
- Adding time features does not improve the performance
- Jodie can perform much better (???)
- Normalizing results seems to increase performances for LiMNet and Embeddings

#table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  align: center,
  table.header(
    [Claim],
    table.cell(colspan: 2)[Wikipedia],
    table.cell(colspan: 2)[Reddit],
    table.cell(colspan: 2)[Lastfm],
  ),

  [Changing embedding size Jodie], [$emptyset$], [$emptyset$], [$checkmark$], [$checkmark$], [$checkmark$], [],
  [Adding layers LiMNet], [$checkmark$], [$checkmark$], [$checkmark$], [$checkmark$], [$checkmark$], [$checkmark$],
  [Adding time features LiMNet],
  [$checkmark$],
  [$checkmark$],
  [$checkmark$],
  [$checkmark$],
  [$checkmark$],
  [$dash.wave$],

  [Normalizing results LiMNet],
  [$dash.wave$],
  [$dash.wave$],
  [$checkmark$],
  [$checkmark$],
  [$checkmark$],
  [$checkmark$],
)

- with little to no information the model is performing somewhat good

#line(length: 100%)
#line(length: 100%)

Experiments to conduct:
- Each model at its best
- LiMNet with time features (none, both, day, week)
- LiMNet without normalization (with/without)
- LiMNet at several layers (1, 3, 5, 2)
- Jodie at several embedding size (32, 64, 16, 48, 128)
- Models with a small sequence length

// --- Start of actual writing ---

In this chapter, we present the results of the *$6$* experiments performed.
First, we discuss in @r:improvements the measured performances of the proposed improvements on the @limnet architecture.
Then, @r:jodie present the results yielded by our implementation of Jodie@jodie, and we discuss the differences we noticed with the initial publication.
Lastly, @r:batching exhibits the impact of the batching strategy on the two models.

== Effects of the proposed improvements for @limnet <r:improvements>

== Comparison with Jodie <r:jodie>

== Effect of the batching strategy <r:batching>
