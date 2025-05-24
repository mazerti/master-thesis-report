#import "@preview/glossarium:0.5.4": gls, glspl
= Method

/*

This chapter is about Engineering-related content, Methodologies and Methods.
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

// --- Start of actual writing ---

In this chapter, we detail the experiments conducted throughout this work.
First in @m:datasets, we introduce the datasets used in this work.
@m:framework details the framework developed to conduct the experiments in a fair and controlled environment.
Next, we present in @m:improvements the various adaptations proposed for @limnet to solve the task of link-prediction.
Finally, we discuss in @m:baselines exploration we conducted with the baselines.

== Datasets <m:datasets>

We use three public datasets in this project, all directly taken from the Stanford Large Network Dataset Collection (accessible at #link("snap.stanford.edu/jodie/#datasets")).
More specifically, these datasets were created by Kefato et al. in @jodie and have been reused a large number of times since then, to the extent that they have become de facto standard benchmarks for interaction network predictions.

*- Wikipedia edits:*
This dataset gathers edits on Wikipedia pages over the course of a month.
It is made of the 1,000 most edited pages during the month and the 8,227 users that edited at least 5 time any of these pages.
In total, the dataset records 157,474 edits.

*- Reddit posts:*
This dataset was built in a similar fashion to the Wikipedia dataset.
It comprises posts on the 1,000 most active subreddits, published by the 10,000 most active users over the course of a month.
In total, this dataset records 672,447 interactions.

*- Reddit LastFM songs listens:*
This dataset records music streams of the 1,000 most listened songs on the LastFM website.
These streams are performed by 1,000 users throughout one month, and results in 1,293,103 total interactions.

The initial publication also included another dataset compiling user interaction with massive online open courses (MOOC).
However, we decided to set it aside because it contained too few data points to work with: only a couple interaction per users in average.

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

The @table:datasets summarizes the characteristics of the datasets.
We can see that the main difference between the Wikipedia and the Reddit datasets is the density.
They both have similar number of users and items but in Reddit there are about four times more connections between them than in Wikipedia.
In LastFM the density is almost 20 times higher compared with Reddit, note also that the balance between users and items is perfectly respected, compared with the two other datasets.

== Experimental framework <m:framework>

Evaluating embedding models is a complex task because it requires to accommodate for a wide variety of inputs and outputs shapes, along with diverse training and inference procedures, while still ensuring the fairness of the evaluation between the different methods.

This complexity blooms with temporal graphs because there are different ways to approach them.
One model can be approaching a temporal graph as a series of static graphs, another one can approach it as a time series @survey-dynamic-gnn /*It's weird to have only one citation here, none may be better.*/, and yet another one could try to maintain a dynamical representation of the graph on the fly.
None of these approaches is inherently better or worse than the others and they can all open up for different design opportunities.

The implementation we came up with is publicly available on GitHub under the following link: #link("https://github.com/mazerti/link-prediction").

In this section, we will precise the design decisions that led to our final evaluation framework.
We grouped these decisions into four categories: Preparation of the data, Batching strategy, Training and evaluation loops, and comparison of the embeddings.

=== Preparation of the data <m:inputs>

The datasets provide us with three types of information for each recorded interaction: the identifiers of the interacting user and item, the timestamp at which the interaction took place and a set of features providing additional information about the interaction.
Most of the time, the models tested use only the identifiers and the implicit order of the interaction.
Thus the framework will always provide as inputs the ids of the user and item interacting in the order the interactions happen.

In addition, the framework can add features to the inputs.
These features can be requested either by the user through the configuration file, or directly by the model's implementation during the model's initialization.
This second option allows to seamlessly add models relying on custom features without the requirement to manually request the features each time the model is used.
This is especially relevant for time information, because each model can have a different use of the timestamps.
A common usage is to use the time delta between successive interactions of a same user.
This information would be expensive to compute at inference because it would require to keep track of the timestamp of the last interaction each user have performed at any time step.
Pre-computing it as a feature on the other hand is much more convenient because we have access to all the interactions at once and computing time deltas results in a simple query operation.

=== Batching Strategy <m:batching>

As pointed out by previous work @jodie @deepred temporal interaction comes with a tradeoff regarding the ability to leverage parallelism for training.
Kumar et al. proposed for their model JODIE an elaborate batching strategy based on the structure of the graph @jodie, and Kefato et al. removed the recursions from their model DeePRed by approximating the dynamic embeddings with static ones @deepred.

Inspired by the original @limnet proposition @article:limnet, we decided instead to slice the data into sequences of fixed size.
The idea is that big enough sequences could be good enough approximation of the actual sequence of all the interactions.
While each sequence still require to be processed in order, several sequences can however be processed in parallel, speeding up the training.

=== Training and evaluation loops <m:processing>

The on-demand feature preparation discussed in @m:inputs ensures that each model can access the inputs that it requires, unfortunately the models outputs also presents structural discrepancies.
Since this work's scope is limited to embedding models, all model's outputs should be fixed size embeddings for either users or items, some models, though, come with their own loss functions based on internal states.
Accessing the right outputs to compute either the loss function or the metrics from the embeddings is therefore not something that can be managed identically for all models.

Because of this limitation, we took the decision to tie the evaluation logic of the models with the models implementations.
This include going over a batch of interaction sequences, running the predictions, computing the loss, back propagation, updating the model memories, and producing measurable embeddings.
However, we made sure to standardize all measures with fixed functions designed independently from the models with a sole purpose of measuring embeddings for the task of link prediction.
In addition, the training and evaluation loops are managed in a unified way, limiting the risks of bugs to occur due to errors in code reproduction.
These loops include going over the batches, reporting the results, and iterating over the epochs,

=== Comparison of the embeddings <m:outputs>

The last challenge in the implementation concerns the embeddings.
While we want to create embeddings to synthesize the information, it is not the actual end goal of the system.
The end goal is to rank the items for a given user, and, if the model is performant, to rank the item that will interact with the user high on the list.
There are several ways to convert the embeddings into ranking, because this is not the focus of this work, we decided to use a simple approach: we rank the item embeddings based on their proximity with the user embedding.
We did however consider two separate approaches to compute the proximity between embeddings to best accommodate the diversity of models tested.

The first one is computed as the dot product of the normalized embeddings, which is equivalent to the cosine of the angle formed by the two embeddings with the origin of the embedding space.
$
  "dot_product_score"(bold(e)^"user",bold(e)^"item") = bold(e)^"user" / norm(bold(e)^"user") dot bold(e)^"item" / norm(bold(e)^"item")
$ <eq:dot-product-score>
The higher the dot-product score between an item embedding, and the target user embedding, the closer these embeddings will be, therefore, the item should be ranked higher for that user.

The second proximity used is the L2 distance, a generalization of geometric distance to $k$-dimensional spaces.
$ "L2_score"(bold(e)^"user", bold(e)^"item") = root(k, norm(bold(e)^"user" - bold(e)^"item")^k) $
For this score, lower values will indicate closer embeddings and be ranked higher.

For all our experiments, we measure the performances with both scoring methods and report the highest measured value among the two.

=== Code maintainability <m:maintainability>

For exploratory research projects such as this one, it could be beneficial to write the whole codebase from scratch rather than re-use an existing codebase.
Doing so removes from the research process the cruft of dependencies management, the need to understand the detail of the implementation as well as the necessity to comply with a previous framework.
Starting from scratch also allow to approach problems from a different angle, and generally let the researcher focus on challenges emerging from the novelty.
However, it is crucial to be able to reproduce experiments and to re-use existing models that can be used as baselines or as base for further developments.

Thus, this framework has been developed with the goal of being easy to understand and either build upon or reproduce.
To reach this goal, two lines have been followed through the development process: thorough documentation and functional approach.
The systematic documentations of every function in the framework should be able to help future researchers to understand the details of the implementation faster, whether it is for reusing it or to reproduce its behavior in a new experimental context.
With the same goal of simplicity of understanding, the state have also been gathered as much as possible into a single location: the ```python Context``` class.
This class acts as a simple store for all stateful parts of the framework, making them never more than one variable away, wherever it is called from.
In addition the framework has been written in a functional aspiring style, always favoring pure functions for their conceptual simplicity and consistency.
Unfortunately this functional approach couldn't be applied on every part of the program, notable exceptions are the PyTorch modules that had to be implemented in an object oriented way to accommodate PyTorch's framework.

== Adaptations of the @limnet architecture <m:improvements>

This work's primary goal was to test how the @limnet model would perform for the link-prediction task.
However, as discussed in @bg:limnet, the implementation we use is stripped down of it's inputs and outputs maps, as well as the response layer used in the original paper to fit the specific needs of the task of IoT botnet detection.

=== Loss functions <m:lossses>

We also had to adapt the loss used to train @limnet, because, unlike botnet detection, link-prediction isn't a classification setting, so we couldn't use cross entropy Loss as the original model did.
Instead we decided to use a mix of two losses.
The first is an objective loss to minimize the distance between the embedding of the interacting user and item, it is calculated using the mean squared error for the embeddings or their dot product to 1.
And the second is a regularization loss to maximize the information retention by maximizing the distance between different users and between different items.
This loss is computed as follow:
$ L_"reg" = bold(U) bold(U)^T + bold(I)bold(I)^T $
Where $bold(U)$ and $bold(I)$ are respectively the matrix containing all the users embeddings and the matrix containing all the items embeddings.

In addition of this simplification, we proposed three separate modifications to enhance the model: adding time features, normalizing the embeddings and stacking several @limnet layers.

=== Addition of time features <m:time-features>

While @limnet takes advantage of the order of the interaction to propagate information in a causal way, it doesn't use the actual timestamps to compute the embeddings.
One of our assumption was that this would lead to a loss of relevant information that could otherwise have been useful to predict the best item.
In order to check that assumption, we created time features to provide the model with information about when the interaction happen.
We specifically intended to capture cyclic patterns in the user behaviors such as week/weekend or day/night differences in behaviors.

Unfortunately, our datasets only provide relative timestamps that obfuscated the exact time and day of the interactions, so we had to approximate these patterns by using a frequency decomposition of the timestamps.
Specifically, we use the two following features to capture a temporal pattern:

$ cos((2 pi) / Delta t), sin((2pi) / Delta t) $

Where $t$ is the timestamp of the interaction, and $Delta$ is the duration of the pattern we want to capture (a day or a week) in the unit of the timestamps.
This aims at providing the model with a time representation that is more compatible with its machine learning components, that tend to fail to extract patterns from one dimensional values.

=== Normalization of the embeddings <m:normalize>

An efficient way to compute the dot-product scores (@eq:dot-product-score) is to normalize all the embeddings to the unit sphere.
While doing this, we realized that it could also be applied to the embeddings in @limnet's memory, this way, the cross-RNN mechanism is also fed with normalized embeddings as inputs.
Our hopes were that this way the model would be more focused on encoding information through the angles between the embeddings rather than through their amplitudes.

Another benefit of this method is that it prevents the embeddings to collapse to 0.
While the regularization loss is meant to prevent embeddings to converge all to the same value, it actually only makes sure that the embeddings are not aligned, therefore, 0 remains a potential convergence point.
Keeping the embeddings normalized at any time is thus a good solution to this issue.

Our experiments yielded significantly better results with embeddings normalization, so we decided to use this modification by default for all the experiments conducted with @limnet on this project.

=== Stacking several @limnet layers <m:stacking>

The last improvement to @limnet that we have tried was to stack several layers of the @limnet architecture on top of each other, effectively turning it into a deep recurrent neural network.
@fig:multi-layer-limnet illustrate the architecture of this new model.
The leaky ReLU functions inserted between each layers aims to add non-linearity and increase the expressiveness of the model.

#figure(
  image("../../../../figures/limnet-multi-layer-architecture.svg"),
  caption: "Architecture of " + gls("limnet") + "with two layers.",
  placement: auto,
) <fig:multi-layer-limnet>

== Baselines <m:baselines>

We evaluated the performances of @limnet against 2 other baselines: static embeddings and Jodie.

We trained static embeddings for each user and item, with the same loss functions that we described in @m:lossses for @limnet.
This baseline is oblivious to the relational and temporal information contained in the data.
It is also inconvenient to deploy for real world application because it requires to be entirely re-trained to account for any new information such as new interactions, new users, or new items.

The other baseline Jodie is described in @jodie, it is build upon the same core of cross-RNN embeddings than @limnet but present three major differences.
First, in addition to the cross-RNN dynamic embeddings, Jodie uses one-hot representations of the users and items to create the final embeddings.
Secondly, Jodie exploits the time delta between two interaction of a user throughout a projection operation that tries to anticipate the embeddings' trajectory.
Lastly, the model is trained with a dedicated loss function that ensure that the embeddings won't change too radically as a consequence of an interaction.

We identified two differences between our implementation of Jodie and the original proposition, the absence of the t-batch algorithm, replaced by fixed-length sequences and the absence of interaction features, ignored for simplicity.
Compared with the static embeddings, Jodie doesn't need to be re-trained to acknowledge new interactions, but it still can't deal dynamically with user or item insertion or deletions.
