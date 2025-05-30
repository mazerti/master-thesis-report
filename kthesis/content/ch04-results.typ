= Experiments

In this chapter, we present the experiments performed throughout this project.
The first section covers how we tried to improve on the core of the limnet model.
// In @r:jodie, we reproduce one of the experiments presented in @jodie.
Then we evaluate the impact of the temporal information on the models.

#figure(
  image("../../../../figures/limnet-jodie.svg"),
  caption: "Comparison of LiMNet and Jodie models.",
  placement: auto
) <fig:all-models>

To give some context, @fig:all-models shows the performance of the two models we tested, @limnet and Jodie.
It stands clearly that Jodie is outperforming @limnet by a wide margin.

== Improvements on limnet

Three different modifications have been tried with the hope of reducing the gap between @limnet and Jodie.
The three following subsections present these modifications and their experimental results.

=== Adding time features

The most important specificity of the models tested lies in their ability to leverage temporal relationships between users and items.
However, @limnet only exploits the order in which interactions happen, with no consideration for their exact time.

To resolve this absence, this experiment tries to pass the exact interaction timestamps as features to the @limnet model.
More specifically, the features passed to the model seek to capture cyclic patterns in the interactions.
Unfortunately, the datasets only provide relative timestamps that do not carry the precise time and day of the interactions.
We thus approximated these patterns through a frequency decomposition of the following form:

$ cos((2 pi) / Delta t), sin((2pi) / Delta t) $

Where $t$ is the timestamp of the interaction, and $Delta$ is the duration of the pattern we want to capture (a day or a week) in the unit of the timestamps.
Using cosine and sine is a trick that provides the model with easily comparable features compared to directly passing the timestamps as a feature.

#figure(
  image("../../../../figures/limnet-time-features.svg"),
  placement: auto,
  caption: "Performances of the LiMNet model with time features added.",
) <fig:limnet-time-features>

@fig:limnet-time-features Shows the impact of these features on the measured @mrr.
Adding features seems to reduce the variance of the model, but may have a negative impact on the average results.
In any case, it seems clear that the model struggles to deal with these additional features in a meaningful way.
This experiment thus constitutes a case against using such features as a way to enhance the @limnet model for link prediction.

=== Normalizing the embeddings

Forcing the embeddings to lie on the unit sphere pushes the model to encode information through the angle the embeddings form with the space origin rather than through their amplitude.
This is appropriate when optimizing the embeddings for the dot-product score @eq:dot-product-score.
In this experiment, we tried to systematically normalize the embeddings after each interaction; this way, not only the outputs but also the inputs of the cross-RNN are always normalized.

#figure(
  image("../../../../figures/limnet-normalization.svg"),
  placement: auto,
  caption: "Performances of the LiMNet model with and without normalization of the embeddings.",
) <fig:limnet-normalization>

As you can see in @fig:limnet-normalization, this modification yields significantly better results.
Thus, we apply it by default to all the other experiments presented in this report.

=== Stacking layers

This experiment tests whether stacking several layers of @limnet could improve its results.
@fig:multi-layer-limnet illustrates the architecture of a stacked @limnet model.
In between layers, Leaky ReLU units have been added to add non-linearity and expressiveness to the model.

#figure(
  image("../../../../figures/limnet-layers.svg"),
  placement: auto,
  caption: "Performances of the LiMNet model with various numbers of stacked layers.",
) <fig:limnet-layers>

As shown in @fig:limnet-layers, stacking more than two layers doesn't prove to increase the model performance.
Another observation that can be made is that changing from one layer to two have a positive impact on the more complex dataset but tend to decrease the performance of the model for the simpler Wikipedia dataset.

// == Comparing Jodie embeddings size <r:jodie>

// Throughout the development, we witnessed an occurrence of Jodie performing surprisingly poorly with a small embedding size.
// This observation contradicts with one of the experiment conducted by Kumar et al. in the paper where they present the model @jodie, that showed that the embedding dimension have no influence on the performances of the model.
// This observation lead to the reproduction of the original experiment.

// #figure(
//   image("../../../../figures/jodie-embeddings.svg"),
//   placement: auto,
//   caption: "Performances of the Jodie model with different embedding sizes.",
// ) <fig:jodie-embeddings>

// The founding of this reproduction are summarized in @fig:jodie-embeddings.
// They do confirm the original foundings in average.
// However, the reproduction shows that at smaller embedding size the model can significantly underperform.

== Impact of the sequence size on the results <ex:sequence-length>

The last experiment aims to understand the impact of the temporal and sequential information on the performance of the models.
It was performed by training and evaluating the models with sequence lengths of 16, 64, 256, and 1024, so that the model would only have access to up to this many successive interactions to perform their prediction.

#figure(
  image("../../../../figures/sequence-length.svg"),
  placement: auto,
  caption: "Effect of the sequence length on the models' performances.",
) <fig:sequence-length-impact>

The results displayed in @fig:sequence-length-impact show that both models perform, at best, as good with a bigger sequence length, which suggests a poor ability to exploit long-term information.
However, except for @limnet on Wikipedia, the sequence length seems to actually play only a marginal role in the performance of both models, which suggests that they may not even alleviate temporal information as they were designed for.

Under the light of these observations, we assume that the models may have learned over short-term global popularity patterns instead of long-term local preferences.
This behavior seems to make sense with regard to the nature of the datasets used, where recent interactions by other users are likely to provoke new interactions from other users.
In addition, all these datasets contain only the 1,000 most popular items over a period of a month.
That could have led to selecting mostly items whose popularity spiked around given times during the month before going down again, while the spotlight was turning towards other items.

Such a hypothesis could explain why our implementation of Jodie is reaching up to 60% higher @mrr on LastFM compared with the original implementation.
The main difference between our implementation and the one presented in the paper is the batching algorithm; in this project, interactions are processed in chronological order, while in @jodie they are processed following the t-batch algorithm.
The t-batch algorithm groups interactions with common items or users together, leading to a more localized information sharing mechanism.
