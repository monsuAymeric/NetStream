## NetStream
```
  /$$$$$$  /$$$$$$$   /$$$$$$        /$$      /$$ /$$$$$$$$ /$$$$$$$  /$$$$$$  /$$$$$$  /$$$$$$$$
 /$$__  $$| $$__  $$ /$$__  $$      | $$$    /$$$| $$_____/| $$__  $$|_  $$_/ /$$__  $$| $$_____/
| $$  \__/| $$  \ $$| $$  \ $$      | $$$$  /$$$$| $$      | $$  \ $$  | $$  | $$  \__/| $$      
| $$      | $$  | $$| $$$$$$$$      | $$ $$/$$ $$| $$$$$   | $$$$$$$/  | $$  |  $$$$$$ | $$$$$   
| $$      | $$  | $$| $$__  $$      | $$  $$$| $$| $$__/   | $$__  $$  | $$   \____  $$| $$__/   
| $$    $$| $$  | $$| $$  | $$      | $$\  $ | $$| $$      | $$  \ $$  | $$   /$$  \ $$| $$      
|  $$$$$$/| $$$$$$$/| $$  | $$      | $$ \/  | $$| $$$$$$$$| $$  | $$ /$$$$$$|  $$$$$$/| $$$$$$$$
 \______/ |_______/ |__/  |__/      |__/     |__/|________/|__/  |__/|______/ \______/ |________/
 ``` 
 
# Brief Base de Données Merise

Il nous a été demander de créer une base de données sur le thème d'un site de streaming (NetStream) qui regroupera :
<li>Les films</li>
<li>Les acteurs qui ont joué dans ces films ainsi que leur rôles</li>
<li>Les réalisateurs qui ont réalisé ces films</li>
<li>Les utilisateurs qui utiliseront ce site</li>
<br>
Ainsi que quelques manipulations avancées :
<li>Lister grâce à une procédure (FONCTION) stockée, les films d'un réalisateur donné en paramètre</li>
<li>Garder grâce à un trigger une trace de toutes modifications apportées à la table des utilisateurs</li>
<li>Une table d'archive qui conservera la date de la MAJ, l'identifiant de l'utilisateur concerné, l'ancienne et nouvelle valeur</li>
<br>
Base de données effectuée en environnement Docker, avec la méthode Merise et PostGreSQL en tant que SGBD avec le logiciel PgAdmin

# Contenus du Dépôt

Dans ce dépôt Github, il y auras :
<li>L'environnement Docker (db-docker/docker-compose.yml)</li>
<li>Le fichier de conception de la base de Données créé avec le logiciel Looping(Merise/NetStream_MCD_MLD.loo)</li>
<li>Le Dictionnaire de Données (DD_Brief_Merise.pdf)</li>
<li>Le MCD (Modèle Conceptuel de Données (Merise/MCD.png))</li>
<li>Le MLD (Modèle Logique de Données (Merise/MLD.png + Merise/MLD_graph.png))</li>
<li>Le MPD (Modèle Physique de Données(Merise/MPD.png))</li>
<li>Le Script de génération de la DB (netstream_backup.sql)</li>
<li>Le README.md avec une description du projet et les requêtes SQL demandées (C'est ce que tu lis :D)
<li>Aperçu de la grille d'évaluation (grille_evaluation_merise.pdf)</li>
</li style="text-align:center;"> ---> <a href="https://docs.google.com/spreadsheets/d/147PGlYBUetaSLrmVvML7RWyfWAi7CRKdZ2ER823TZco/edit?usp=sharing">Grille d'évaluation</a> <---</li>

## Requêtes SQL

1. Titres et dates de sorties des films du plus récent au plus ancien.

``` sql 
SELECT titre, date_sortie 
FROM films 
ORDER BY date_sortie ASC;
```

2. Noms/Prénoms/Âge des acteurs/actrices de plus de 30 ans dans l'ordre alphabétique.

``` sql
SELECT nom, prenom, date_naissance, AGE(CURRENT_DATE, date_naissance) 
AS age 
FROM acteurs 
WHERE AGE(CURRENT_DATE, date_naissance) > '30 years' ORDER BY nom;
```

3. Liste des acteurs/actrices principaux (Protagoniste) pour un film donné.

``` sql
SELECT f.titre, r.nom, a.nom, a.prenom, a.date_naissance from acteurs a
INNER JOIN posseder p ON a.id_acteur = p.id_acteur
INNER JOIN films f ON p.id_film = f.id_film
INNER JOIN roles r ON p.id_role = r.id_role
WHERE r.nom = 'Protagoniste' AND f.titre = 'Titre du film';
```

4. Liste des films pour un acteur/actrice donné.

``` sql
SELECT titre from films f
INNER JOIN jouer j ON f.id_film = j.id_film
INNER JOIN acteurs a ON j.id_acteur = a.id_acteur
WHERE a.nom = 'nom de l'acteur';
```

5. Ajouter un film.

``` sql  
INSERT INTO films (id_film, titre, duree, date_sortie, id_realisateur)
VALUES (incrémentation, 'titre choisi', 'h:m:s', 'yyyy-mm-dd', id_realisateur);
```

6. Ajouter un acteur/actrice.

``` sql 
INSERT INTO acteurs (id_acteur, nom, prenom, date_naissance)
VALUES (incrementation, 'son nom', 'son prenom', 'yyyy-mm-dd');
```

7. Modifier un film.

``` sql 
UPDATE film
SET titre = nouveau_titre, duree = nouvelle_duree, date_sortie = nouvelle_date, id_realisateur = nouveau_realisateur
WHERE id_film = 'film choisi';
```

8. Supprimer un acteur/actrice.

``` sql  
DELETE FROM acteurs WHERE id_acteur = acteur_choisi;
```

9. Afficher les 3 derniers acteurs/actrices ajouté(e)s.

``` sql  
SELECT * FROM acteurs ORDER BY id_acteur DESC LIMIT 3;
```