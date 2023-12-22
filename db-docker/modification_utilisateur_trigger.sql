CREATE FUNCTION modification_utilisateur() RETURNS TRIGGER AS $modif_user$
	BEGIN
		-- Vérifie la colonne nom
		IF OLD.nom IS DISTINCT
		FROM NEW.nom THEN 
		INSERT INTO modifications (id_modification, ancienne_valeur, nouvelle_valeur, id_utilisateur, colonne, date_modification)
		VALUES (DEFAULT, OLD.nom, NEW.nom, new.id_utilisateur, 'nom', DEFAULT);
	END IF;
		-- Vérifie la colonne prenom
		IF OLD.prenom IS DISTINCT
		FROM NEW.prenom THEN 
		INSERT INTO modifications (id_modification, ancienne_valeur, nouvelle_valeur, id_utilisateur, colonne, date_modification)
		VALUES (DEFAULT, OLD.prenom, NEW.prenom, new.id_utilisateur, 'prenom', DEFAULT);
	END IF;
	-- Vérifie la colonne mail
		IF OLD.mail IS DISTINCT
		FROM NEW.mail THEN 
		INSERT INTO modifications (id_modification, ancienne_valeur, nouvelle_valeur, id_utilisateur, colonne, date_modification)
		VALUES (DEFAULT, OLD.mail, NEW.mail, new.id_utilisateur, 'mail', DEFAULT);
	END IF;
	-- Vérifie la colonne mdp
		IF OLD.mdp IS DISTINCT
		FROM NEW.mdp THEN 
		INSERT INTO modifications (id_modification, ancienne_valeur, nouvelle_valeur, id_utilisateur, colonne, date_modification)
		VALUES (DEFAULT, OLD.mdp, NEW.mdp, new.id_utilisateur, 'mdp', DEFAULT);
	END IF;
	-- Vérifie la colonne id_role
		IF OLD.id_role IS DISTINCT
		FROM NEW.id_role THEN 
		INSERT INTO modifications (id_modification, ancienne_valeur, nouvelle_valeur, id_utilisateur, colonne, date_modification)
		VALUES (DEFAULT, OLD.id_role, NEW.id_role, new.id_utilisateur, 'id_role', DEFAULT);
	END IF;
RETURN NEW;
END;
$modif_user$ LANGUAGE plpgsql;

CREATE TRIGGER modification_utilisateur BEFORE UPDATE ON utilisateurs 
	FOR EACH ROW EXECUTE PROCEDURE modification_utilisateur();