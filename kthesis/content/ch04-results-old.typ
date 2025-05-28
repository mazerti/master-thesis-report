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

== Effects of the proposed adaptations for @limnet <r:improvements>

The first experiments we performed were designed to identify the best we could achieve using the @limnet model.
Thus, we compared for each proposed adaptation of @limnet presented in @m:improvements the performances of the model with and without it to check whether it led to an actual improvement or not.

=== normalization

#figure(
  image("../../../../figures/limnet-normalization.svg", width: 150%),
  placement: auto,
  caption: "Performances of the LiMNet model with and without normalization of the embeddings.",
) <fig:limnet-normalization>

removing the normalization reduces the performance significantly on all datasets, we thus recommend to always normalize the embeddings.

=== Time features

#figure(
  image("../../../../figures/limnet-time-features.svg", width: 150%),
  placement: auto,
  caption: "Performances of the LiMNet model with time features added.",
) <fig:limnet-time-features>

Adding time of day seem to provide slightly better results in average, but not every time.
Wikipedia have the best performances with all time features, but only a slight improvement over only time of day or even none.
reddit have sensibly identical results on average but using both time features seem to yield more consistent results, while none produce much better results sometimes.
on Lastfm using only time of day is best.
note that on all datasets, the features never yield a significant improvements, and using only the time of the week always results in worst results.

=== Multiple layers

#figure(
  image("../../../../figures/limnet-layers.svg", width: 150%),
  placement: auto,
  caption: "Performances of the LiMNet model with various number of stacked layers.",
) <fig:limnet-layers>

on wikipedia 1 layer is best the rest is equivalent
on reddit 2/3 perform the best
on lastfm 3/5 perform best
never very significant but the more dense the dataset the more layer

reasonable results

== Comparison with Jodie <r:jodie>

=== limnet vs jodie

#figure(
  image("../../../../figures/limnet-jodie.svg", width: 150%),
  placement: auto,
  caption: "Comparison of the LiMNet and Jodie models.",
) <fig:limnet-jodie>

jodie is always significantly better

=== embeddings size on jodie

as explained in the paper, embedding size doesn't matter

=== jodie op ?

wikipedia: 83% (~+10%)
reddit: 98% (~+25%)
lastfm: 83% (~+60%)

differences with original paper:
- batching strategy
strong feeling for short term popularity
run out of time

== Effect of the batching strategy <r:batching>

#figure(
  image("../../../../figures/sequence-length.svg", width: 150%),
  placement: auto,
  caption: "Effect of the sequence length on the models performances.",
) <fig:sequence-length-impact>

short term popularity: "most popular"
plot items interactions over time
