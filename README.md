# NetStream
Brief Base de Données Merise


## Requêtes SQL

1. Titres et dates de sorties des films du plus récent au plus ancien
    ```  
    SELECT titre, date_sortie FROM public.films ORDER BY date_sortie ASC;
    ```
