= Experiments

This chapter presents the experiments conducted over the course of the project, along with their corresponding results.
Each model was trained and evaluated across 7 to 10 runs, with different random seeds used to initialize weights in each run to ensure robustness.
Performance was measured using @mrr, calculated based on the predicted ranks of the true target items in the test set.
During evaluation, interactions were processed sequentially using windows of the same length as those employed during training.

@fig:all-models presents a central finding of this thesis: a comprehensive performance comparison between @limnet and Jodie across all datasets.
The results unambiguously demonstrate that Jodie outperforms @limnet by a considerable margin in every scenario.
This outcome provides a strong, albeit negative, answer to the research question introduced at the beginning of this work.
Further experiments were conducted to investigate whether @limnet's performance could be enhanced through architectural adjustments.
These efforts are detailed in @ex:limnet.
Additionally, @ex:sequence-length explores a serendipitous insight that emerged during experimentation, offering a deeper understanding of the role temporal information plays in model performance.

#figure(
  image("../../../../figures/limnet-jodie.svg"),
  caption: "Comparison of LiMNet and Jodie models.",
  placement: auto,
) <fig:all-models>

== Improvements on @limnet <ex:limnet>

To reduce the performance disparity between @limnet and Jodie, we experimented with three architectural modifications.
Each of the following subsections describes one of these adaptations along with its experimental evaluation.

=== Adding time features

As described in @m:time-features, we augmented @limnet with cyclic time features derived from interaction timestamps.
This was done to investigate whether such information could enhance the model's ability to capture temporal patterns.

@fig:limnet-time-features illustrates the impact of these features on the model's performance, measured using @mrr.
While the additional features appear to reduce variance, they do not improve average performance and may even degrade it.
These results suggest that @limnet struggles to extract useful information from the added temporal signals, making this adaptation ineffective for improving its link prediction capability.

#figure(
  image("../../../../figures/limnet-time-features.svg"),
  placement: auto,
  caption: "Performances of the LiMNet model with time features added.",
) <fig:limnet-time-features>

=== Normalizing the embeddings

As explained in @m:normalize, we proposed improving @limnet's performance by systematically normalizing the embeddings throughout the cross-RNN mechanism.
This normalization encourages the model to learn angular relationships, which are more effectively exploited by the dot-product scoring function.
It also prevents embeddings from collapsing to zero, which would diminish their representational power.

As shown in @fig:limnet-normalization, this modification leads to a significant improvement in performance.
Accordingly, we adopted embedding normalization as the default configuration for all other experiments with @limnet .

#figure(
  image("../../../../figures/limnet-normalization.svg"),
  placement: auto,
  caption: "Performances of the LiMNet model with and without normalization of the embeddings.",
) <fig:limnet-normalization>

=== Stacking layers

Following the enhancement outlined in @m:stacking, we investigated the impact of stacking multiple layers of the @limnet architecture to determine whether increased depth could improve predictive accuracy by enhancing model expressiveness.

@fig:limnet-layers shows that stacking more than two layers does not result in further performance gains, and in some cases, leads to a decrease in accuracy.
Interestingly, increasing from one to two layers improves performance on more complex datasets like Reddit and LastFM, but slightly degrades it on the simpler Wikipedia dataset.
This suggests that additional layers may help capture intricate interaction patterns, but are unnecessary, or even detrimental, in more straightforward settings.

#figure(
  image("../../../../figures/limnet-layers.svg"),
  placement: auto,
  caption: "Performances of the LiMNet model with various numbers of stacked layers.",
) <fig:limnet-layers>

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

The final experiment examines how the length of the interaction sequence affects model performance, and by extension, the importance of temporal and sequential information.
We trained and evaluated each model using sequence lengths of 16, 64, 256, and 1024, limiting how many past interactions were accessible for each prediction.

As illustrated in @fig:sequence-length-impact, both models perform comparably across the tested sequence lengths, with longer sequences yielding only marginal gains or even slight degradations.
The only notable exception is @limnet on the Wikipedia dataset, where longer sequences show a modest improvement.
These findings indicate that neither model significantly benefits from extended temporal context and may not effectively leverage long-term dependencies as originally intended.

Instead, these results suggests that both models are learning short-term global popularity trends rather than long-term, user-specific preferences.
This behavior aligns with the characteristics of the datasets, where recent user activity can influence subsequent interactions.
Furthermore, each dataset is limited to the 1,000 most popular items over a one-month period, likely favoring items with short-lived popularity spikes.
As popularity shifts from one item to another, the models appear to focus on these transient dynamics.

This hypothesis may also explain why our implementation of Jodie achieves up to 60% higher @mrr on the LastFM dataset compared to the original implementation @jodie.
A key difference lies in the batching strategy: our implementation processes interactions in strict chronological order, while the original uses the t-batch algorithm, which groups interactions by shared users or items.
This distinction may result in our model better capturing global popularity signals, rather than local, user-specific patterns.

#figure(
  image("../../../../figures/sequence-length.svg"),
  placement: auto,
  caption: "Effect of the sequence length on the models' performances.",
) <fig:sequence-length-impact>
