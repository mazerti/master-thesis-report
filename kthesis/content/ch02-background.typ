#import "@preview/glossarium:0.5.4": gls, glspl
= Background

This chapter provides the background for the project.
In @bg:link-prediction, we provide an overview of the more standard link prediction task and the classical solutions for the problem.
In @bg:grl, we further develop the concept of graph embedding and some common methods to create them.
Then, in @bg:dynamic-graphs, we discuss the addition of a time dimension in graph-shaped data and the way it can be exploited, followed by a presentation of cross-RNN architectures in @bg:cross-rnn.
Finally, we present the model of interest for this work in @bg:limnet and why we believe that it is a relevant addition to the task of interaction prediction.

== User-Item Link Prediction <bg:link-prediction>


Interaction prediction can often be formulated as a link prediction problem within a user-item graph.
In such a graph, each user and each item is represented as a node.
Each user interaction with an item is registered as an edge in the graph.
Predicting future interactions comes down to predicting which edges are likely to appear next.

In this project, we focus specifically on user-item interaction networks—systems in which all interactions occur between distinct user and item entities.
Users and items play fundamentally different roles: users initiate interactions, while items are the targets.
This introduces a structural asymmetry in the network, where interactions are always directed from a user to an item.
In practice, this means that prediction tasks are framed from the user's perspective, with the goal of identifying the most relevant items they are likely to interact with next.

There are two primary approaches to this problem: one based on graph analytics and the other on feature-based methods@survey-link-prediction.
Graph analytics focuses on measuring the proximity between a user and various items in the graph, leveraging insights from the user's past interactions and the behaviors of similar users.
For instance, if two users have listened to the same set of songs, one may likely enjoy the songs the other has listened to.
Graph theory offers a variety of methods to compute closeness between nodes, including shortest path lengths, the number of shared neighbors, or the exclusivity of those shared neighbors.

The second approach leverages additional information beyond the user-item relationship.
Most real-world systems provide rich metadata about interactions, users, and items.
For example, in a music streaming service, a song may include attributes like genre and duration, while a user may be characterized by age or selected language.
These attributes are referred to as features, and utilizing them is central to machine learning approaches.
Unlike graph-based methods, feature-based models recommend items by identifying similar users based on shared characteristics.
Continuing the music example, the system might learn that songs with lyrics in Swedish are less likely to appeal to users that don't use Swedish as their primary language.

The challenge lies in integrating both approaches.
Lichtenwalter et al. proposed framing link prediction as a supervised machine learning task, where the objective is to predict whether an edge will form between a given user-item pair in the future.
To incorporate relational data into the model, graph closeness metrics are added to the user and item features@new-perspectives-methods-link-prediction.
This setup uses graph structure not as the direct basis for prediction but as a source of enriched features, enabling machine learning algorithms to work with abstracted representations of the graph.

Despite their strengths, these methods share a common drawback: for each user, a score must be computed for every possible item to generate a recommendation@item-based-collaborative-filtering.
This becomes computationally infeasible when dealing with large item catalogs.
A common solution is to learn high-dimensional embeddings for users and items separately and then compute a similarity score, such as a dot product or distance measure, to rank items@deep-neural-networks-youtube.
This transforms the problem into a nearest-neighbor search, a well-studied task with many efficient and scalable solutions.

== Graph Representation Learning <bg:grl>

The task of learning high-level representations from graph data is known as @grl.
@grl encompasses a broad family of machine learning techniques aimed at transforming the complex, non-Euclidean structure of graphs into low-dimensional Euclidean representations (i.e., numerical vectors), making them suitable for use in downstream machine learning tasks.

@grl methods can be applied to a wide range of problems.
These include classifying entire graph structures, such as molecular graphs; extracting subgraph representations from knowledge graphs to be used in large language models; and, most commonly, generating node embeddings.
These node embeddings must encode not only the intrinsic features of individual nodes but also the context in which they appear.
This context typically includes neighboring nodes and their corresponding features and positions within the graph.

== Dynamic Graphs <bg:dynamic-graphs>

Much of the information generated in real-world networks is inherently dynamic, particularly in user-item interaction networks, where each interaction occurs at a specific point in time.
Despite this, the temporal dimension is often ignored or simplified in order to reduce modeling complexity.
Yet, temporal information carries unique value, enabling models to capture not just patterns but also the causal relationships between interactions.

Causality refers to the principle that actions can influence future outcomes.
This is especially important when studying processes that propagate through networks, such as the spread of information, trends, or behaviors.
In these scenarios, an interaction may change the state of the involved nodes, making it necessary to treat the same node differently depending on the time of observation.
While humans intuitively understand these evolving patterns, many standard @grl techniques disregard temporal order, propagating information across the graph without regard to when interactions occurred.

In their review of dynamic networks @survey-dynamic-gnn, Zheng et al. outline two common approaches to incorporating temporal information into two models.
The first involves representing the graph as a sequence of discrete snapshots, each corresponding to a specific time step.
The second, known as @ctdg, treats each graph update as an event timestamped in continuous time, typically the addition or removal of an edge.

This work focuses on @ctdg, where all events are modeled as punctual interactions, also referred to as temporal interaction networks.
These networks offer a faithful representation of many real-world systems, as they continuously track changes over time.
However, they come with a challenge: the underlying graph structure becomes ephemeral, with each edge appearing only momentarily.
As a result, these networks are often better understood as interaction streams rather than static or evolving graphs with persistent edges.

A popular approach for leveraging temporal data when generating node embeddings is to maintain a memory of embeddings and update them as interactions occur.
One foundational model in this domain is DeepCoevolve @deepcoevolve, a model for link prediction that uses two components: a cross-RNN (further detailed in @bg:cross-rnn) to update user and item representations, and an intensity function to predict the likelihood of future interactions at any given time.
Following DeepCoevolve, several cross-RNN-based models have been proposed, achieving notable performance improvements.

JODIE @jodie extends DeepCoevolve by introducing a static embedding component alongside the dynamic one.
The cross-RNN tracks the trajectory of users and items over time, while a neural projection layer predicts their future embeddings at different time steps, replacing the intensity function used in DeepCoevolve.

DeePRed @deepred builds upon DeepCoevolve with the goal of simplifying and accelerating training by removing recurrence from the cross-RNN mechanism.
Instead, dynamic embeddings are computed directly from static embeddings, avoiding recursive updates.
The absence of long-term memory is addressed through the use of a sliding context window and an attention mechanism that identifies and weights the most relevant past interactions.

== Cross-RNN <bg:cross-rnn>

The key mechanism underlying the models discussed in the previous section is known as cross-RNN, where #gls("rnn", long: false) stands for Recurrent Neural Network.
A @rnn is a type of neural network designed to process sequential data by maintaining and updating a memory state across time steps.
Formally, a @rnn layer is defined as:

$ bold(o)(bold(i)_t) = f(bold(i)_t, bold(h)_(t-1)) $
$ bold(h)_t = g(bold(i)_t, bold(h)_(t-1)) $ <rnn:memory-update>

Here, $t$ denotes the time step of the input $bold(i)_t$.
The function $bold(o)(bold(i)_t)$ produces the layer's output, and $bold(h)_t$ represents the updated memory after processing $bold(i)_t$.
The functions $f$ and $g$ are parameterized transformations, typically involving learned weights.
Popular @rnn architectures, such as @lstm and @gru, are designed to retain long-term dependencies more effectively than simple @rnn:pl.
@lstm maintains two types of memory (short-term and long-term), whereas @gru simplifies this structure by using a single memory vector with a gating mechanism.
In practice, @gru:pl achieve performance comparable to @lstm:pl while being computationally less demanding @gated-recurrent-nn-on-sequence-modelling.

A cross-RNN layer extends this concept by maintaining separate memory states for all nodes in a graph.
At time $t$, the memory is represented as:
$bold(H)_t = (bold(h)_t^u)_(u in UU) union (bold(h)_t^i)_(i in II)$
where $UU$ and $II$ denote the sets of users and items, respectively.
For each interaction $(u,i,t,bold(f))$, the memory states of the involved user $u$ and item $i$ are updated according to:

$ bold(h)_t^u = g^u (bold(h)_(t-1)^u, bold(h)_(t-1)^i, t, bold(f)) $
$ bold(h)_t^i = g^i (bold(h)_(t-1)^i, bold(h)_(t-1)^u, t, bold(f)) $

For all other nodes $v in (UU \\ {u}) union (II \\ {i})$, the memory remains unchanged.

Here, $g^u$ and $g^i$ are node-type-specific update functions analogous to $g$ in a standard @rnn.
@lstm and @gru cells can be used within the cross-RNN framework, with the key distinction that memory management is handled externally to the cell.

The primary advantage of cross-RNN architectures is their inherent preservation of causality.
Since updates depend strictly on past states, the model respects the temporal order of interactions by design.
However, this sequential nature introduces a limitation: cross-RNN models cannot be parallelized over the sequence during training.
Fortunately, this constraint primarily affects training efficiency, during inference, each interaction can be processed independently, making the approach practical for real-time applications.

== LiMNet <bg:limnet>

@limnet is a cross-RNN model designed to optimize memory utilization and computational efficiency during inference.
In its original formulation @article:limnet, @limnet is part of a comprehensive framework for botnet detection in IoT networks.
The framework includes four main components: an input feature map, a generalization layer, an output feature map, and a response layer.
For the purposes of this work, however, we consider only the generalization layer.
Since the other components are task-specific, the term #quote("LiMNet") in this thesis refers exclusively to the generalization layer.

As a graph embedding module, @limnet provides a straightforward implementation of a cross-RNN mechanism, @fig:limnet proposes a visualization of its architecture.
This simplicity offers two main advantages.
First, @limnet is highly efficient at inference time, with memory requirements that scale linearly with the number of nodes in the network.
Second, it offers strong flexibility in handling dynamic node sets: when a new node is introduced, its embedding can be computed immediately without retraining the model.
Deleting a node is even simpler: its embedding can just be removed from memory without consequences for the other embeddings.

@limnet has already demonstrated promising results in tasks such as IoT botnet detection @article:limnet and cryptocurrency fraud detection @limnet-finance-classification. Given its design and prior success, it is a compelling candidate for interaction prediction tasks, particularly in settings where computational efficiency is a key constraint.

#figure(
  image("../../../../figures/limnet-architecture.svg", width: 70%),
  caption: "Architecture of LiMNet.",
  placement: auto,
) <fig:limnet>
