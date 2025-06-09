#import "@preview/glossarium:0.5.4": gls, glspl
= Method

/*
This chapter is about Engineering-related content, Methodologies, and Methods.
Use a self-explaining title.
The contents and structure of this chapter will change with your choice of methodology and methods.

Describe the engineering-related contents (preferably with models) and the research methodology and methods that are used in the degree project.
Give a theoretical description of the scientific or engineering methodology you are going to use and why have you chosen this method.
What other methods did you consider and why did you reject them? In this chapter, you describe what engineering-related and scientific skills you are going to apply, such as modeling, analyzing, developing, and evaluating engineering-related and scientific content.
The choice of these methods should be appropriate for the problem.
Additionally, you should be conscious of aspects relating to society and ethics (if applicable).
The choices should also reflect your goals and what you (or someone else) should be able to do as a result of your solution - which could not be done well before you started.

=== Validity and Reliability of methods
How will you know if your results are valid?
Remember that validity is about the accuracy of a measurement while reliability is about the consistency of the measurement values under t
he same conditions (i.e., repeatability).
*/

In this chapter, we detail the experiments conducted throughout this work.
First in @m:datasets, we introduce the datasets used in this work.
@m:framework details the framework developed to conduct the experiments in a fair and controlled environment.
Next, we present in @m:improvements the various adaptations proposed for @limnet to solve the task of link-prediction.
Finally, we discuss in @m:baselines exploration we conducted with the baselines.

== Datasets <m:datasets>

This project uses three publicly available datasets sourced from the Stanford Large Network Dataset Collection#footnote("Accessible at " + link("snap.stanford.edu/jodie/#datasets") + ".").
These datasets were originally compiled by Kumar et al. @jodie and have since become widely adopted as de facto standard benchmarks for evaluating interaction prediction models.

*- Wikipedia edits:*
This dataset captures edits made to Wikipedia pages over the course of one month.
It includes the 1,000 most edited pages during that period and 8,227 users who each made at least five edits to these pages.
In total, it contains 157,474 interactions.

*- Reddit posts:*
Built using a similar methodology as the Wikipedia dataset, this dataset records 672,447 posts made by the 10,000 most active users on the 1,000 most active subreddits within a month.

*- LastFM songs listens:*
This dataset logs 1,293,103 music streams performed by 1,000 users on the 1,000 most listened-to songs on the LastFM platform, again over the span of one month.

The original dataset publication also included a fourth dataset containing interactions between 7,047 students and 97 courses on a MOOC platform.
However, we excluded this dataset from our experiments, as it does not reflect a relevant use case for interaction prediction.
Users on MOOC platforms typically have a clear intent when accessing the platform, which diminishes the predictive value of interaction modeling in this context.

#figure(
  table(
    columns: 4,
    align: (left, center, center, center),
    table.hline(),
    table.header([], [Wikipedia], [Reddit], [LastFM]),
    table.hline(stroke: 0.05em),
    [Users], [8,227], [10,000], [1,000],
    [Items], [1,000], [1,000], [1,000],
    [Interactions], [157,474], [672,447], [1,293,103],
    [Unique edges], [18,257], [78,516], [154,993],
    table.hline(),
  ),
  caption: [Details of the datasets.],
  placement: auto,
) <table:datasets>

@table:datasets summarizes the key characteristics of the three selected datasets.
While Wikipedia and Reddit have comparable numbers of users and items, Reddit is significantly denser, with roughly four times more interactions.
LastFM is denser still, with nearly 20 times the interaction density of Reddit.
Notably, LastFM also exhibits a perfectly balanced user-to-item ratio, in contrast to the other two datasets.

== Experimental framework <m:framework>

Evaluating embedding models is inherently complex due to the variety of input and output formats, as well as the diversity of training and inference procedures.
Despite these differences, a fair and consistent evaluation across models must be ensured.

This complexity is further amplified in the case of temporal graphs, which can be interpreted in multiple ways depending on the structural and temporal aspects one wishes to emphasize.
A temporal graph may be decomposed into a sequence of static snapshots taken at regular intervals, represented as a continuous time series of events, or treated as a dynamic structure where nodes and edges evolve over time @survey-dynamic-gnn/* More reference needed */.
These different interpretations offer varied trade-offs in terms of temporal resolution, scalability, expressiveness, and design opportunities, without any single approach being universally optimal.
Our implementation is publicly available on GitHub #footnote("https://github.com/mazerti/link-prediction").

The following subsections describe the design choices that guided the development of our evaluation framework.
These are organized into four key components: data preparation, batching strategy, evaluation and training loop, and embedding comparison.

=== Data preparation <m:inputs>

Each recorded interaction in the datasets provides three types of information: the identifiers of the interacting user and item, the timestamp of the interaction, and a set of optional features that offer additional context.
In most cases, the evaluated models rely primarily on the user and item identifiers, along with the implicit temporal order of the interactions.
As such, the framework consistently supplies user and item IDs in the exact sequence in which the interactions occur.

The framework also supports the inclusion of custom features in the input.
These features can be specified either by the user through a configuration file or automatically requested by the model implementation during initialization.
This flexibility ensures that models requiring specific features can be seamlessly integrated without manual intervention.
Time-related features, in particular, benefit from this design.
For example, some models use the time delta between successive interactions by the same user.
While calculating this value at inference time would be computationally expensive, as it requires real-time tracking of each user's previous interactions, it can be efficiently pre-computed when the full interaction history is available, reducing it to a straightforward query operation.

=== Batching Strategy <m:batching>

Temporal interaction modeling inherently involves a tradeoff between preserving the sequential nature of data and maximizing training efficiency through parallelism.
As highlighted in prior work @jodie @deepred, maintaining causality often comes at the cost of reduced parallelization capabilities.
In the JODIE model, Kumar et al. addressed this by designing a graph-structure-aware batching strategy that retains temporal coherence while enabling some degree of parallel processing @jodie.
Meanwhile, Kefato et al. proposed an alternative in DeePRed by eliminating recursion entirely, replacing dynamic embeddings with static approximations to simplify training @deepred.

Drawing inspiration from the original @limnet framework @article:limnet, we adopt a different approach: slicing the dataset into fixed-size sequences.
The rationale is that sufficiently long sequences can serve as a reasonable approximation of the full interaction history.
Each individual sequence is processed in temporal order, thereby preserving internal causal structure.
However, because sequences are independent of one another, they can be processed in parallel, significantly accelerating training.

This strategy offers a practical compromise.
It enables the model to learn from temporally ordered data without incurring the full computational burden of processing the entire dataset sequentially.
Moreover, it allows for flexibility in choosing the sequence length, which can be tuned to balance modeling capacity and computational efficiency.
In our experiments, we found that shorter sequences often performed comparably well, suggesting that most relevant predictive signals are contained in recent interaction history.

=== Evaluation and Training loop <m:processing>

#figure(
  image("../../../../figures/framework-diagram.svg"),
  caption: "Schema of the evaluation framework. Blue indicates that the implementation is tight to the model evaluated.",
  placement: auto,
) <fig:framework-architecture>

Designing a framework that accommodates any model for a given task is inherently challenging, as different models are often developed based on varying problem formulations.
One major difference lies in the structure of the inputs.
As discussed in @m:inputs, the framework addresses this by leveraging input features to bridge discrepancies between models.
Another key distinction involves the nature of the outputs.
Although all models ultimately aim to identify relevant items, they approach this goal in different ways.
In the context of interaction prediction, predictions can be generated by computing embeddings to be compared, by directly scoring items, or by estimating the likelihood of future user-item interactions.

This framework solely addresses the model creating user and item embeddings, simplifying the evaluation process and allowing it to be performed independently of the model that generates them.
However, all training and loss evaluation logic is encapsulated within the model implementations.
This approach allows for diverse optimization strategies, including loss functions that depend on a model's internal memory state rather than exclusively on its outputs.
These design choices are reflected in the framework architecture diagram presented in @fig:framework-architecture.

=== Embedding comparison <m:outputs>

The final challenge in the implementation concerns the use of embeddings.
While embeddings are created to condense and represent interaction information, they are not the system's ultimate objective.
The actual goal is to rank items for a given user such that the item with which the user will interact appears as high as possible on the list.

There are several ways to translate embeddings into rankings.
Since this is not the central focus of the current work, we adopt a straightforward approach: ranking item embeddings based on their proximity to the user embedding.
To accommodate the diversity of models tested, the framework supports two proximity metrics.

The first is the dot product of normalized embeddings, which is equivalent to the cosine similarity between vectors:

$
  "dot_product_score"(bold(e)^"user",bold(e)^"item") = bold(e)^"user" / norm(bold(e)^"user") dot bold(e)^"item" / norm(bold(e)^"item")
$ <eq:dot-product-score>

A higher dot-product score indicates that the item embedding is more closely aligned with the user embedding, and thus should be ranked higher.

The second metric is the L2 distance, a generalization of Euclidean distance to $k$-dimensional space:

$ "L2_score"(bold(e)^"user", bold(e)^"item") = root(k, norm(bold(e)^"user" - bold(e)^"item")^k) $

For this score, smaller values correspond to closer embeddings and are therefore ranked higher.

In all experiments conducted in this work, performance is measured using both scoring methods.
The highest result obtained between the two is reported to ensure fair evaluation across models.

=== Code Reusability <m:code-quality>

In exploratory research projects like this one, writing the entire codebase from scratch can be advantageous.
This approach eliminates the burden of dependency management, avoids the need to thoroughly understand legacy implementations, and frees the researcher from conforming to existing frameworks.
Building from the ground up also allows for alternative perspectives on the task at hand and allows researchers to concentrate on challenges arising from novel aspects of the work.
However, the ability to reproduce experiments and to reuse existing models, either as baselines or as foundations for further development, remains critically important, it would thus be inappropriate to write such a framework without having future researchers in mind.

To balance these needs, the framework has been designed with clarity, reproducibility, and extensibility in mind.
Three principles have guided its development: comprehensive documentation, centralized state management, and a functional programming approach.
Every function in the framework is systematically documented /*#footnote("Due to time constraints, the code quality deteriorated a bit during the last steps of the projects, leading to some undocumented functions.")*/ to help future researchers quickly grasp the implementation, whether to reuse the code or replicate its behavior in a new context.

To further streamline usability, state management has been centralized in a single component: the Context class.
This class acts as a unified store for all stateful elements of the framework, ensuring that any part of the system can access necessary state variables with minimal effort.

In addition, the framework adheres to a functional programming-inspired style, favoring pure functions wherever possible for their conceptual simplicity and consistency.
While this approach enhances readability and modularity, certain components, most notably the PyTorch modules, had to follow an object-oriented structure due to the requirements of external libraries.

This balance between clean design and practical flexibility ensures that the framework is easy to understand for future experiments.

== Adaptations of the @limnet architecture <m:improvements>

The primary goal of this work is to evaluate the performance of the @limnet model on the link prediction task.
As discussed in @bg:limnet, the original implementation of @limnet includes input and output mapping layers, as well as a response layer specifically designed for IoT botnet detection.
For our purposes, these components were removed to better align the model with the requirements of interaction prediction.

=== Loss functions <m:lossses>

The loss function also required adaptation.
Unlike botnet detection, link prediction is not a classification task, making the original cross-entropy loss unsuitable.
Instead, we opted for a composite loss combining two components.

The first is an objective loss that minimizes the distance between the embeddings of interacting users and items.
This can be computed either as the mean squared error between the embeddings of the interacting user and item or, when embeddings are normalized, as the squared difference between their dot product and 1 (more on this in @m:normalize).

However, the objective loss alone is insufficient to train the model effectively.
Neural networks tend to converge to trivial solutions if not properly constrained; in this case, minimizing only the distance between embeddings would eventually cause all embeddings to collapse to the same value.
To mitigate this, we introduce a regularization loss that promotes information retention by maximizing the distance between different users' embeddings and between different items' embeddings.

This regularization loss is computed as:

$ L_"reg" = bold(U) bold(U)^T + bold(I)bold(I)^T $

where $bold(U)$ and $bold(I)$ are the matrices containing all user and item embeddings, respectively.

In addition to simplifying the architecture and adapting the loss function, we propose three modifications aimed at enhancing the model's performance: the addition of time features, embedding normalization, and the stacking of multiple @limnet layers.

=== Addition of time features <m:time-features>

While @limnet leverages the order of interactions to propagate information in a causal manner, it does not incorporate actual timestamps when computing embeddings.
We hypothesized that this omission could lead to a loss of valuable temporal information that might otherwise help in predicting the most relevant items.
To test this assumption, we introduced time-based features aimed at capturing when each interaction occurred.
Specifically, we sought to model cyclic behavioral patterns such as differences in user activity between weekdays and weekends, or between day and night.

However, our datasets only include relative timestamps, which obscure the exact timing of interactions.
As a workaround, we approximated cyclic patterns by applying a frequency decomposition to the timestamps.
We computed two features to represent temporal cycles:

$ cos((2 pi t) / Delta), sin((2 pi t) / Delta) $

where $t$ is the timestamp of the interaction, and $Delta$ is the duration of the pattern to be captured (e.g., one day or one week) expressed in the timestamp's time unit.
This representation aims to provide the model with a more learnable form of temporal information, as machine learning models often struggle to extract patterns from raw one-dimensional values.

=== Embedding normalization <m:normalize>

An efficient approach to computing dot-product scores (see @eq:dot-product-score) is to normalize all embeddings onto the unit sphere.
In our implementation, we extended this normalization to include the embeddings stored in @limnet's memory.
By ensuring that inputs to the cross-RNN mechanism are also normalized, we encourage the model to encode information primarily through angular relationships rather than magnitude.

This normalization has additional benefits.
While the regularization loss is designed to prevent all embeddings from converging to the same direction, it does not explicitly prevent them from collapsing to zero.
Since embeddings with a magnitude of zero are still orthogonal, they technically satisfy the regularization condition.
Maintaining normalization throughout the network guards against this collapse by constraining all embeddings to lie on the surface of the unit sphere.

Our experiments showed a significant performance improvement with normalized embeddings.
As a result, this modification was adopted as the default setting for all @limnet -based experiments in this project.

=== Stacking of multiple @limnet layers <m:stacking>

#figure(
  image("../../../../figures/limnet-multi-layer-architecture.svg"),
  caption: "Architecture of " + gls("limnet") + "with two layers.",
  placement: auto,
) <fig:multi-layer-limnet>

The final adaptation we explored involved stacking multiple layers of the @limnet architecture to form a deep recurrent neural network.
This hierarchical design enhances the model's representational capacity by allowing it to learn progressively more abstract features across layers.
@fig:multi-layer-limnet illustrates the structure of the extended model.

To introduce non-linearity and further boost the expressiveness of the network, leaky ReLU activation functions were inserted between each pair of layers.
This design choice aims to help the model capture more complex patterns in user-item interactions.

== Baseline <m:baselines>

We evaluated the performance of @limnet against Jodie, a state-of-the-art cross-RNN model for learning embeddings in temporal interaction networks.
We also attempted to implement DeePRed @deepred, but were unable to reproduce the performance reported in the original paper.
As a result, DeePRed was excluded from our experimental comparisons.

Jodie, described in @jodie, shares the foundational use of cross-RNN embeddings with @limnet but differs in three important ways.
First, Jodie enhances its dynamic embeddings with one-hot representations of users and items to form the final embedding vectors.
Second, it incorporates time deltas between consecutive user interactions via a projection mechanism designed to anticipate the trajectory of embeddings.
Third, the model employs a specialized loss function to ensure that user and item embeddings do not shift too drastically in response to a single interaction.

Our implementation of Jodie differs from the original in two respects.
We replaced the t-batch algorithm, used for creating training batches in the original paper, with fixed-length interaction sequences and omitted interaction features for the sake of simplicity.
While Jodie does not require re-training to incorporate new interactions, it lacks @limnet's ability to dynamically handle the insertion or deletion of users and items.

These distinctions make Jodie a strong and informative baseline for evaluating @limnet's generalization to user-item interaction prediction tasks.
