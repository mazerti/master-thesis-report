#import "@preview/glossarium:0.5.4": gls, glspl
= Background

This chapter provide the background for the project.
In @bg:link-prediction we provide an overview of link prediction and the classical solutions for the problem, in @bg:grl we further develop the concept of graph embedding and some common methods to create them.
Then in @bg:dynamic-graphs we discuss the addition of a time dimension in graph-shaped data and the way it can be exploited, followed by a presentation of cross-RNN architectures in @bg:cross-rnn.
Finally we present the model of interest for this work in @bg:limnet and why we believe that it is a relevant addition to the task of link prediction.

== Link Prediction <bg:link-prediction>

The rapid expansion of digital technology has resulted in the production of an overwhelming abundance of information.
To the point that it is a challenge to find relevant and meaningful material among the multitude.
To not only alleviate but also leverage this information overload, the interest have surged for search engines and recommendation systems.
These two subjects share one common goal: filtering information.
Among the many techniques that have emerged to tackle this task, content personalization has emerged as a significant factor.
Instead of filtering the information in the same way for everyone, the systems will use the user's context: their search history, demographics, pasts interactions with the system, etc. to filter the information to display.
Content personalization is the whole core of recommendation systems.
But it is also very efficient for search engines.
For example, the search for the term "football" should yield different results for a user interested in American football and a user interested in association football (soccer).

Content personalization can commonly be represented as a link-prediction problem in a user-item graph.
In such a graph, each user and each item is associated to a node.
An item can be any kind of information the user is interested in.
It could be web pages, music tracks, items in an e-commerce catalog, and so on...
For each interaction a user has with the system, it registers as an edge in the graph.
The goal of the personalization system is to find which item is the most relevant for a given user, which is the same as predicting which interaction should be added next in the graph.

A classical approach to that problem is to measure how close each item is to the user in the graph.
Research in graph theory has provided us with a range of different ways to compute closeness between two nodes, such as measuring the shortest path connecting them, how many neighbors they share or how exclusive their common neighbors are.

In addition of the relationship between users and items, most real-world system provide rich information about the nature of each interactions, users, and items.
For example, in a music streaming service, an interaction can have a type (stream, like, playlist add, ...), as well as a listening duration.
While each song can have information attached about its genres, its length, and for users, their age, and their location.
All of this information is typically processed by Machine Learning systems that provide reliable results for numerical features.
The challenge is then to meld traditional Machine Learning approaches for numerical features with graph-based methods for relational information.

Lichtenwalter et al. proposed to approach link prediction as a supervised Machine Learning problem, instead of scoring each edge, they try, given an edge, to predict if it will exist in the future.
To include the relational data to their model, they add some of the closeness metrics discussed earlier to the users and items features@new-perspectives-methods-link-prediction.
This typical machine learning setup leads to switch from a straightforward prediction setting to a feature engineering approach when it comes to graph-based data.
Instead of looking for the desired property in the structure of the graph, this approach will try to summarize the structure into rich representation compatible with machine learning algorithm.
The goal is not to proxy the desired property, but to create a rich representation of the graph data that can be used by a machine learning algorithm.

All the previously mentioned methods presents one main drawback: each time a user want to be predicted an item, the score for each item regarding that user must be evaluated.
This constraint makes it impossible to scale the solutions to large pools of items.
To limit the number of comparisons, a solution is to create a high-dimensional representation of the users and items separately and use simple proximity functions on these embeddings as a scoring function.
This spatial representation allow to reduce the problem to a nearest neighbor search for which scalable solutions have been found.

// - There are too many information, thus we need smarter way to select it.
// - A popular solution nowadays is through recommendations: each user is being recommended personalized suggestions that are tailored to fit their needs, based on their past interactions.

// - The problem of recommendation is often formulated as for each user, create a ranking of the items. Past interactions are represented as edges in a graph were users and items are nodes.

// - Collaborative filtering is the process of exploiting not only the user's past interactions but also the interactions of similar users. Example, movies.
// - A classical way to tackle the problem is to use graph-based metrics to measure how much related each item is to the user's preferences. Examples of this are distance, Adamic-Adar distance, etc.
// - These solutions are quite limited because they rely solely on the structure of the interactions, disregarding any additional knowledge on the users, items or interactions. This lead to the use of machine learning approaches.
// - One can use the graph-based metrics as features for a traditional ML pipeline.

// - ML opened a new opportunity: computing scores for all pairs is expensive, ML can be used to produced embeddings of users and items separately and use their distances as scores instead. Allow for pre-computing embeddings of items and much faster recommendations. (and better scalability).

== Graph Representation Learning <bg:grl>

The task of learning high level representation from graph data is called Graph Representation Learning, abbreviated as #gls("grl", long:false).
@grl is a general subject in data mining, it can be used to classify graph structures such as protein graphs, to capture information from a subgraph for example by creating subgraph representation from a knowledge graph to feed into a Large Language Model.
More commonly, @grl tries to create embeddings for nodes in a graph.
These embeddings must capture information about the node's features but also about the context of the node in the graph, which is typically defined as the neighboring nodes and their respective features and context.

Two main approaches have emerged to create these embeddings, the first one is inspired by @nlp and the second one from Computer vision.
The first approach creates random walks along the graph and assimilate each node to a token, and each random walk to a sentence or a sample of text.
This way, any methods that produce word embeddings can also be used to create nodes embeddings.
This method can even be used to create embeddings for paths or subgraphs.

The second approach is inspired by convolutional networks used in computer vision.
The idea is that convolutional networks see images as graphs of pixels and successively apply transformation to these pixels based on their direct neighborhood.
Such operations can be applied similarly to general graphs, the main challenge being to accept neighborhood of varying size.
These architectures are called @gnn and have proven very effective for @grl and link-prediction@a-comprehensive-survey-on-gnn.

// - The task of learning embeddings from graphs is called GRL and have applications outside link-prediction: node-level, edge-level, graph-level (molecule graphs, ask gpt).
// - Two approaches have been used so far: random walk based and GNNs. Random walk are used to create node sequences that are then fed to sequence based models of the same kind as Language models. GNNs are NN using the structure of the graphs to pass information through nodes.
// (- Practical examples of GNNs in for link prediction: GraphSAGE)

== Dynamic Graphs <bg:dynamic-graphs>

Most of the information we get from networks is dynamic, especially for user-item interaction networks where each interaction is usually happening at a given time.
Yet, when dealing with relational data, this temporal dimension is often disregarded to limit the complexity of the problem, or simplified as a mere feature of the interaction.
However temporal data constitute a unique kind of information, allowing to exploit causality relationship between the different interactions.

Causality is the idea that causes will have consequences in the future.
It becomes especially critical when studying phenomenons that can spread through the networks like diseases, information, or trends.
In such settings, each interaction can be the cause for a new state in the interacting nodes, requiring a different treatment for the same node at different times.
While this concept is very intuitive for us, it is not the case for common @grl techniques described in @bg:grl that let the information spread along the graph regardless of the order in which they are created.
// - Recently, researchers have been trying to exploit even more information with the addition of dynamic graphs. Until there, the temporality of the interactions did not have impact on the recommendations. e.g. listening session on spotify.

In their review of dynamic network@survey-dynamic-gnn, Zheng et al. explain /*The two main approaches*/ two ways temporal information are commonly included into graph data.
The first one considers a series of snapshot of the graph at successive timestamps.
The second one, called @ctdg, records every edition to the graph as an event, associated with a timestamp.
A typical event in a @ctdg is an edge addition or deletion.
For this work, the focus is on @ctdg with all events being punctual interactions.
We call such networks @tin:pl.
These networks have the benefit to represent reality of a lot of system in a completely faithful way/*add example ?*/.
However, the structure of the graph is blurry as each interaction corresponds to a point-in-time edge that is deleted as soon as it appears.
Because of this, we tend to approach such graphs as a stream of interactions rather than a structured network.
// - There are 2 way of representing dynamic graphs: DTDG and CTDG. We are interested in the latter since it better represent the reality.
// - CTDG can be seen as a stream of interactions instead of a stable graph structure. Thus, graphs concepts such as neighborhood become blurred.

A popular approach to leverage temporal data when creating nodes embeddings is to maintain a memory of the embeddings and update them as interactions are read.
One of the building block for this approach is DeepCoevolve@deepcoevolve, a model for link prediction that uses a cross-RNN (detailed further in @bg:cross-rnn) to update the representation of the users and items, followed by an intensity function to predict the best match for the user at every given time $t$.
Following DeepCoevolve, other cross-RNN models have been proposed with notables performance upgrade.

JODIE@jodie builds upon DeepCoevolve by adding a static embedding component to the representation, using the Cross-RNN part to track the users and items trajectories.
It then employs a neural network layer to project the future embedding of each node at varying time. operation carried over by the intensity function in DeepCoevolve.

DeePRed@deepred is an other approach building on top of DeepCoevolve, this time with the aim to accelerate and simplify the training by getting rid of the recurrence in the cross-RNN mechanism.
To achieve this, the dynamic embeddings are computed based on static embeddings, effectively getting rid of the recurrence by never reusing the dynamic embeddings for further computations.
The lack of long term information passing, is compensated by the use of a sliding context window coupled with an attention mechanism to best identify the meaningful interactions.

// - Approaches to cope with this added difficulty include using a window of past interactions to feed into a ML system (e.g. cross-attention with DeePRed).
// - A common solution since deepcoevolve is to use cross-RNN. The system keeps a memory of each node and will have these memories "interact" to update each other whenever an interaction is observed.

== Cross-RNN <bg:cross-rnn>

The key mechanism for all the aforementioned models is called cross-RNN where RNN stands for Recurrent Neural Network.
A #gls("rnn", long:false) is a neural network with the specificity of processing sequential data, passing an internal memory embedding between each step of the sequence of inputs.
Formally, a @rnn layer is defined as
$ bold(o)(bold(i)_t) = f(bold(i)_t, bold(h)_(t-1)) $
$ bold(h)_t = g(bold(i)_t, bold(h)_(t-1)) $ <rnn:memory-update>
Where $t$ stands for the time step of the input $bold(i)_t$. $bold(o)(bold(i)_t)$ marks the output of the layer and $bold(h)_t$ represent the memory of the layer after receiving the input $bold(i)_t$.
The functions $f$ and $g$ can vary depending on the nature of the @rnn but they will rely on weights, tuned during the model training.
Popular @rnn architectures try to keep a memory of long-term knowledge.
Typically, the @lstm architecture maintains two distinct memories, a short term one and a long term one.
The @gru architecture iterate over @lstm by simplifying it, removing one of the two memories while keeping the gating mechanism.
In practice both approaches perform significantly better than the naïve @rnn implementation, with @gru achieving comparable performances than @lstm, in spite of its reduced cost.

A Cross-RNN layer is slightly different.
Instead of keeping track of a single memory embedding $bold(h)_t$, it maintain a memory for all nodes in the graph $bold(H)_t = (bold(h)_t^u)_(u in UU) union (bold(h)_t^i)_(i in II)$, where $UU$ and $II$ are the sets of users and items in the graph.
For each interaction $(u,i,t,bold(f))$ the memory is updated as follow:
$ bold(h)_t^u = g^u (bold(h)_(t-1)^u, bold(h)_(t-1)^i, t, bold(f)) $
$ bold(h)_t^i = g^i (bold(h)_(t-1)^i, bold(h)_(t-1)^u, t, bold(f)) $
And for all other users and nodes the memory is carried over.
$
  bold(h)_t^v = bold(h)_(t-1)^v wide forall v in UU \\ {u} union II \\ {i}
$
Where $u$ is the user interacting with item $i$ at time $t$ with feature $bold(f)$, and $g^u$ and $g^i$ are tunable functions, comparable to the function $g$ in @rnn:memory-update.
@lstm and @gru cells designed for classical @rnn:pl can be used for cross-RNN, the only modification being the memory management external to the cell.

The main benefit of cross-RNN architectures is that conservation of causality is granted by design.
It comes however with a cost: the input of a cross-RNN model is sequential and cannot be made parallel.
This cost however is mostly an issue for the training of the model, because processing one input in inference do not require to pass through the entire sequence.

== LiMNet <bg:limnet>

@limnet is a cross-RNN model designed to optimize the memory utilization and computational speed at inference time.
In the original paper@article:limnet, @limnet is designed as a complete framework for botnet detection in IoT networks, with four main components: an input feature map, a generalization layer, an output feature map and a response layer.
For the purpose of this work, we will however consider @limnet as a graph embedding module.
Because the input feature map, output feature map and the response layer are task-dependent, the denomination #quote("LiMNet") in this present work will designate only the generalization layer from this point.

@limnet as a graph embedding module is a straightforward implementation of a cross-RNN module.
This simplicity in the design brings two main benefits: first, @limnet is very cheap to run at inference time, with a memory requirement linear in the number of nodes in the network.
Secondly, it is flexible to node insertion or deletions.
If a new node is added to the graph, it's embedding can be computed immediately, without a need to retrain the model.
Node deletions are even easier to handle, all it takes is to delete the corresponding embedding from the memory.
In practice, @limnet has already proven it's potential on the task of IoT botnet detection@article:limnet and fraud detection@limnet-finance-classification, it is thus expected that it could yield satisfying results for link-prediction, while requiring less resources than State of the Art solutions.

// - LiMNet is such a solution that aims at being as lightweight and simple as possible, using only one RNN cell to compute the embeddings. This has the double benefit of making it very cheap to run but also very flexible with node insertion and deletion being trivial operations.
// - Description of LiMNet Architecture
// - LiMNet has proven effective on the task of botnet and fraud detection but was not initially designed to tackle link prediction. Which is what this work aims to do.
