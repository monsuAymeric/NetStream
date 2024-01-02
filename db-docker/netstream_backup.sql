--
-- PostgreSQL database cluster dump
--

-- Started on 2023-12-22 10:21:40

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE administrateur;
ALTER ROLE administrateur WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:130vTkgukwClKn4h7qp84Q==$o8JwWM0osa2C3KcRSjsgjMkCl6zm7beMaMMdO40a2+k=:ih64KNWtxrlTnm29qWXkCgNofUiVVSbAmYlcPChwT3w=';
CREATE ROLE client;
ALTER ROLE client WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:HcRWAumVpoSSxzUryHxt8Q==$IDTUSITuvA6FL+CrnQ/emN/ghXLGUJu5MF/YSxgA/F8=:dG/MKglgWwQvATSJRIwJkPnV+IACiTOrXsFoJ5cBxW8=';
CREATE ROLE "user";
ALTER ROLE "user" WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:PJb8RaVqfpGf0sfzEvGAOw==$ZouZUCnGPXAJVa/HblqBRc01RTxOoDBqxuv7s+ndzJA=:A66c/FwHYqn2bxVDNpkPtl5gJbJUDtB4QlFjO7LgPqA=';

--
-- User Configurations
--






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 16.0

-- Started on 2023-12-22 10:21:40

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO "user";

--
-- TOC entry 3305 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: user
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-12-22 10:21:41

--
-- PostgreSQL database dump complete
--

--
-- Database "NetStream" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 16.0

-- Started on 2023-12-22 10:21:41

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3410 (class 1262 OID 16385)
-- Name: NetStream; Type: DATABASE; Schema: -; Owner: user
--

CREATE DATABASE "NetStream" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE "NetStream" OWNER TO "user";

\connect "NetStream"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3411 (class 0 OID 0)
-- Dependencies: 3410
-- Name: DATABASE "NetStream"; Type: COMMENT; Schema: -; Owner: user
--

COMMENT ON DATABASE "NetStream" IS 'Brief BDD Merise NetStream';


--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO "user";

--
-- TOC entry 224 (class 1255 OID 16569)
-- Name: liste_films_par_realisateur(character varying, character varying); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.liste_films_par_realisateur(p_realisateur_nom character varying, p_realisateur_prenom character varying) RETURNS TABLE(titre character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sélectionner les films du réalisateur donné
    RETURN QUERY
    SELECT f.titre
    FROM films f
    JOIN realisateurs r ON f.id_realisateur = r.id_realisateur
    WHERE r.nom = p_realisateur_nom AND r.prenom = p_realisateur_prenom;

END;
$$;


ALTER FUNCTION public.liste_films_par_realisateur(p_realisateur_nom character varying, p_realisateur_prenom character varying) OWNER TO "user";

--
-- TOC entry 237 (class 1255 OID 16581)
-- Name: modification_utilisateur(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.modification_utilisateur() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.modification_utilisateur() OWNER TO "user";

--
-- TOC entry 225 (class 1255 OID 16559)
-- Name: update_modified_at(); Type: FUNCTION; Schema: public; Owner: user
--

CREATE FUNCTION public.update_modified_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.modifie_le := CURRENT_DATE;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_at() OWNER TO "user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 16387)
-- Name: acteurs; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.acteurs (
    id_acteur integer NOT NULL,
    nom character varying(25) NOT NULL,
    prenom character varying(25) NOT NULL,
    date_naissance date NOT NULL
);


ALTER TABLE public.acteurs OWNER TO "user";

--
-- TOC entry 209 (class 1259 OID 16386)
-- Name: acteurs_id_acteur_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.acteurs_id_acteur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.acteurs_id_acteur_seq OWNER TO "user";

--
-- TOC entry 3414 (class 0 OID 0)
-- Dependencies: 209
-- Name: acteurs_id_acteur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.acteurs_id_acteur_seq OWNED BY public.acteurs.id_acteur;


--
-- TOC entry 222 (class 1259 OID 16473)
-- Name: favoriser; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.favoriser (
    id_film integer NOT NULL,
    id_utilisateur integer NOT NULL
);


ALTER TABLE public.favoriser OWNER TO "user";

--
-- TOC entry 216 (class 1259 OID 16408)
-- Name: films; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.films (
    id_film integer NOT NULL,
    titre character varying(50) NOT NULL,
    duree time without time zone NOT NULL,
    date_sortie date NOT NULL,
    id_realisateur integer NOT NULL
);


ALTER TABLE public.films OWNER TO "user";

--
-- TOC entry 215 (class 1259 OID 16407)
-- Name: films_id_film_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.films_id_film_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.films_id_film_seq OWNER TO "user";

--
-- TOC entry 3417 (class 0 OID 0)
-- Dependencies: 215
-- Name: films_id_film_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.films_id_film_seq OWNED BY public.films.id_film;


--
-- TOC entry 221 (class 1259 OID 16458)
-- Name: jouer; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.jouer (
    id_acteur integer NOT NULL,
    id_film integer NOT NULL
);


ALTER TABLE public.jouer OWNER TO "user";

--
-- TOC entry 220 (class 1259 OID 16432)
-- Name: modifications; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.modifications (
    id_modification integer NOT NULL,
    ancienne_valeur character varying(50) NOT NULL,
    nouvelle_valeur character varying(50) NOT NULL,
    id_utilisateur integer NOT NULL,
    colonne character varying(15) NOT NULL,
    date_modification timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.modifications OWNER TO "user";

--
-- TOC entry 219 (class 1259 OID 16431)
-- Name: modifications_id_modification_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.modifications_id_modification_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.modifications_id_modification_seq OWNER TO "user";

--
-- TOC entry 3420 (class 0 OID 0)
-- Dependencies: 219
-- Name: modifications_id_modification_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.modifications_id_modification_seq OWNED BY public.modifications.id_modification;


--
-- TOC entry 223 (class 1259 OID 16531)
-- Name: posseder; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.posseder (
    id_acteur integer NOT NULL,
    id_film integer NOT NULL,
    id_role integer NOT NULL
);


ALTER TABLE public.posseder OWNER TO "user";

--
-- TOC entry 212 (class 1259 OID 16394)
-- Name: realisateurs; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.realisateurs (
    id_realisateur integer NOT NULL,
    nom character varying(25) NOT NULL,
    prenom character varying(25) NOT NULL
);


ALTER TABLE public.realisateurs OWNER TO "user";

--
-- TOC entry 211 (class 1259 OID 16393)
-- Name: realisateurs_id_realisateur_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.realisateurs_id_realisateur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.realisateurs_id_realisateur_seq OWNER TO "user";

--
-- TOC entry 3423 (class 0 OID 0)
-- Dependencies: 211
-- Name: realisateurs_id_realisateur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.realisateurs_id_realisateur_seq OWNED BY public.realisateurs.id_realisateur;


--
-- TOC entry 214 (class 1259 OID 16401)
-- Name: roles; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.roles (
    id_role integer NOT NULL,
    nom character varying(25)
);


ALTER TABLE public.roles OWNER TO "user";

--
-- TOC entry 213 (class 1259 OID 16400)
-- Name: role_id_role_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.role_id_role_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_id_role_seq OWNER TO "user";

--
-- TOC entry 3425 (class 0 OID 0)
-- Dependencies: 213
-- Name: role_id_role_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.role_id_role_seq OWNED BY public.roles.id_role;


--
-- TOC entry 218 (class 1259 OID 16420)
-- Name: utilisateurs; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE public.utilisateurs (
    id_utilisateur integer NOT NULL,
    nom character varying(25) NOT NULL,
    prenom character varying(25) NOT NULL,
    mail character varying(50) NOT NULL,
    mdp character varying(100) NOT NULL,
    id_role integer NOT NULL,
    utilisateur_cree timestamp without time zone NOT NULL,
    modifie_le date
);


ALTER TABLE public.utilisateurs OWNER TO "user";

--
-- TOC entry 217 (class 1259 OID 16419)
-- Name: utilisateur_id_utilisateur_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE public.utilisateur_id_utilisateur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.utilisateur_id_utilisateur_seq OWNER TO "user";

--
-- TOC entry 3427 (class 0 OID 0)
-- Dependencies: 217
-- Name: utilisateur_id_utilisateur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE public.utilisateur_id_utilisateur_seq OWNED BY public.utilisateurs.id_utilisateur;


--
-- TOC entry 3206 (class 2604 OID 16390)
-- Name: acteurs id_acteur; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.acteurs ALTER COLUMN id_acteur SET DEFAULT nextval('public.acteurs_id_acteur_seq'::regclass);


--
-- TOC entry 3209 (class 2604 OID 16411)
-- Name: films id_film; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.films ALTER COLUMN id_film SET DEFAULT nextval('public.films_id_film_seq'::regclass);


--
-- TOC entry 3211 (class 2604 OID 16435)
-- Name: modifications id_modification; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.modifications ALTER COLUMN id_modification SET DEFAULT nextval('public.modifications_id_modification_seq'::regclass);


--
-- TOC entry 3207 (class 2604 OID 16397)
-- Name: realisateurs id_realisateur; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.realisateurs ALTER COLUMN id_realisateur SET DEFAULT nextval('public.realisateurs_id_realisateur_seq'::regclass);


--
-- TOC entry 3208 (class 2604 OID 16404)
-- Name: roles id_role; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.roles ALTER COLUMN id_role SET DEFAULT nextval('public.role_id_role_seq'::regclass);


--
-- TOC entry 3210 (class 2604 OID 16423)
-- Name: utilisateurs id_utilisateur; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.utilisateurs ALTER COLUMN id_utilisateur SET DEFAULT nextval('public.utilisateur_id_utilisateur_seq'::regclass);


--
-- TOC entry 3391 (class 0 OID 16387)
-- Dependencies: 210
-- Data for Name: acteurs; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.acteurs (id_acteur, nom, prenom, date_naissance) FROM stdin;
1	Worthington	Sam	1976-08-02
2	Saldana	Zoe	1978-06-19
3	Weaver	Sigourney	1949-10-08
4	Rodriguez	Michelle	1978-07-12
5	Moore	Joel David	1977-09-25
6	Lang	Stephen	1952-07-11
7	Studi	Wes	1947-12-17
8	Alonso	Laz	1974-03-25
9	Pounder	Carol Christine Hilaria	1952-12-25
10	Ribisi	Giovanni	1974-12-17
11	McConaughey	Matthew	1969-11-04
12	Chastain	Jessica	1977-03-24
13	Hathaway	Anne	1982-11-12
14	Chalamet	Timothée	1995-12-27
15	Foy	Mackenzie	2000-11-10
16	Damon	Matt	1970-10-08
17	Caine	Michael	1933-03-14
18	Lithgow	John	1945-10-19
19	Bentley	Wes	1978-09-04
20	Gyasi	David	1980-01-02
\.


--
-- TOC entry 3403 (class 0 OID 16473)
-- Dependencies: 222
-- Data for Name: favoriser; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.favoriser (id_film, id_utilisateur) FROM stdin;
\.


--
-- TOC entry 3397 (class 0 OID 16408)
-- Dependencies: 216
-- Data for Name: films; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.films (id_film, titre, duree, date_sortie, id_realisateur) FROM stdin;
1	Avatar	02:42:00	2009-12-16	1
2	Interstellar	02:49:00	2014-11-05	2
\.


--
-- TOC entry 3402 (class 0 OID 16458)
-- Dependencies: 221
-- Data for Name: jouer; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.jouer (id_acteur, id_film) FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	1
9	1
10	1
11	2
12	2
13	2
14	2
15	2
16	2
17	2
18	2
19	2
20	2
\.


--
-- TOC entry 3401 (class 0 OID 16432)
-- Dependencies: 220
-- Data for Name: modifications; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.modifications (id_modification, ancienne_valeur, nouvelle_valeur, id_utilisateur, colonne, date_modification) FROM stdin;
2	Aymeric	truc	1	prenom	2023-12-22 09:01:36.943543
3	monsu	de luxe	1	nom	2023-12-22 09:03:13.334149
4	truc	pute	1	prenom	2023-12-22 09:03:13.334149
5	de luxe	MONSU	1	nom	2023-12-22 09:06:37.248503
6	pute	Aymeric	1	prenom	2023-12-22 09:06:37.248503
\.


--
-- TOC entry 3404 (class 0 OID 16531)
-- Dependencies: 223
-- Data for Name: posseder; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.posseder (id_acteur, id_film, id_role) FROM stdin;
1	1	5
2	1	5
3	1	9
4	1	7
5	1	7
6	1	6
7	1	7
8	1	7
9	1	7
10	1	7
11	2	5
12	2	5
13	2	7
14	2	7
15	2	7
16	2	6
17	2	9
18	2	9
19	2	7
20	2	7
\.


--
-- TOC entry 3393 (class 0 OID 16394)
-- Dependencies: 212
-- Data for Name: realisateurs; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.realisateurs (id_realisateur, nom, prenom) FROM stdin;
1	Cameron	James
2	Nolan	Christopher
\.


--
-- TOC entry 3395 (class 0 OID 16401)
-- Dependencies: 214
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.roles (id_role, nom) FROM stdin;
1	Administrateur
2	Visiteur
3	Utilisateur Enregistré
4	Abonné
5	Protagoniste
6	Antagoniste
7	Second Rôle
8	Figurant
9	Mentor
\.


--
-- TOC entry 3399 (class 0 OID 16420)
-- Dependencies: 218
-- Data for Name: utilisateurs; Type: TABLE DATA; Schema: public; Owner: user
--

COPY public.utilisateurs (id_utilisateur, nom, prenom, mail, mdp, id_role, utilisateur_cree, modifie_le) FROM stdin;
1	MONSU	Aymeric	monsu.aymeric@gmail.com	81dc9bdb52d04dc20036dbd8313ed055	1	2023-12-21 14:11:58	2023-12-22
\.


--
-- TOC entry 3428 (class 0 OID 0)
-- Dependencies: 209
-- Name: acteurs_id_acteur_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.acteurs_id_acteur_seq', 1, true);


--
-- TOC entry 3429 (class 0 OID 0)
-- Dependencies: 215
-- Name: films_id_film_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.films_id_film_seq', 1, false);


--
-- TOC entry 3430 (class 0 OID 0)
-- Dependencies: 219
-- Name: modifications_id_modification_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.modifications_id_modification_seq', 6, true);


--
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 211
-- Name: realisateurs_id_realisateur_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.realisateurs_id_realisateur_seq', 1, false);


--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 213
-- Name: role_id_role_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.role_id_role_seq', 1, true);


--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 217
-- Name: utilisateur_id_utilisateur_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('public.utilisateur_id_utilisateur_seq', 1, true);


--
-- TOC entry 3214 (class 2606 OID 16392)
-- Name: acteurs acteurs_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.acteurs
    ADD CONSTRAINT acteurs_pkey PRIMARY KEY (id_acteur);


--
-- TOC entry 3228 (class 2606 OID 16477)
-- Name: favoriser favoriser_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.favoriser
    ADD CONSTRAINT favoriser_pkey PRIMARY KEY (id_film, id_utilisateur);


--
-- TOC entry 3220 (class 2606 OID 16413)
-- Name: films films_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.films
    ADD CONSTRAINT films_pkey PRIMARY KEY (id_film);


--
-- TOC entry 3226 (class 2606 OID 16462)
-- Name: jouer jouer_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.jouer
    ADD CONSTRAINT jouer_pkey PRIMARY KEY (id_acteur, id_film);


--
-- TOC entry 3224 (class 2606 OID 16437)
-- Name: modifications modifications_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.modifications
    ADD CONSTRAINT modifications_pkey PRIMARY KEY (id_modification);


--
-- TOC entry 3230 (class 2606 OID 16535)
-- Name: posseder posseder_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.posseder
    ADD CONSTRAINT posseder_pkey PRIMARY KEY (id_acteur, id_film, id_role);


--
-- TOC entry 3216 (class 2606 OID 16399)
-- Name: realisateurs realisateurs_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.realisateurs
    ADD CONSTRAINT realisateurs_pkey PRIMARY KEY (id_realisateur);


--
-- TOC entry 3218 (class 2606 OID 16406)
-- Name: roles role_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT role_pkey PRIMARY KEY (id_role);


--
-- TOC entry 3222 (class 2606 OID 16425)
-- Name: utilisateurs utilisateur_pkey; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (id_utilisateur);


--
-- TOC entry 3245 (class 2620 OID 16582)
-- Name: utilisateurs modification_utilisateur; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER modification_utilisateur BEFORE UPDATE ON public.utilisateurs FOR EACH ROW EXECUTE FUNCTION public.modification_utilisateur();


--
-- TOC entry 3241 (class 2620 OID 16560)
-- Name: acteurs trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public.acteurs FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3249 (class 2620 OID 16561)
-- Name: favoriser trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public.favoriser FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3244 (class 2620 OID 16562)
-- Name: films trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public.films FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3248 (class 2620 OID 16563)
-- Name: jouer trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public.jouer FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3247 (class 2620 OID 16568)
-- Name: modifications trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public.modifications FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3250 (class 2620 OID 16564)
-- Name: posseder trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public.posseder FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3242 (class 2620 OID 16565)
-- Name: realisateurs trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public.realisateurs FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3243 (class 2620 OID 16566)
-- Name: roles trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public.roles FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3246 (class 2620 OID 16567)
-- Name: utilisateurs trigger_update_modified_at; Type: TRIGGER; Schema: public; Owner: user
--

CREATE TRIGGER trigger_update_modified_at BEFORE UPDATE ON public.utilisateurs FOR EACH ROW EXECUTE FUNCTION public.update_modified_at();


--
-- TOC entry 3236 (class 2606 OID 16478)
-- Name: favoriser favoriser_id_film_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.favoriser
    ADD CONSTRAINT favoriser_id_film_fkey FOREIGN KEY (id_film) REFERENCES public.films(id_film);


--
-- TOC entry 3237 (class 2606 OID 16483)
-- Name: favoriser favoriser_id_utilisateur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.favoriser
    ADD CONSTRAINT favoriser_id_utilisateur_fkey FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateurs(id_utilisateur);


--
-- TOC entry 3231 (class 2606 OID 16414)
-- Name: films films_id_realisateur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.films
    ADD CONSTRAINT films_id_realisateur_fkey FOREIGN KEY (id_realisateur) REFERENCES public.realisateurs(id_realisateur);


--
-- TOC entry 3234 (class 2606 OID 16463)
-- Name: jouer jouer_id_acteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.jouer
    ADD CONSTRAINT jouer_id_acteur_fkey FOREIGN KEY (id_acteur) REFERENCES public.acteurs(id_acteur);


--
-- TOC entry 3235 (class 2606 OID 16468)
-- Name: jouer jouer_id_film_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.jouer
    ADD CONSTRAINT jouer_id_film_fkey FOREIGN KEY (id_film) REFERENCES public.films(id_film);


--
-- TOC entry 3233 (class 2606 OID 16438)
-- Name: modifications modifications_id_utilisateur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.modifications
    ADD CONSTRAINT modifications_id_utilisateur_fkey FOREIGN KEY (id_utilisateur) REFERENCES public.utilisateurs(id_utilisateur);


--
-- TOC entry 3238 (class 2606 OID 16536)
-- Name: posseder posseder_id_acteur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.posseder
    ADD CONSTRAINT posseder_id_acteur_fkey FOREIGN KEY (id_acteur) REFERENCES public.acteurs(id_acteur);


--
-- TOC entry 3239 (class 2606 OID 16541)
-- Name: posseder posseder_id_film_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.posseder
    ADD CONSTRAINT posseder_id_film_fkey FOREIGN KEY (id_film) REFERENCES public.films(id_film);


--
-- TOC entry 3240 (class 2606 OID 16546)
-- Name: posseder posseder_id_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.posseder
    ADD CONSTRAINT posseder_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.roles(id_role);


--
-- TOC entry 3232 (class 2606 OID 16426)
-- Name: utilisateurs utilisateur_id_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateur_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.roles(id_role);


--
-- TOC entry 3412 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: user
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3413 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE acteurs; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT ON TABLE public.acteurs TO client;


--
-- TOC entry 3415 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE favoriser; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT ON TABLE public.favoriser TO client;


--
-- TOC entry 3416 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE films; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT ON TABLE public.films TO client;


--
-- TOC entry 3418 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE jouer; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT ON TABLE public.jouer TO client;


--
-- TOC entry 3419 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE modifications; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT ON TABLE public.modifications TO client;


--
-- TOC entry 3421 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE posseder; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT ON TABLE public.posseder TO client;


--
-- TOC entry 3422 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE realisateurs; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT ON TABLE public.realisateurs TO client;


--
-- TOC entry 3424 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT ON TABLE public.roles TO client;


--
-- TOC entry 3426 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE utilisateurs; Type: ACL; Schema: public; Owner: user
--

GRANT SELECT ON TABLE public.utilisateurs TO client;


-- Completed on 2023-12-22 10:21:41

--
-- PostgreSQL database dump complete
--

--
-- Database "db" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 16.0

-- Started on 2023-12-22 10:21:41

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3305 (class 1262 OID 16384)
-- Name: db; Type: DATABASE; Schema: -; Owner: user
--

CREATE DATABASE db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE db OWNER TO "user";

\connect db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO "user";

--
-- TOC entry 3306 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: user
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-12-22 10:21:41

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 16.0

-- Started on 2023-12-22 10:21:41

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO "user";

--
-- TOC entry 3305 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: user
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-12-22 10:21:41

--
-- PostgreSQL database dump complete
--

-- Completed on 2023-12-22 10:21:41

--
-- PostgreSQL database cluster dump complete
--

