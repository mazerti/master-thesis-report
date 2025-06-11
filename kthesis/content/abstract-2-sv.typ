/*
If you are writing your thesis in English, you can leave this until the draft version that goes to your opponent for the written opposition.
In this way, you can provide the English and Swedish abstract/summary information that can be used in the announcement for your oral presentation.
If you are writing your thesis in English, then this section can be a summary targeted at a more general reader.
However, if you are writing your thesis in Swedish, then the reverse is true – your abstract should be for your target audience, while an English summary can be written targeted at a more general audience.
This means that the English abstract and Swedish sammnfattning or Swedish abstract and English summary need not be literal translations of each other.

The abstract in the language used for the thesis should be the first abstract, while the Summary/Sammanfattning in the other language can follow
*/
User-item rekommendation är en central utmaning för sökmotorer, sociala medieplattformar och streamingtjänster, eftersom det kräver att både relationella strukturer och temporala dynamiker modelleras samtidigt.
Många befintliga lösningar hanterar dessa två aspekter separat, vilket begränsar deras förmåga att fullt ut fånga användarbeteenden.

I detta arbete försöker vi överbrygga detta gap genom att utvärdera Lightweight Memory Networks (LiMNet), en modell som är utformad för att bevara kausala samband i sekvenser av temporala interaktioner.
För att undersöka modellens potential utvecklade vi ett benchmark-ramverk för user-item interaktionsprediktion.
Vi jämförde LiMNet med Jodie, en avancerad referensmodell, över tre verkliga datasets: Wikipedia-redigeringar, Reddit-inlägg och musikströmningar från LastFM.
Dessa datasets varierar i skala och interaktionsmönster, vilket ger en bred testbas.

Våra resultat visar att även om LiMNet erbjuder fördelar vad gäller effektivitet och anpassningsbarhet, så presterar den konsekvent sämre än Jodie i prediktiv noggrannhet.
Dessutom antyder våra fynd att det finns en genomgående bias i alla datasets mot kortsiktig global popularitet.
Detta tyder på att befintliga modeller tenderar att överanpassa till nyliga trender snarare än att lära sig användares långsiktiga preferenser, vilket pekar på en potentiell begränsning i nuvarande utvärderingsmetoder.