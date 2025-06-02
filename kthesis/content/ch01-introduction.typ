#import "@preview/glossarium:0.5.4": gls

= Introduction <intro>

== Purpose/Motivation <i:motivation> /* Can't keep that title */

The rapid expansion of digital technologies has led to an overwhelming abundance of information, making it increasingly difficult to identify relevant and meaningful content.
In response to this challenge, search engines and recommendation systems have become essential tools for filtering and navigating vast data landscapes.

Both systems share a common objective: to deliver information that is most relevant to the user.
Content personalization has emerged as a particularly effective approach among the many techniques developed to achieve this.
Rather than applying a one-size-fits-all filter, personalized systems adapt their output based on user-specific context such as search history, demographics, and past interactions.

Content personalization lies at the heart of recommendation systems and is highly effective in enhancing search engine performance.
For instance, a search query for the term "football" should yield different results for a user interested in American football compared to someone seeking information about association football (soccer).

Content personalization can be represented as an algorithm that takes user-specific information as input and produces a ranked list of items from a larger catalog.
These items can include any kind of content available to the user, such as songs in a music streaming service or web pages returned by a search engine.

Evaluating the performance of such algorithms typically requires knowledge of which items are genuinely relevant to each user.
However, obtaining this information can be costly and, in some cases, unfeasible.
On the other hand, user behaviors—such as clicks, listens, or edits—are easy to collect at scale.
As a result, content recommendation is often approximated as an interaction prediction task, where the goal is to predict future user-item interactions based on past behavior.

Interaction prediction is a self-supervised learning task in which past user-item interactions serve first as labels and later as input features used to predict future interactions.
Unlike other self-supervised tasks, it is distinguished by the inherently relational nature of the data: each interaction connects users and items, forming a web of dependencies that influence future behavior.

As a result, these interactions are often modeled as user-item networks to highlight the structural relationships between entities.
Besides, the temporal dimension—including the order and timing of interactions—typically plays a critical role in accurately modeling and understanding user behavior over time.

@limnet @article:limnet is a simple machine learning model designed to process user-item interactions in a causal manner, leveraging both relational information and the order of interactions.
The model has demonstrated strong performance in tasks such as botnet detection in IoT networks, and it is built in a modular, adaptive way that makes it easy to apply to other problems.
Given these promising characteristics and its ability to exploit precisely the types of information that make interaction prediction challenging, @limnet appears to be a compelling candidate for this task.

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
