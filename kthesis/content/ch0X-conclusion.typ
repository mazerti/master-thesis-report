= Conclusions
/* Describe the conclusions (reflect on the whole introduction given in Chapter 1).

Discuss the positive effects and the drawbacks.
Describe the evaluation of the results of the degree project.
Did you meet your goals? What insights have you gained?
What suggestions can you give to others working in this area?
If you had it to do again, what would you have done differently? */

The goal of this thesis was to understand the potential of the @limnet model for interaction prediction task on a user-item dynamical network.
This research question led to the creation of an evaluation framework for this task, the evaluation of variants of the @limnet model on this framework, along with re-implementing the Jodie model as a baseline.
There are three key findings of this thesis:
Firstly, @limnet significantly underperform on the interaction prediction task compared with Jodie.
Secondly, normalizing the embeddings throughout the cross-RNN mechanism improves the performance of the model.
Lastly, the length of the interaction sequence processed by the models have little impact on the models results, hinting at short term global trends effect dominance over long term local preference behaviors.

== Limitations
/* What did you find that limited your efforts? What are the limitations of your results? */

To keep the project's scope to a reasonable size, some questions had to be set aside during the research project, thus, the findings only concerns the task of user-item interaction prediction and doesn't address more general link-prediction tasks.
In addition, this work focused on embedding creation with little consideration for how to most efficiently employ these embeddings.
Another aspect that was left over during the research process was the performance tests, and more specifically the performance at inference.
That aspect is one of the most benefit of the @limnet architecture as demonstrated in @article:limnet, it is therefore good to keep in mind this limitation of the present project when assessing the potential of @limnet.

== Future Works
/* Describe valid future work that you or someone else could or should do.
Consider: What you have left undone?
What are the next obvious things to be done?
What hints can you give to the next person who is going to follow up on your work? */

The experiment on sequence length discussed in @ex:sequence-length exposed a surprising and novel view on the underlying mechanisms that steer the behaviors recorded in the datasets used.
Therefore, it would be very beneficial to try the models tested in this study on more suited datasets that do exhibits more complex long-term and local behaviors.

The other interesting gap we suggest to explore is the difference between the performances of the @limnet model and the Jodie one, since both models share the same core, it is surprising to witness such a big difference in their capabilities.
Exploring the design space that separates this models through an ablation study of the components of Jodie could bring more insight on which architectural decision generates such a performance leap.

// == Reflections
/* What are the relevant economic, social, environmental, and ethical aspects of your work? */

== Ethics and Sustainability <c:ethics>
// move to conclusion


The progress of Machine Learning applications, which allows for leveraging big data sources at the expense of large infrastructure costs, increases the risk of inequalities by increasing the power given to the biggest institutions.
However, for this project, that risk is mitigated thanks to three aspects of the @limnet architecture.
Firstly, the big selling points of this architecture are its scalability and lightweight aspect, both elements that contribute to reduce the entry cost to run such a model.
Secondly, there is ongoing research to adapt this architecture into a decentralized and collaborative variant @metasoma.
That variant may allow communities to leverage the model using distributed resources.
Lastly, this project is public and thus easily accessible for legislators and law enforcers.
There is an ever-increasing need to push the legislation on the use of new technologies, and research allowing legislators to take informed decisions about these subjects that still contain a lot of unknowns is valuable.

The reduced cost of computing power is also subject to potential environmental impacts.
It is, however, still unclear if increasing energy efficiency leads to an actual energy saving in the long run @rebound-effect-no-backfire.