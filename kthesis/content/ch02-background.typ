#import "@preview/glossarium:0.5.4": gls, glspl
= Background

This chapter provide the background for the project. In @bg:link-prediction we provide an overview of link prediction and the classical solutions for the problem, in @bg:grl we further develop the concept of graph embeddings and some common methods to create them.
Then in @bg:dynamic-graphs we discuss the addition of a time dimension in graph-shaped data and the solution to exploit it.
Finally we present the model of interest for this work in @bg:limnet and why we believe that it is a relevant addition to the task of link prediction.

== Link Prediction <bg:link-prediction>

The rapid expansion of digital content has resulted in an overwhelming abundance of information, posing significant challenges for users seeking relevant and meaningful material.
A consequence to this information overload is the growing importance of search engines and recommendation systems.
Among the many techniques that have emerged to tackle this challenges, one of the most used is content personalization.
Instead of filtering the information in the same way for everyone, the systems will use the user's context: their search history, demographics, pasts interactions with the system, etc. to filter the information to display.
For example, a system can identify the user's location through localization or search history and filter out any local information that does not match her current localization.

Content personalization can commonly be represented as a link-prediction problem in a user-item graph.
In such a graph, each user and each item is associated to a node.
An item can be any kind of information the user is interested in, such as web pages, music tracks, items in an e-commerce catalog, ...
For each interaction a user will have with the system, it will register as an edge in the graph, the goal of the personalization system is to find which item is the most relevant for a given user, which is the same as predicting which interaction should be added next in the graph.

A classical approach to that problem is to measure how close each item is to the user in the graph.
Research in graph theory has provided us with a range of different ways to compute closeness between two nodes, such as measuring the shortest path connecting them, how many neighbors they share or how exclusive their common neighbors are.

The main issue with this approach is that it can only leverage structural data from the underlying graph while most of the applications provide rich context features for the users and the items.
Features like such are typical inputs for Machine Learning systems, that inspired Lichtenwalter et al. to approach link prediction as a supervised problem@new-perspectives-methods-link-prediction.
Given a user and an item, the task is now to evaluate how likely it is that an edge will form between them in the future, based on the knowledge of the user features, the item features and a range of similarity measures computed on the past interactions graph.
This typical machine learning setup leads to switch from a straightforward prediction setting to a feature engineering approach when it comes to graph-based data.
Instead of looking for the desired property in the structure of the graph, this approach will try to summarize the structure into rich representation compatible with machine learning algorithm.
The goal is not to proxy the desired property, but to create a rich representation of the graph data that can be used by a machine learning algorithm.

All of the previously mentioned methods presents one main drawback: each time a user want to be predicted an item, the score for each item regarding that user must be evaluated.
This limitation makes it hard to scale the solution to large pools of items.
A solution to limit the number of comparisons is to select a subset of potential items with a heuristic approach and only score these items.
While this work well in practice, a new approach has emerged to get rid of the first heuristic selection.
The key idea is to compute high-dimensional representations of the users and items separately and use simple proximity functions on these embeddings as a scoring function.
This spatial representation allow to reduce the problem of finding the best item to a problem of nearest neighbor for which scalable solutions have been found.


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
The idea is that convolutional networks approach images as graphs of pixels and successively apply transformation to these pixels based on their direct neighborhood.
Such operations can be applied similarly to general graphs, the main challenge being to accept neighborhood of varying size.
These architectures are called @gnn and have proven very effective for @grl and link-prediction@a-comprehensive-survey-on-gnn.

// - The task of learning embeddings from graphs is called GRL and have applications outside link-prediction: node-level, edge-level, graph-level (molecule graphs, ask gpt).
// - Two approaches have been used so far: random walk based and GNNs. Random walk are used to create node sequences that are then fed to sequence based models of the same kind as Language models. GNNs are NN using the structure of the graphs to pass information through nodes.
// (- Practical examples of GNNs in for link prediction: GraphSAGE)

== Dynamic Graphs <bg:dynamic-graphs>

Most of the information we get from networks is dynamic, especially for user-item interaction networks where each interaction is usually happening a a given time.
Yet, when dealing with relational data, this temporal components is often disregarded to limit the complexity of the problem, or simplified as a mere feature.
However temporal data constitute a unique kind of information, allowing to exploit causality relationship between the different interactions.
Causality is the concept that causes will have consequences in the future.
It is especially relevant for the study of interaction networks where each interaction can be the cause for a new state of each of the interacting nodes.
This concept becomes critical when studying any phenomenon that can spread through the network, such as disease, information, or trend.
While this concept is very intuitive for us, it is not the case for common GRL techniques described in @bg:grl that let the information spread along the graph regardless of the order in which they are created.
// - Recently, researchers have been trying to exploit even more information with the addition of dynamic graphs. Until there, the temporality of the interactions did not have impact on the recommendations. e.g. listening session on spotify.

In their review of dynamic network@survey-dynamic-gnn, Zheng et al. explain two ways temporal information are commonly included into graph data.
The first one consist of considering a series of snapshot of the graph at successive timestamps.
The second one is called @ctdg.
In a @ctdg every edition to the graph is recorded as an event, associated with a timestamp.
A typical event in a @ctdg is an edge addition or deletion.
For this work, the focus is on @tin:pl, that is @ctdg with all events being punctual interactions.
These networks have the benefit to represent reality of a lot of system in a completely faithful way.
However, the structure of the graph is blurry as each interaction correspond to a point-in-time edge that is removed immediately after happening.
Because of this, we tend to approach such graphs as a stream of interactions rather than a structured network.
// - There are 2 way of representing dynamic graphs: DTDG and CTDG. We are interested in the latter since it better represent the reality.
// - CTDG can be seen as a stream of interactions instead of a stable graph structure. Thus, graphs concepts such as neighborhood become blurred.

A popular approach to leverage temporal data when creating nodes embeddings is to maintain a memory of the embeddings and update them as interactions are read.


@ac:deepred is an approach to compute embeddings for link prediction from @tin's data, proposed by Kefato et al. in @deepred.
This approach uses a sliding window of 

- Approaches to cope with this added dificulty include using a window of past interactions to feed into a ML system (e.g. cross-attention with DeePRed).
- A common solution since deepcoevolve is to use cross-RNN. The system keeps a memory of each node and will have these memories "interact" to update each other whenever an interaction is observed.
- This approach has the benefit of conserving the causality of interactions into the embeddings.

== LiMNet <bg:limnet>

- LiMNet is such a solution that aims at being as lightweight and simple as possible, using only one RNN cell to compute the embeddings. This has the double benefit of making it very cheap to run but also very flexible with node insertion and deletion being trivial operations.
- Description of LiMNet Architecture
- LiMNet has proven effective on the task of botnet and fraud detection but was not initially designed to tackle link prediction. Which is what this work aims to do.
