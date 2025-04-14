= Background

This chapter provide the background for the project. In @link-prediction we provide an overview of link prediction and the classical solutions for the problem, in @graph-representation-learning we further develop the concept of graph embeddings and some common methods to create them. Then in @bg:limnet we present in details our model of interest and why we believe that it is a relevant addition to the task of link prediction.

== Link Prediction <link-prediction>

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
// These features could be efficiently used through machine learning algorithms to obtain good predictions of the next interactions as well.

- There are too many information, thus we need smarter way to select it.
- A popular solution nowadays is through recommendations: each user is being recommended personalized suggestions that are tailored to fit their needs, based on their past interactions.

- The problem of recommendation is often formulated as for each user, create a ranking of the items. Past interactions are represented as edges in a graph were users and items are nodes.

- Collaborative filtering is the process of exploiting not only the user's past interactions but also the interactions of similar users. Example, movies.
- A classical way to tackle the problem is to use graph-based metrics to measure how much related each item is to the user's preferences. Examples of this are distance, Adamic-Adar distance, etc.
- These solutions are quite limited because they rely solely on the structure of the interactions, disregarding any additional knowledge on the users, items or interactions. This lead to the use of machine learning approaches.
- One can use the graph-based metrics as features for a traditional ML pipeline.

- ML opened a new opportunity: computing scores for all pairs is expensive, ML can be used to produced embeddings of users and items separately and use their distances as scores instead. Allow for pre-computing embeddings of items and much faster recommendations. (and better scalability).

== Graph Representation Learning <graph-representation-learning>

- The task of learning embeddings from graphs is called GRL and have applications outside link-prediction: node-level, edge-level, graph-level (molecule graphs, ask gpt).
- Two approaches have been used so far: random walk based and GNNs. Random walk are used to create node sequences that are then fed to sequence based models of the same kind as Language models. GNNs are NN using the structure of the graphs to pass information through nodes.
(- Practical examples of GNNs in for link prediction: GraphSAGE)

- Recently, researchers have been trying to exploit even more information with the addition of dynamic graphs. Until there, the temporality of the interactions did not have impact on the recommendations. e.g. listening session on spotify.
- There are 2 way of representing dynamic graphs: DTDG and CTDG. We are interested in the latter since it better represent the reality.
- CTDG can be seen as a stream of interactions instead of a stable graph structure. Thus, graphs concepts such as neighborhood become blurred.
- Approaches to cope with this added dificulty include using a window of past interactions to feed into a ML system (e.g. cross-attention with DeePRed).
- A common solution since deepcoevolve is to use cross-RNN. The system keeps a memory of each node and will have these memories "interact" to update each other whenever an interaction is observed.
- This approach has the benefit of conserving the causality of interactions into the embeddings.

== LiMNet <bg:limnet>

- LiMNet is such a solution that aims at being as lightweight and simple as possible, using only one RNN cell to compute the embeddings. This has the double benefit of making it very cheap to run but also very flexible with node insertion and deletion being trivial operations.
- Description of LiMNet Architecture
- LiMNet has proven effective on the task of botnet and fraud detection but was not initially designed to tackle link prediction. Which is what this work aims to do.
