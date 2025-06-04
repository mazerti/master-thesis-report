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

This project uses three publicly available datasets sourced from the Stanford Large Network Dataset Collection (accessible at #link("snap.stanford.edu/jodie/#datasets")).
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

Our implementation is publicly available on GitHub at: #link("https://github.com/mazerti/link-prediction").

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

Designing a framework that fits any model for a given task is a very challenging task, because the models have been designed with different formulations of the problems in mind.
A first significant difference concerns the forms of the inputs, as explained in @m:inputs, the framework takes the decision to use the features to accommodate with these discrepancies.
A second source of difference concerns the outputs, because the models are designed to solve the overarching problem of finding relevant items and may get there through different means.
In the case of interaction prediction, the prediction can be made by computing embeddings that need to be compared, by directly predicting scores for each items, or even by computing the likelihood of the items to be interacted with.

This framework focuses on embedding creation, thus it only suits models that are computing user and item embeddings, evaluating their quality independently of the model producing them.
However, all the logic regarding the training and loss evaluation is tied to the models implementation to leave space for different approaches.
That is especially helpful to design loss functions that depends on the internal state of the model's memory rather than solely on its outputs.
These design decisions can be identified in the framework architecture diagram shown in @fig:framework-architecture.

=== Embedding comparison <m:outputs>

The last challenge in the implementation concerns the embeddings.
While we want to create embeddings to synthesize the information, it is not the actual end goal of the system.
The end goal is to rank the items for a given user, and, if the model is performant, to rank the item that will interact with the user high on the list.
There are several ways to convert the embeddings into a ranking.
Because this is not the focus of this work, we decided to use a simple approach: we rank the item embeddings based on their proximity to the user embedding.
The framework, however, uses two separate approaches to compute the proximity between embeddings to best accommodate the diversity of models tested.

The first one is computed as the dot product of the normalized embeddings, which is equivalent to the cosine of the angle formed by the two embeddings with the origin of the embedding space.
$
  "dot_product_score"(bold(e)^"user",bold(e)^"item") = bold(e)^"user" / norm(bold(e)^"user") dot bold(e)^"item" / norm(bold(e)^"item")
$ <eq:dot-product-score>
The higher the dot-product score between an item embedding and the target user embedding, the closer these embeddings will be, therefore, the item should be ranked higher for that user.

The second proximity used is the L2 distance, a generalization of geometric distance to $k$-dimensional spaces.
$ "L2_score"(bold(e)^"user", bold(e)^"item") = root(k, norm(bold(e)^"user" - bold(e)^"item")^k) $
For this score, lower values will indicate closer embeddings and be ranked higher.

For all experiments in the present work, the performances are measured with both scoring methods, and only the highest measured value among the two is reported.

=== Code maintainability <m:maintainability>

For exploratory research projects such as this one, it could be beneficial to write the whole codebase from scratch rather than reusing an existing codebase.
Doing so removes from the research process the cruft of dependency management, the need to understand the details of the implementation, as well as the necessity to comply with a previous framework.
Starting from scratch also allows to approach problems from a different angle, and generally lets the researcher focus on challenges emerging from the novelty.
However, it is crucial to be able to reproduce experiments and to re-use existing models that can be used as baselines or as a base for further developments.

Thus, this framework has been developed to be easy to understand and either build upon or reproduce.
To reach this goal, two lines have been followed through the development process: thorough documentation and a functional programming approach.
The systematic documentation of every function in the framework should help future researchers understand the details of the implementation faster, either for reusing it or to reproduce its behavior in a new experimental context.
With the same goal of simplicity of understanding, the state has also been gathered as much as possible into a single location: the ```python Context``` class.
This class acts as a simple store for all stateful parts of the framework, making them never more than one variable away, wherever it is called from.
In addition, the framework has been written following a functional programming-inspired style, always favoring pure functions for their conceptual simplicity and consistency.
Unfortunately, this functional approach couldn't be applied to every part of the program, notable exceptions are the PyTorch modules that had to be implemented in an object-oriented way to accommodate PyTorch's framework.

== Adaptations of the @limnet architecture <m:improvements>

This work's primary goal was to test how the @limnet model would perform for the link-prediction task.
However, as discussed in @bg:limnet, the implementation we use is stripped down of its input and output maps, as well as the response layer used in the original paper to fit the specific needs of the task of IoT botnet detection.

=== Loss functions <m:lossses>

We also had to adapt the loss used to train @limnet, because, unlike botnet detection, link-prediction isn't a classification setting, so we couldn't use cross-entropy Loss as the original model did.
Instead, we decided to use a mix of two losses.
The first is an objective loss to minimize the distance between the embedding of the interacting user and item, which is calculated using the mean squared error for the embeddings, or their dot product to 1 when the embeddings are normalized (see @m:normalize).
The objective loss does not suffices to train the model, because neural networks are lazy, using only the distance between the embeddings would lead all embeddings to eventually collapse to the same value.
To evade this, a regularization loss is added to the objective loss.
That loss aims to maximize the information retention over all the embeddings by maximizing the distance between different users and between different items.
This second loss is computed as follows:
$ L_"reg" = bold(U) bold(U)^T + bold(I)bold(I)^T $
Where $bold(U)$ and $bold(I)$ are respectively the matrix containing all the users' embeddings and the matrix containing all the items' embeddings.

In addition to simplifying the architecture and adapting the loss, we proposed three modifications to enhance the model: adding time features, normalizing the embeddings, and stacking several @limnet layers.

=== Addition of time features <m:time-features>

While @limnet takes advantage of the order of the interaction to propagate information in a causal way, it doesn't use the actual timestamps to compute the embeddings.
One of our assumptions was that this would lead to a loss of relevant information that could otherwise have been useful to predict the best item.
In order to check that assumption, we created time features to provide the model with information about when the interaction happened.
We specifically intended to capture cyclic patterns in the user behaviors, such as week/weekend or day/night differences in behaviors.

Unfortunately, our datasets only provide relative timestamps that obfuscate the exact time and day of the interactions, so we had to approximate these patterns by using a frequency decomposition of the timestamps.
Specifically, we use the following two features to capture a temporal pattern:

$ cos((2 pi) / Delta t), sin((2pi) / Delta t) $

Where $t$ is the timestamp of the interaction, and $Delta$ is the duration of the pattern we want to capture (a day or a week) in the unit of the timestamps.
This aims at providing the model with a time representation that is more compatible with its machine learning components, which tend to fail to extract patterns from one-dimensional values.

=== Normalization of the embeddings <m:normalize>

An efficient way to compute the dot-product scores (@eq:dot-product-score) is to normalize all the embeddings to the unit sphere.
While doing this, we realized that it could also be applied to the embeddings in @limnet's memory.
This way, the cross-RNN mechanism is also fed with normalized embeddings as inputs.
Our hopes were that this way, the model would be more focused on encoding information through the angles between the embeddings rather than through their amplitudes.

Another benefit of this method is that it prevents the embeddings from collapsing to 0.
While the regularization loss is meant to prevent embeddings from all converging to the same value, it actually only makes sure that the embeddings are not aligned, therefore, 0 remains a potential convergence point.
Keeping the embeddings normalized at any time is thus a good solution to this issue.

Our experiments yielded significantly better results with embedding normalization, so we decided to use this modification by default for all the experiments conducted with @limnet on this project.

=== Stacking several @limnet layers <m:stacking>

The last improvement to @limnet that we have tried was to stack several layers of the @limnet architecture on top of each other, effectively turning it into a deep recurrent neural network.
@fig:multi-layer-limnet illustrates the architecture of this new model.
The leaky ReLU functions inserted between each layer aim to add non-linearity and increase the expressiveness of the model.

#figure(
  image("../../../../figures/limnet-multi-layer-architecture.svg"),
  caption: "Architecture of " + gls("limnet") + "with two layers.",
  placement: auto,
) <fig:multi-layer-limnet>

== Baselines <m:baselines>

We evaluated the performance of @limnet against 2 other baselines: static embeddings and Jodie.

We trained static embeddings for each user and item, with the same loss functions that we described in @m:lossses for @limnet.
This baseline is oblivious to the relational and temporal information contained in the data.
It is also inconvenient to deploy for real real-world application because it requires being entirely re-trained to account for any new information, such as new interactions, new users, or new items.

The other baseline, Jodie, described in @jodie, is built upon the same core of cross-RNN embeddings as @limnet, but presents three major differences.
First, in addition to the cross-RNN dynamic embeddings, Jodie uses one-hot representations of the users and items to create the final embeddings.
Secondly, Jodie exploits the time delta between two interactions of a user throughout a projection operation that tries to anticipate the embeddings' trajectory.
Lastly, the model is trained with a dedicated loss function that ensures that the embeddings won't change too radically as a consequence of an interaction.

We identified two differences between our implementation of Jodie and the original proposition: the absence of the t-batch algorithm, replaced by fixed-length sequences, and the absence of interaction features, ignored for simplicity.
Compared with the static embeddings, Jodie doesn't need to be re-trained to acknowledge new interactions, but it still can't deal dynamically with user or item insertion or deletions.
