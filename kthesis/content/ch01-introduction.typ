#import "@preview/glossarium:0.5.4": gls

= Introduction <intro>

== Purpose/Motivation <i:motivation>

The rapid expansion of digital technology has resulted in the production of an overwhelming abundance of information, to the point that it is a challenge to find relevant and meaningful material among the multitude.
To not only alleviate but also leverage this information overload, the interest have surged for search engines and recommendation systems.
These two subjects share one common goal: filtering information.
Among the many techniques that have emerged to tackle this task, content personalization has emerged as a significant factor.
Instead of filtering the information in the same way for everyone, the systems will use the user's context: their search history, demographics, pasts interactions with the system, etc. to filter the information to display.
Content personalization is the whole core of recommendation systems, but it is also very efficient for search engines.
For example, the search for the term "football" should yield different results for a user interested in American football and a user interested in association football (soccer).

Content personalization can be represented as a single algorithm that accepts as input user related information and output an item from a catalog.
In order to measure the performance of such an algorithm, we need to know what items would be relevant for each users.
Gathering this information is costly, and sometimes even impossible.
However, it is easy to collect user behaviors such as interaction with items, thus, content recommendation is commonly approximated to an interaction prediction task.

Interaction prediction is a self-supervised learning task where interactions are given as inputs to predict future interactions, that will themselves be added used for later inference.
What sets this task apart from other self-supervised tasks is the relational aspect of the information used, each interaction explicitly connecting information with other interactions and the interacting elements.
In addition, interaction order and temporality usually matters.

@limnet is a simple Machine Learning model of a new kind that is designed to process interactions in a causal way, leveraging both relational information and the interactions order.
This model proved it's performance at solving the task of botnet detection in IoT network, and has been designed in a modular and adaptive way that makes it easy to employ for different tasks.
Given these promising results and that it is designed to exploit precisely the specific information that makes interaction prediction challenging, we believe that @limnet can be an interesting solution to the interaction prediction task.

== Problem <i:problem>

The driving research question for this work is the following:

#quote("Can" + gls("limnet") + "perform well for interaction prediction?")

== Goals <i:goals>

== Delimitation <i:delimitation>

== Contribution <i:contirbution>

== Ethics and Sustainability <i:ethics>

