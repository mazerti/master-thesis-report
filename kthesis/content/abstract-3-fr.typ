La recommandation d'information représente un défi majeur pour les moteurs de recherche, les plateformes de réseaux sociaux et les services de streaming, car elle nécessite de modéliser à la fois les structures relationnelles et les dynamiques temporelles.
De nombreuses solutions existantes traitent ces deux aspects séparément, ce qui limite leur capacité à capturer pleinement le comportement des utilisateurs.

Dans ce travail, nous cherchons à combler cette lacune en évaluant Lightweight Memory Networks (LiMNet), un modèle conçu pour préserver les relations causales dans les séquences d'interactions temporelles.
Pour évaluer son potentiel, nous avons développé un framework pour l'évaluation de prédiction d'interaction.
Nous avons comparé LiMNet à Jodie, un modeèle de référence, sur trois jeux de données réels : des modifications de pages Wikipédia, des publications Reddit et des streams de musique sur LastFM.
Ces jeux de données diffèrent en termes d'échelle et de types d'interaction, offrant ainsi un support varié pour tester les modèles.

Nos résultats montrent que, bien que LiMNet présente des avantages en matière d'efficacité et de flexibilité, il affiche systématiquement des performances inférieures à celles de Jodie en termes de précision prédictive.
Par ailleurs, nos observations suggèrent un biais constant dans tous les jeux de données en faveur des tendances globales à court terme.
Cela suggère que les comportement rassemblés dans les jeux de données utilisés pourraient s'expliquer majoritairement par des phénomènes de courte durée, au détriment de phénomènes plus profonds causés par les préférences des utilisateurs à long terme — une limite potentielle des paradigmes d'évaluation actuels.
