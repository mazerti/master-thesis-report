#import "@preview/glossarium:0.5.4": gls

= Introduction <intro>

== Purpose/Motivation <i:motivation> /* Can't keep that title */

The rapid expansion of digital technologies has led to an overwhelming abundance of information, making it increasingly difficult to identify relevant and meaningful content @quantifying-information-overload-2014 @overview-information-communication-2017.
In response to this challenge, search engines and recommendation systems have become essential tools for filtering and navigating vast data landscapes @causes-consequences-strategies-2024.

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
  #quote("Does LiMNet have the potential to compete against state-of-the-art models on the task of interaction prediction for user-item network?")
]

@limnet has shown significant promise, yet its evaluation has been limited to botnet detection in IoT networks @article:limnet, with some additional results available for cryptocurrency fraud detection @limnet-finance-classification.
This project aims to apply and assess @limnet in the context of interaction prediction, thereby evaluating the model's generalizability across a broader range of tasks.
Addressing this research question supports two main goals: first, to explore the applicability of the @limnet architecture to diverse domains, and second, to better understand the characteristics that drive the success of similar state-of-the-art interaction prediction models.

To this end, we develop a flexible evaluation framework supporting multiple models while ensuring fair and consistent comparisons.
Additionally, we implement and evaluate several architectural adaptations to @limnet, aiming not only to improve its performance on interaction prediction but also to further investigate the design space enabled by its modular structure.

== Limitations <i:delimitations>

One alternative approach to interaction prediction involves building a classifier to determine whether a given user is likely to interact with a specific item.
This approach is excluded from the present work, which instead focuses on computing embeddings and generating ranked item lists.

Another limitation of this study is its strict focus on user-item networks.
Interactions between entities of the same type, such as user-user or item-item connections, are not considered.
For instance, tasks like friendship prediction on a social network fall outside the scope of this project.
Consequently, each entity is strictly classified as either a user or an item, with no allowance for hybrid or hierarchical roles.
And only one kind of interaction is considered, e.g. user listening to a song but not artist posting a song.

Furthermore, this work considers only punctual interactions—discrete events occurring at specific points in time.
Continuous interactions are excluded, and due to data limitations, the duration of interactions is not modeled.
Although interaction durations could offer meaningful insights into engagement or relevance, they remain outside the scope of this thesis.

== Contributions <i:contributions>

The main contributions of this project are as follows:
- Development and publication of a framework for evaluating models on the user-item interaction prediction task.
- Presentation and evaluation of LiMNet, an embedding model originally proposed for IoT botnet detection. Our evaluation shows that, in its current form, LiMNet does not match the performance of state-of-the-art baselines.
- Proposal and testing of architectural modifications to LiMNet aimed at improving its performance in the context of user-item interaction prediction.
- Reproduction and evaluation of Jodie, a state-of-the-art model for temporal interaction prediction. Interestingly, our implementation produced results that exceeded expectations.
- Identification of a possible structural bias in the benchmark datasets, suggesting they may favor global popularity trends over more complex, long-term behavioral patterns.
