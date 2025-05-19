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

  [Normalizing results LiMNet], [$dash.wave$], [$dash.wave$], [$checkmark$], [$checkmark$], [$checkmark$], [$checkmark$],
)

- with little to no information the model is performing somewhat good