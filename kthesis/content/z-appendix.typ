#import "@preview/glossarium:0.5.4": gls, glspl

// = Appendix

= Complexity <ap:complexity>

In this section we perform a formal complexity analysis of both @limnet and Jodie regarding memory usage at inference.
Training is left aside as it can be tweaked through the usage of varied batching algorithms, but also because the cross-RNN mechanisms studied in this thesis are designed for performance at inference with little consideration for the training time.

#figure(
  table(
    columns: 3,
    align: (center, left, left),
    table.hline(),
    table.header([Symbol], [Meaning], [Context]),
    table.hline(stroke: 0.05em),
    [$u$],
    [Number of users in the network],
    [Dynamic value that can scales from thousands to millions depending on the success of the application],
    [$i$],
    [Number of items in the network],
    [Dynamic value that can scales from thousands to millions depending on the application],
    [$d$], [Size of the embeddings], [Fixed value, typically small],
    table.hline(),
    [$f$], [Size of the input features], [Fixed value, typically small],
  ),
  caption: "Symbols used for the complexity analysis.",
  placement: bottom,
) <table:symbols>

@table:symbols lists the symbols used in this complexity analysis.

The memory usage of both models are divided into two part: the embedding memory that stores the dynamic embeddings of every user and item in the network, and the model's weights.

The embedding memory is the same for @limnet and Jodie, it stores for each user and item an embedding of size $d$.
Therefore, the memory requirements for it is $O(d(u+i))$.

The model weights vary between @limnet and Jodie, yet both models share the same cross-RNN mechanism that contains a RNN/GRU cell with inputs of size $O(d + f)$ and outputs of size $d$, for a total memory complexity of $O(d^2 + d f)$.

In addition, Jodie have three outputs modules to take into account: the temporal projection module, the one-hot encoding module and the prediction layer.
The temporal projection layer is a linear layer with input of size 1 (the time delta), the complexity of this module is $O(d)$.
The one hot encoding module is essentially memory-free.
However, it increase the size of the embeddings fed into the prediction layer and served as output of the models.
Therefore, the prediction layer that is also a linear layer, have a complexity of $O((d + u)(d + i)) = O(d^2 + d(u+i) + u i)$.

#figure(
  table(
    columns: 3,
    table.hline(),
    [], [@limnet], [Jodie],
    table.hline(),
    [Embedding memory], [$O(d(u+i))$], [$O(d(u+i))$],
    [Model weights], [$O(d^2 + d f)$], [$O(d^2 + d(f + u + i) + u i)$],
    [Total complexity], [$O(d^2 + d(u + i + f))$], [$O(d^2 + d(f + u + i) + u i)$],
    [Assuming $d, f << u, i$], [$O(u+i)$], [$O(u i)$],
    table.hline(),
  ),
  caption: "Summary of the memory complexity for "+ gls("limnet") +" and Jodie",
  placement: auto,
) <table:complexity>

@table:complexity presents a summary of the total complexity for both models.
It stands out that the combination of the one-hot encoding module and the prediction layer causes Jodie to be an order of magnitude more resource intensive at inference than @limnet.
