





## Instabilität der ICD-10-GM


## Überleitungen

Ich war etwas überrascht, dass ich noch nie etwas über dieses Problem gelesen hatte. Mir waren lediglich die Grouper des MorbiRSA and des InBA bekannt, die über einen Zeitraum von drei Jahren eine Reihe von Diagnosen definieren. Einen datengetriebenen und flexiblen Ansatz war mir nicht bekannt.

Erfreulicherweise habe ich erfahren, dass mit den ICD-10-Metadaten auch eine Tabelle mit Überleitungen veröffentlicht wird. Diese dokumentiert für jede Code in der Vorversion den äquivalenten Code in der nächsten Version. Diese Information kann man verwenden, um eine Codeliste zu historisieren.

Ausgehend von einer vorgegebenen ICD-10-Version müssen wir also die automatischen Überleitungen folgen, um die Spezifikation auf anderen Jahren zu übertragen. Ein entsprechender Algorithmus bietet die Funktion `icd_history`.

Nicht immer ist die Überleitung eindeutig. Aus diesem Grund zeigt die Funktion `icd_show_changes` eine Auflistung von allen Codes mit Änderungen in einem definierten Zeitraum. Falls für eine Änderung keine automatische Überleitung vorliegt, kann falls erforderlich eine für das Projekt sinnvolle Überleitung definiert werden.

## Beispiel

Das R-Skript sieht also so aus:

```r
icd_spec <- readr::read_csv("data/metadata/diagnosen.csv") %>%
  ICD10gm::icd_expand(year = 2020, col_meta = "DIAG_LABEL") %>%
	ICD10gm::icd_history(years = 2004:2020)

diagnosedaten %>%
  inner_join(icd_spec, by = "icd_sub") %>%
	select(PID, DIAG_GROUP, ABRQ) %>%
	distinct()
```

Die Auswertung der Diagnosedaten erfolgt dann über ein Join mit dieser spezifikationstabelle. Dies ist erfahrungsgemäß sehr effizient und der Code bleibt verhältnismäßig kurz und übersichtlich.


## Weitere Funktionalität

- `is_icd`: Test, ob ein String das Format eines ICD-Codes entspricht
- `icd_extract`: Extraktion von ICD-10-Codes aus Character-String (z.B. Web-scraping, PDF)
- `is_valid_icd`: Test, ob ein ICD-10-Code tatsächlich in einer vorgegebenen Version existiert


## Fazit und Ausblick

- Das ICD10gm-Package unterstützt die Arbeit mit Diagnosedaten aus Deutschland
- Gerade mit Verlaufsdaten muss auf die Historisierung der ICD-10-Codes geachtet werden.
- Sind ähnliche Strategien bei weiteren Datenquellen möglich (ICD-11, EBM, ATC/PZN, OPS usw)?
- Besonders interessant erscheinen die neuen R-Packages `encoder`und `decoder`, die ein generisches System für den Umgang mit Klassifikationen versprechen.

