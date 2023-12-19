# NetStream
Brief Base de Données Merise


## Requêtes SQL

1. Titres et dates de sorties des films du plus récent au plus ancien.

```  
SELECT titre, date_sortie 
FROM films 
ORDER BY date_sortie ASC;
```

2. Noms/Prénoms/Âge des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique.

```  
SELECT nom, prenom, date_naissance, AGE(CURRENT_DATE, date_naissance) 
AS age 
FROM acteurs 
WHERE AGE(CURRENT_DATE, date_naissance) > '30 years' ORDER BY nom;
```

3. Liste des acteurs/actrices principaux (Protagoniste) pour un film donné.

```  
SELECT * FROM acteurs a 
INNER JOIN posseder p ON a.id_acteur = p.id_acteur 
WHERE id_role = 5 AND id_film = film_choisi;
```

4. Liste des films pour un acteur/actrice donné.

```  
SELECT id_film 
FROM jouer 
WHERE id_acteur = acteur/actrice_choisi(e);
```

5. Ajouter un film.

```  
INSERT INTO films (id_film, titre, duree, date_sortie, id_realisateur)
VALUES (incrémentation, 'titre choisi', 'h:m:s', 'yyyy-mm-dd', id_realisateur);
```

6. Ajouter un acteur/actrice.

```  
INSERT INTO acteurs (id_acteur, nom, prenom, date_naissance)
VALUES (incrementation, 'son nom', 'son prenom', 'yyyy-mm-dd');
```

7. Modifier un film.

```  
UPDATE film
SET titre = nouveau_titre, duree = nouvelle_duree, date_sortie = nouvelle_date, id_realisateur = nouveau_realisateur
WHERE id_film = 'film choisi';
```

8. Supprimer un acteur/actrice.

```  
DELETE FROM acteurs WHERE id_acteur = acteur_choisi;
```

9. Afficher les 3 derniers acteurs/actrices ajouté(e)s.

```  
SELECT * FROM acteurs ORDER BY id_acteur DESC LIMIT 3;
```