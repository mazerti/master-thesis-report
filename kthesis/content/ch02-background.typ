#import "@preview/glossarium:0.5.4": gls, glspl
= Background

This chapter provides the background for the project.
In @bg:link-prediction, we provide an overview of link prediction and the classical solutions for the problem.
In @bg:grl, we further develop the concept of graph embedding and some common methods to create them.
Then, in @bg:dynamic-graphs, we discuss the addition of a time dimension in graph-shaped data and the way it can be exploited, followed by a presentation of cross-RNN architectures in @bg:cross-rnn.
Finally, we present the model of interest for this work in @bg:limnet and why we believe that it is a relevant addition to the task of link prediction.

== User-Item Link Prediction <bg:link-prediction>

// The beginning of this section just got moved to @i:motivation, need to rethink it a bit.

Content personalization can commonly be represented as a link-prediction problem in a user-item graph.
In such a graph, each user and each item is associated with a node.
An item can be any kind of information or content the user is interested in, such as web pages, music tracks, or items in an e-commerce catalog.
For each interaction a user has with the system, it registers as an edge in the graph.
The goal of the personalization system is to find which items are the most relevant for a given user at a given time, which is the same as predicting which interactions could be added next in the graph.
Note that the relevance of an item is highly contextual; for example, Christmas songs are very relevant around December and much less in July.

Two different ways to approach that problem are to use graph analytics, or to use features.
By measuring how close each item is to the user in the graph through graph analytics methods, we get recommendations based on the user's past interactions, and on the interactions users with a similar history had.
For example, if two users listened to the same songs, there is a higher chance that the second user will also like the other songs that the first user likes.
Research in graph theory has provided us with a range of different ways to compute closeness between two nodes, such as measuring the shortest path connecting them, how many neighbors they share, or how exclusive their common neighbors are.

The other approach exploits additional information we get in addition to the relationship between users and items.
Most real-world systems provide rich information about the nature of each interaction, users, and items.
For example, in a music streaming service, a song can have a length and a genre, while a user can have an age.
We call these information features, and exploiting them is the core of Machine Learning.
This approach doesn't make suggestions based on the users' past interactions but instead will suggest similar results to users with similar attributes.
To continue on the music streaming service example, we could identify relationships between the different populations of users and items, such as audience of young parents being more likely to be interested in nursery rhymes than teenagers.

The challenge is then to meld both approaches.
Lichtenwalter et al. proposed to approach link prediction as a supervised Machine Learning problem where the objective is to predict if an edge will exist in the future between a given pair of user and item.
To include the relational data in their model, they add some of the closeness metrics from graph analytics to the users and items features@new-perspectives-methods-link-prediction.
This setup invites to exploit the graph-based data not directly to predict the result but to build relevant features to enhance existing feature-based solutions.
Instead of looking for the desired property in the structure of the graph, this approach will try to summarize the structure into rich representations compatible with machine learning algorithms.

All the previously mentioned methods present one main drawback: each time a user wants to be predicted an item, the score for each item regarding that user must be evaluated.
This constraint makes it impossible to scale the solutions to large pools of items.
To limit the number of comparisons, a solution is to create a high-dimensional representation of the users and items separately and use simple proximity functions on these embeddings as a scoring function.
This spatial representation allows to reduce the problem to a nearest neighbor search for which scalable solutions have been found.

== Graph Representation Learning <bg:grl>

The task of learning high-level representation from graph data is called Graph Representation Learning, abbreviated as #gls("grl", long: false).
@grl is a broad family of machine learning approaches that capture the complex non-Euclidean structure of graphs into low-dimensional Euclidean representations (i.e., numerical vectors), enabling its use by downstream ML methods.
It can be used to classify graph structures such as protein graphs, to capture information from a subgraph, for example, by creating subgraph representations from knowledge graphs to feed into Large Language Models, and more commonly, to create embeddings for nodes in a graph.
These embeddings must capture information about the node's features but also about the context of the node in the graph, which is typically defined as the neighboring nodes and their respective features and context.

== Dynamic Graphs <bg:dynamic-graphs>

Most of the information we get from networks is dynamic, especially for user-item interaction networks, where each interaction usually happens at a given time.
Yet, when dealing with relational data, this temporal dimension is often disregarded to limit the complexity of the problem or simplified as a mere feature of the interaction.
However, temporal data constitute a unique kind of information, allowing for the exploitation of the causal relationships between the different interactions.

Causality is the idea that causes will have consequences in the future.
It becomes especially critical when studying phenomena that can spread through the networks, such as diseases, information, or trends.
In such settings, each interaction can be the cause for a new state in the interacting nodes, requiring a different treatment for the same node at different times.
While this concept is very intuitive for us, it is not the case for common @grl techniques described in @bg:grl that let the information spread along the graph regardless of the order in which they are created.

In their review of dynamic network@survey-dynamic-gnn, Zheng et al. explain two ways temporal information is commonly included into graph data.
The first one considers a series of snapshots of the graph at successive timestamps.
The second one, called @ctdg, records every edition to the graph as an event, associated with a timestamp.
A typical event in a @ctdg is an edge addition or deletion.
For this work, the focus is on @ctdg with all events being punctual interactions.
We call such networks temporal interaction networks.
These networks have the benefit of representing the reality of a lot of systems in a completely faithful way because they continuously account for the new modifications.
However, the structure of the graph is blurry as each interaction corresponds to a point-in-time edge that is deleted as soon as it appears.
Because of this, we tend to approach such graphs as a stream of interactions rather than a structured network.

A popular approach to leverage temporal data when creating node embeddings is to maintain a memory of the embeddings and update them as interactions are read.
One of the building blocks for this approach is DeepCoevolve @deepcoevolve, a model for link prediction that uses two components: a cross-RNN (detailed further in @bg:cross-rnn) to update the representation of the users and items, followed by an intensity function to predict the best match for the user at every given time $t$.
Following DeepCoevolve, other cross-RNN models have been proposed with notable performance upgrades.

JODIE @jodie builds upon DeepCoevolve by adding a static embedding component to the representation, using the Cross-RNN part to track the users' and items' trajectories.
It then employs a neural network layer to project the future embedding of each node at varying times, an operation that replaces the intensity function in DeepCoevolve.

DeePRed @deepred is another approach building on top of DeepCoevolve, this time with the aim to accelerate and simplify the training by getting rid of the recurrence in the cross-RNN mechanism.
To achieve this, the dynamic embeddings are computed based on static embeddings, effectively getting rid of the recurrence by never reusing the dynamic embeddings for further computations.
The lack of long-term information passing is compensated by the use of a sliding context window coupled with an attention mechanism to best identify the meaningful interactions.

== Cross-RNN <bg:cross-rnn>

The key mechanism for all the aforementioned models is called cross-RNN, where RNN stands for Recurrent Neural Network.
A #gls("rnn", long: false) is a neural network with the specificity of processing sequential data, passing an internal memory embedding between each step of the sequence of inputs.
Formally, a @rnn layer is defined as
$ bold(o)(bold(i)_t) = f(bold(i)_t, bold(h)_(t-1)) $
$ bold(h)_t = g(bold(i)_t, bold(h)_(t-1)) $ <rnn:memory-update>
Where $t$ stands for the time step of the input $bold(i)_t$. $bold(o)(bold(i)_t)$ marks the output of the layer and $bold(h)_t$ represent the memory of the layer after receiving the input $bold(i)_t$.
The functions $f$ and $g$ can vary depending on the nature of the @rnn, but they will rely on weights, tuned during the model training.
Popular @rnn architectures try to keep a memory of long-term knowledge.
Typically, the @lstm architecture maintains two distinct memories, a short-term one and a long-term one.
The @gru architecture iterates over @lstm by simplifying it, removing one of the two memories while keeping the gating mechanism.
In practice, both approaches perform significantly better than the naïve @rnn implementation, with @gru achieving comparable performances to @lstm, in spite of its reduced cost.

A Cross-RNN layer is slightly different.
Instead of keeping track of a single memory embedding $bold(h)_t$, it maintain a memory for all nodes in the graph $bold(H)_t = (bold(h)_t^u)_(u in UU) union (bold(h)_t^i)_(i in II)$, where $UU$ and $II$ are the sets of users and items in the graph.
For each interaction $(u,i,t,bold(f))$ the memory is updated as follow:
$ bold(h)_t^u = g^u (bold(h)_(t-1)^u, bold(h)_(t-1)^i, t, bold(f)) $
$ bold(h)_t^i = g^i (bold(h)_(t-1)^i, bold(h)_(t-1)^u, t, bold(f)) $
And for all other users and nodes, the memory is carried over.
$
  bold(h)_t^v = bold(h)_(t-1)^v wide forall v in UU \\ {u} union II \\ {i}
$
Where $u$ is the user interacting with item $i$ at time $t$ with feature $bold(f)$, and $g^u$ and $g^i$ are tunable functions, comparable to the function $g$ in @rnn:memory-update.
@lstm and @gru cells are designed for classical @rnn:pl can be used for cross-RNN, the only modification being the memory management external to the cell.

The main benefit of cross-RNN architectures is that conservation of causality is granted by design.
It comes, however, with a cost: the input of a cross-RNN model is sequential and cannot be made parallel.
This cost is nonetheless mostly an issue for the training of the model, because processing one input in inference does not require passing through the entire sequence.

== LiMNet <bg:limnet>

@limnet is a cross-RNN model designed to optimize the memory utilization and computational speed at inference time.
In the original paper@article:limnet, @limnet is designed as a complete framework for botnet detection in IoT networks, with four main components: an input feature map, a generalization layer, an output feature map, and a response layer.
We will, however, for the purpose of this work, consider @limnet as a graph embedding module.
Because the input feature map, output feature map, and the response layer are task-dependent, the denomination #quote("LiMNet") in this present work will designate only the generalization layer from this point.

@limnet, as a graph embedding module, is a straightforward implementation of a cross-RNN module.
This simplicity in the design brings two main benefits: first, @limnet is very cheap to run at inference time, with a memory requirement linear in the number of nodes in the network.
Secondly, it is flexible to node insertion and deletion.
If a new node is added to the graph, its embedding can be computed immediately, without the need to retrain the model.
Node deletions are even easier to handle; all it takes is to delete the corresponding embedding from memory.
In practice, @limnet has already proven its potential on the task of IoT botnet detection@article:limnet and fraud detection@limnet-finance-classification, it is thus expected that it could yield satisfying results for link-prediction, while requiring fewer resources than state-of-the-art solutions.

#figure(
  image("../../../../figures/limnet-architecture.svg", width: 70%),
  caption: "Architecture of "
    + gls("limnet")
    + ". User embeddings are indicated in green and items embeddings in purple.",
  placement: auto,
) <fig:limnet>
