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

- we use Wikipedia, reddit, lastfm
- describe Datasets
- reddit is a bigger Wikipedia
- lastfm is on the next level of bigness

== Experimental framework <m:framework>

Evaluating embedding methods is challenging because it requires to accommodate for a wide variety of inputs and outputs shapes, along with diverse training and inference procedures, while still ensuring the fairness of the evaluation between the different methods.

This complexity blooms with temporal graphs because they can be approached as graphs, as time series, etc.
In this section, we will precise the design decisions that led us to our final implementation, available at: ...

These decisions are grouped in four categories: Preparation of the data, Batching strategy, Training and evaluation loops, and comparison of the embeddings.

=== Preparation of the data <m:inputs>
// might not need that subsection

The dataset provide us with three types of information for each recorded interaction: the identifiers of the interacting user and item, the timestamp at which the interaction took place and a set of features providing additional information about the interaction.
Most of the time, the model tested only use the identifiers and the implicit order of the interaction.
Whenever the time information is relevant to a model, the timestamp is used to compute custom features that are passed to the model in addition to the ids.

=== Batching Strategy <m:batching>

As pointed out by previous work /*@reference-needed*/ processing temporal interaction comes with a tradeoff regarding the ability to leverage parallelism for training.
Kumar et al. proposed for their model JODIE an elaborate batching strategy based on the structure of the graph @jodie, and Kefato et al. removed the recursions from their model DeePRed by approximating the dynamic embeddings with static ones @deepred.
Inspired by the original @limnet proposition @article:limnet, we decided instead to slice the data into sequences of fixed size with the argument that increasing the
We use fixed sequence length and process sequences in parallel, in batches of sequences.

=== Training and evaluation loops <m:processing>

We realized that there is no unified way of processing the internals of each method.
However, in order to conserve consistency, we make sure that each epoch is processed the same way.
Each model is responsible for its own training over a given batch of sequences.
Delivering the batches is managed by a common code.

=== Comparison of the embeddings <m:outputs>

challenge: not all models are intended to exploit the embeddings the same way.
example: l2 norm vs dot-product (cosine similarity)
what we do: require models to produce embeddings for all items and for the user (or predicted item) to compare with.
The scoring is done using both l2 and dot product, the better score is kept
scoring and ranking is done in a unified way.

=== Code maintainability <m:maintainability>

Reusing existing code in research is not very common as progress are usually encountered by using a different viewpoint that requires a different approach.
However, it is also important to reproduce experiments.
This code was written with the goal of being reusable, first by being as flexible as the scope of the project allowed it to be.
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
