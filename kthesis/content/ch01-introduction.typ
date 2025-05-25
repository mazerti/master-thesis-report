#import "@preview/glossarium:0.5.4": gls

= Introduction <intro>

== Purpose/Motivation <i:motivation>

The rapid expansion of digital technologies has resulted in the production of an overwhelming abundance of information, to the point that it is a challenge to find relevant and meaningful material among the multitude.
Thus, search engines and recommendation systems have become essential tools to not only alleviate this information overload, but also to leverage the large pools of data.
These two tools share one common goal: filtering information.
Among the many techniques that have emerged to tackle this task, content personalization has emerged as a significant factor.
Instead of filtering the information in the same way for everyone, the systems will use the user's context: their search history, demographics, pasts interactions with the system, etc. to filter the information to display.
Content personalization is the whole core of recommendation systems, but it is also very efficient for search engines.
For example, the search for the term "football" should yield different results for a user interested in American football and a user interested in association football (soccer).

Content personalization can be represented as a single algorithm that accepts as input user related information and output a ranked list of items from a catalog.
In order to measure the performance of such an algorithm, we need to know what items would be relevant for each users.
Gathering this information is costly, and sometimes even impossible.
However, it is easy to collect user behaviors such as interaction with items, thus, content recommendation is commonly approximated to an interaction prediction task.

Interaction prediction is a self-supervised learning task where interactions are used as labels to predicts, before being given as inputs to predict future interactions.
What sets this task apart from other self-supervised tasks is the relational aspect of the information used, each interaction explicitly connects information with other interactions and elements at play (such as users or items).
In addition, interaction order and temporality usually play an important role in explaining the observed behaviors.

@limnet @article:limnet is a simple Machine Learning model that is designed to process interactions in a causal way, leveraging both relational information and the interactions order.
This model proved it's performance at solving the task of botnet detection in IoT network, and has been designed in a modular and adaptive way that makes it easy to employ for different tasks.
Given these promising results and that it is designed to exploit precisely the specific information that makes interaction prediction challenging, we believe that @limnet can be an interesting solution to the interaction prediction task.

== Problem <i:problem>

The core research question for this work is the following:

#align(center)[
  #quote("How will" + gls("limnet") + "perform on the task of interaction prediction?")
]

While @limnet have shown significant success and potential, it has only been tested on the task of botnet detection on IoT networks, with some additional results available for the task of cryptocurrency fraud detection @limnet-finance-classification.
Thus, the goal of this project is to apply and evaluate @limnet on interaction prediction tasks, in order to assess the capabilities of the architecture across a wider variety of problems.
Answering that question would help us towards the two following goals:
+ Exploring the range of applications of the @limnet model.
+ Helping understand the success of state of the art interaction prediction models with similar architectures.

In addition, this project implements and evaluates adaptations and changes to the model's architecture, attempting to further enhance it's performances on the task of interaction prediction, but also to explore further the space of possibilities opened by the design of @limnet.

== Delimitations <i:delimitations>

This project focuses solely on predicting interactions for user-item networks.
Thus, it does not cover tasks such as user/item label classification or link prediction between users or items separately.

== Contributions <i:contirbutions>

We list here the contributions of this project:
- We publish a framework for model evaluation on user-item interaction prediction task.
- We present and evaluate @limnet, a new embedding model inspired from IoT botnet detection.
- We propose and test modifications to this model targeted at improving performances for the specific task of user-item interaction prediction.
- We reproduce and evaluate a state of the art model as a baseline.

== Ethics and Sustainability <c:ethics>
// move to conclusion


The progress of Machine Learning applications, that allow to leverage big data sources at the expanse of large infrastructure costs, increases the risk of inequalities by increasing the power given to the biggest institutions.
However, for this project that risk is mitigated thanks to three aspect of the @limnet architecture.
Firstly, the big selling points of this architecture are its scalability and lightweight aspect, both elements that participate to reduce the entry cost to run such model.
Secondly, there is ongoing research to adapt this architecture into a decentralized and collaborative variant @metasoma. 
That variant may allow communities to leverage the model using distributed resources.
Lastly, this project is public and thus easily accessible for legislators and law enforcers.
There is an ever-increasing need to push the legislation on the use of new technologies, and research allowing legislator to take informed decision about these subjects that still contains a lot of unknowns is valuable.

The reduced cost in computing is also subject to potential environmental impacts.
It is, however, still unclear if increasing energy efficiency leads to an actual energy saving on the long run @rebound-effect-no-backfire.
