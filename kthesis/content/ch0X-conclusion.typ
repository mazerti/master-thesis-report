= Conclusions
/* Describe the conclusions (reflect on the whole introduction given in Chapter 1).

Discuss the positive effects and the drawbacks.
Describe the evaluation of the results of the degree project.
Did you meet your goals? What insights have you gained?
What suggestions can you give to others working in this area?
If you had it to do again, what would you have done differently? */

The objective of this thesis was to evaluate the potential of the @limnet model for interaction prediction in user-item dynamic networks.
Addressing this research question led to the development of an evaluation framework tailored to this task, the adaptation and assessment of multiple @limnet variants, and the reimplementation of the Jodie model as a state-of-the-art baseline.

This study yielded three key findings:

1. @limnet significantly underperforms on the interaction prediction task when compared to Jodie.
Stripped down to its core cross-RNN memory module, @limnet is clearly unable to match Jodie's performance across all datasets.
Notably, the performance gap widens on more complex datasets, suggesting that Jodie's additional architectural components, such as its static embeddings and projection mechanism, play a critical role in enhancing predictive capability.
It is important to emphasize that the version of @limnet tested here excludes several components included in its original architecture.
This simplification may explain why @limnet performs poorly in this context, despite achieving strong results in domains like IoT botnet detection @article:limnet and cryptocurrency fraud detection @limnet-finance-classification.

2. Embedding normalization within the cross-RNN mechanism leads to a substantial improvement in @limnet's performance.
By maintaining normalized embeddings in memory, the model is encouraged to encode information through angular differences rather than magnitude.
This alignment with the dot-product scoring method (i.e., cosine similarity) ensures that the memory state and the scoring function are consistent, which in turn improves the overall performance of the model.

3. Sequence length has minimal impact on model performance
The performance of both @limnet and Jodie remained relatively stable when trained and evaluated on significantly shorter sequences.
This stability implies that the models primarily learn from recent and globally popular interaction patterns (i.e. trends) rather than from long-term, user-specific histories.
This behavior is likely influenced by the dataset construction, which emphasizes the most popular items and most active users over a fixed time period.

== Limitations
/* What did you find that limited your efforts? What are the limitations of your results? */

To maintain a manageable scope, certain questions were left aside during the research process of this thesis.
One of them is that the findings are specific to the task of user-item interaction prediction and do not generalize to broader link prediction scenarios.
Additionally, the study focused primarily on the generation of embeddings, with less emphasis on how to most effectively leverage them for downstream tasks.

Performance evaluation at inference time was also not addressed, even though this is one of @limnet's key architectural advantages, as demonstrated in prior work @article:limnet.
This omission should be considered when interpreting the model's potential and drawing conclusions about its practical utility.

== Future Works
/* Describe valid future work that you or someone else could or should do.
Consider: What you have left undone?
What are the next obvious things to be done?
What hints can you give to the next person who is going to follow up on your work? */

The sequence length experiment discussed in @ex:sequence-length revealed a novel and surprising insight into the mechanisms underlying user-item interactions.
To validate and extend these observations, future work should test both @limnet and Jodie on datasets that exhibit more complex, long-term, and localized behavioral patterns.

Another promising avenue for future research is exploring the significant performance gap between @limnet and Jodie.
Despite sharing a common core, the two models demonstrate dramatically different capabilities.
An ablation study focusing on Jodie's architectural components could shed light on which design decisions contribute most to its superior performance.

// == Reflections
/* What are the relevant economic, social, environmental, and ethical aspects of your work? */

== Ethics and Sustainability <c:ethics>

=== Ethical aspects

As machine learning systems increasingly rely on large-scale data and compute resources, there is growing concern about widening inequalities that favor large institutions.
Additional research on the @limnet architecture could offer potential mitigation through three architectural and practical strengths:

+ Its scalability and lightweight design reduce infrastructure requirements, lowering the barrier to entry.
+ Ongoing efforts to develop decentralized and collaborative versions of @limnet @metasoma could empower communities to deploy models using distributed resources.
+ This project's public availability enhances accessibility for regulators and policymakers, contributing to more informed legislative decision-making in an area still filled with uncertainty.

=== Societal impact

Better observed performances could have contributed to improve the performance and cost of retrieval pipelines, enabling people with better and faster access to information at a reduced cost.
Unfortunately, with the underwhelming predictions performed by @limnet compared to the state-of-the-art baseline, this project lost its impact potential and is therefore mostly dedicated to an academic use.

=== Sustainability

While @limnet's efficiency had the potential to reduce the cost of computation, it is still unclear whether improved efficiency translates into net energy savings in the long term @rebound-effect-no-backfire.
This consideration highlights not only the need for continued attention to the ecological impact of machine learning research and deployment, but more importantly the importance of societal awareness about sustainability compared with innovation.
