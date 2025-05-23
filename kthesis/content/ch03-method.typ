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
More specifically, these datasets were created by Kefato et al. in @jodie and have been reused a large number of time since then, to the point that they became informal standard benchmarks for interaction network predictions.

*- Wikipedia edits:*
This dataset gathers edits on Wikipedia pages over the course of a month.
It is made of the 1,000 most edited pages during the month and the 8,227 users that edited at least 5 time any of these pages.
In total, the dataset records 157,474 edits.

*- Reddit posts:*
This dataset was built in a similar fashion than the Wikipedia dataset.
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
) <table:datasets>

The @table:datasets summarizes the characteristics of the datasets.
We can see that the main difference between the Wikipedia and the Reddit datasets is the density.
They both have similar number of users and items but in Reddit there are about four times more connections between them than in Wikipedia.
In LastFM the density is almost 20 times higher compared with Reddit, and the balance between users and items is also 10 time better.
LastFM is therefore not only a bigger dataset but also a more challenging one to work with.

== Experimental framework <m:framework>

Evaluating embedding models is a complex task because it requires to accommodate for a wide variety of inputs and outputs shapes, along with diverse training and inference procedures, while still ensuring the fairness of the evaluation between the different methods.

This complexity blooms with temporal graphs because there are different ways to approach them.
One model can be approaching a temporal graph as a series of static graphs, another one can approach it as a time series @survey-dynamic-gnn, and yet another one could try to maintain a dynamical representation of the graph on the fly.
None of this approach is inherently better or worse and they can all open different design opportunities.

In this section, we will precise the design decisions that led to our final evaluation framework.
The implementation we came up with is publicly available at the following address: #link("https://github.com/mazerti/link-prediction").

These decisions are grouped in four categories: Preparation of the data, Batching strategy, Training and evaluation loops, and comparison of the embeddings.

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

As pointed out by previous work temporal interaction comes with a tradeoff regarding the ability to leverage parallelism for training.
Kumar et al. proposed for their model JODIE an elaborate batching strategy based on the structure of the graph @jodie, and Kefato et al. removed the recursions from their model DeePRed by approximating the dynamic embeddings with static ones @deepred.

Inspired by the original @limnet proposition @article:limnet, we decided instead to slice the data into sequences of fixed size.
The idea is that big enough sequences could be good enough approximation of the actual sequence of all the interactions.
While each sequence still require to be processed in order, several sequences can however be processed in parallel, speeding up the training.

=== Training and evaluation loops <m:processing>

The on-demand features preparation discussed in <m:inputs> ensures that each model can access the inputs that it requires, unfortunately the models outputs also presents structural discrepancies.
This work's scope is limited to embedding models, thus all model's outputs should be fixed size embeddings for either users or items.
Some models, however, come with their own loss functions based on internal states, accessing the right outputs to compute either the loss function or the metrics from the embeddings is thus not something that can be managed identically for all models.

Because of this limitation, we made the decision to tie the evaluation logic of the models with the models implementations.
This include going over a batch of interaction sequences, running the predictions, computing the loss, back propagation, updating the model memories, and producing measurable embeddings.
However, we made sure to standardize all measures with fixed functions designed independently from the models with a sole purpose of measuring embeddings for the task of link prediction.
In addition, we manage the training and evaluation loops in an unified way, limiting the risks of bugs due to errors in code reproduction.
These loops include going over the batches, reporting the results, and iterating over the epochs,

=== Comparison of the embeddings <m:outputs>

The next challenge in the implementation concerns the embeddings themselves.
While we want to create embeddings to synthesize the information, it is not the actual end goal of the system.
The end goal is to rank the items for a given user, and to rank the actual item the user will interact with high on the list.
There are several ways to convert the embeddings into ranking, because this is not the focus of this work, we decided to use the most simple approach: to think of embeddings as points in a high dimension space and to rank the items embeddings by proximity with the user embedding.
We did however consider two separate approaches to compute the proximity between embeddings.

The first one is to use the dot product of the normalized embeddings, which is equivalent to the cosine of the angle formed by the two embeddings with the origin of the embedding space.
$
  "dot_product_score"(bold(e)^"user",bold(e)^"item") = bold(e)^"user" / norm(bold(e)^"user") dot bold(e)^"item" / norm(bold(e)^"item")
$
The higher the dot-product score between the user and an item embeddings, the closer these embeddings will be and thus the item should be ranked higher for that user.

The second proximity used is the L2 distance, a generalization of geometric distance to $k$-dimensional spaces.
$ "L2_score"(bold(e)^"user", bold(e)^"item") = root(k, norm(bold(e)^"user" - bold(e)^"item")^k) $
For this score, lower values will indicate closer embeddings and be ranked higher.

For all our experiments, we measure the performances with both scoring methods and report the higher value.

=== Code maintainability <m:maintainability>

For exploratory research projects such as this one, it is more efficient to write the whole code base from scratch rather than re-use an existing code base, because it remove from the research process the cruft of dependencies management, the need to understand the detail of the implementation as well as the necessity to comply with the existing framework.
Getting rid of the existing also allow to approach problems from a different angle, and generally let the researcher focus on the novelty rather than the past.
However, it is crucial to be able to reproduce experiments and to re-use existing models that can be used as baselines or as base for further developments.

Thus, this framework has been developed with the goal of being easy to understand and either build upon or reproduce.
To reach this goal, two lines have been followed through the development process: thorough documentation and functional approach.

The systematic documentations of every function in the framework should be able to help future researchers to understand the 

Second though a thorough documentation targeted at helping future adaptations or re-implementations.
This also goes with a functional approach, pure functions being conceptually easier to understand than complex objects with distributed state.
Note however, that models required a more object-oriented approach to match PyTorch design.

== Adaptations to the @limnet architecture <m:improvements>

The first goal of this work was to test how the @limnet model would perform on a link-prediction task.
The implementation we used of @limnet is notably stripped down of it's inputs and outputs maps, as well as the response layer used in the original paper to fit the specific needs of the task of IoT botnet detection @article:limnet.

In addition of this simplification, we tried to enhance the model with three separate additions: adding time features, normalizing the embeddings and stacking several @limnet layers.

=== Addition of time features <m:time-features>

We made the assumption that user behaviors follow cyclic patterns.
Thus we tested if adding time features could improve the model.
We did not have access to explicit timestamps, so we went for a simple approach.
We computed time features as sine and cosine of the timestamp, with periods of a day and a week.

=== Normalization of the embeddings <m:normalize>

This second improvement was inspired by the use of cosine similarity to evaluate the similarity between user and item's embeddings.
cosine similarity only care about the angle between the embeddings.
normalizing the embeddings to the unit sphere thus appeared as an efficient way not to converge to 0 while also focusing the model on meaningful transformations.

=== Stacking several @limnet layers <m:stacking>

Lastly we wanted to see whether @limnet could be turned into a deep neural network.
Thus we tried the following architecture: *Schema needed*.
we used leaky relu as activation layers
Normalization is applied at every step.

== Exploration of the baselines <m:baselines>

We tried 2 baselines to compare with: static embeddings, and Jodie
We also tried DeePRed but couldn't reproduce the results.

Static embeddings consist of learning a static representation for each node.
Used as a simple baseline, but is oblivious to the temporal relationships.
Hard to apply to a real world system: need to be re-trained to account for each new interaction.

Jodie is conceptually close to LiMNet.
Has x major differences:
- Mixes dynamic embeddings with one-hot embeddings
- Uses a projection mechanism to account for time elapsed between interactions
- Uses a dedicated loss function
Our implementation is truthful to the paper except for the batching algorithm.
Jodie allows to dynamically account for new interactions in the network without re-training.
Jodie is not designed for node insertions/deletions.
