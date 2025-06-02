#import "@preview/glossarium:0.5.4": gls

= Introduction <intro>

== Purpose/Motivation <i:motivation> /* Can't keep that title */

The rapid expansion of digital technologies has produced an overwhelming abundance of information, making it challenging to find relevant and meaningful material among the multitude.
Thus, search engines and recommendation systems have become essential tools to alleviate this information overload and leverage the large pools of data.
These two tools share one common goal: filtering information.
Among the many techniques that have been researched to tackle this task, content personalization has emerged as a significant factor.
Instead of filtering the information in the same way for everyone, the systems will use the user's context, e.g. search history, demographics, and past interactions with the system, to filter the information to display.
Content personalization is the core of recommendation systems, but it is also very efficient for search engines.
For example, the search for the term "football" should yield different results for a user interested in American football and a user interested in association football (soccer).

Content personalization can be represented as a single algorithm that accepts as input user-related information and outputs a ranked list of items from a catalog.
Items could be any piece of information that is available to the user among a large selection, such as songs in a streaming catalog, or web pages.
In order to measure the performance of such an algorithm, we need to know which items would be relevant for each user.
Gathering this information is costly, and sometimes even impossible.
However, it is easy to collect user behaviors such as interaction with items, thus, content recommendation is commonly approximated to an interaction prediction task.

Interaction prediction is a self-supervised learning task where interactions are used as labels to predict, before being given as inputs to predict future interactions.
What sets this task apart from other self-supervised tasks is the relational aspect of the information used; each interaction explicitly connects information with other interactions and elements at play (such as users or items).
Thus, we commonly refers to user-items networks to refer to a set of interactions so that the relational aspect of it is stressed.
In addition, the order of the interactions and their temporality usually play an important role in explaining the observed behaviors.

We will focus in this project on the case of user-item interaction networks, that is interaction systems where all interactions occur between a user and an item where users are distinct from items.
In this setting, interactions are inherently asymmetrical; users are causing the interactions while items are available to be interacted with by any users.


@limnet @article:limnet is a simple Machine Learning model that is designed to process interactions in a causal way, leveraging both relational information and the order of the interactions.
This model proved its performance at solving the task of botnet detection in IoT networks, and has been designed in a modular and adaptive way that makes it easy to employ for different tasks.
Given these promising results and that it is designed to exploit precisely the specific information that makes interaction prediction challenging, we believe that @limnet can be an interesting solution to the interaction prediction task.

== Problem <i:problem>

The core research question for this work is the following:

#align(center)[
  #quote("Does LiMNet has the potential to compete against state of the art models on the task of interaction prediction for user-item network?")
]

@limnet has shown significant success and potential, yet, it has only been tested on the task of botnet detection on IoT networks @article:limnet, with some additional results available for the task of cryptocurrency fraud detection @limnet-finance-classification.
Thus, the goal of this project is to apply and evaluate @limnet on interaction prediction tasks, to assess the capabilities of the architecture across a wider variety of problems.
Answering that question would help us towards the following two goals:
first, to explore the range of applications of the @limnet model, and second, to help understand the success of state-of-the-art interaction prediction models with similar architectures.

To answer this question, we need to develop an evaluation framework that would support different models while ensuring the fairness of the measures.
In addition, this project implements and evaluates adaptations and changes to the model's architecture, attempting to further enhance its performance on the task of interaction prediction, but also to explore further the space of possibilities opened by the design of @limnet.

== Delimitations <i:delimitations>
// Expand this section a bit ?

This project focuses solely on predicting interactions for user-item networks.
Thus, it does not cover tasks such as user/item label classification or link prediction between users or items separately.

#v(1cm)
== Contributions <i:contributions>

Here follows the list of the contributions of this project:
- We publish a framework for model evaluation on the user-item interaction prediction task.
- We present and evaluate @limnet, a new embedding model taken from IoT botnet detection. The evaluation showed that this model is not able to match the current baselines.
- We propose and test modifications to this model targeted at improving performance for the specific task of user-item interaction prediction.
- We reproduce and evaluate Jodie, a state-of-the-art model, as a baseline. We witnessed better results than we expected.
- We realized that the datasets used may present a structural bias towards global trends rather than elaborate long term mechanisms.
