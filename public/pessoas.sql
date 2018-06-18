--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Ubuntu 10.4-2.pgdg18.04+1)
-- Dumped by pg_dump version 10.4 (Ubuntu 10.4-2.pgdg18.04+1)

-- Started on 2018-06-15 16:20:35 -03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 17273)
-- Name: pessoas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pessoas;


ALTER SCHEMA pessoas OWNER TO postgres;

--
-- TOC entry 638 (class 1247 OID 17275)
-- Name: nacionalidade_pessoa; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.nacionalidade_pessoa AS ENUM (
    'BRASILEIRA',
    'ESTRANGEIRA'
);


ALTER TYPE pessoas.nacionalidade_pessoa OWNER TO postgres;

--
-- TOC entry 641 (class 1247 OID 17280)
-- Name: tipo_contato; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.tipo_contato AS ENUM (
    'E-MAIL',
    'CELULAR',
    'TELEFONE FIXO',
    'SKYPE'
);


ALTER TYPE pessoas.tipo_contato OWNER TO postgres;

--
-- TOC entry 644 (class 1247 OID 17290)
-- Name: tipo_contato_pessoa; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.tipo_contato_pessoa AS ENUM (
    'CONTATO TÉCNICO',
    'CONTATATO FINANCEIRO',
    'CONTATO EMERGENCIAL',
    'CONTATO ADMINISTRATIVO',
    'PESSOAL'
);


ALTER TYPE pessoas.tipo_contato_pessoa OWNER TO postgres;

--
-- TOC entry 659 (class 1247 OID 17368)
-- Name: tipo_documento; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.tipo_documento AS ENUM (
    'RG',
    'CPF',
    'CNPJ',
    'INSCRIÇÃO MUNICIPAL',
    'INSCRIÇÃO ESTADUAL',
    'CERTIDÃO DE NASCIMENTO',
    'CARTEIRA DE HABILITAÇÃO',
    'CARTEIRA DE TRABALHO',
    'CERTIFICADO DE RESERVISTA'
);


ALTER TYPE pessoas.tipo_documento OWNER TO postgres;

--
-- TOC entry 647 (class 1247 OID 17302)
-- Name: tipo_endereco_pessoa; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.tipo_endereco_pessoa AS ENUM (
    'COMERCIAL',
    'RESIDENCIAL',
    'COBRANÇA'
);


ALTER TYPE pessoas.tipo_endereco_pessoa OWNER TO postgres;

--
-- TOC entry 650 (class 1247 OID 17310)
-- Name: tipo_nome_pessoa; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.tipo_nome_pessoa AS ENUM (
    'RAZÃO SOCIAL',
    'NOME FANTASIA',
    'NOME',
    'USERNAME',
    'NICKNAME'
);


ALTER TYPE pessoas.tipo_nome_pessoa OWNER TO postgres;

--
-- TOC entry 653 (class 1247 OID 17322)
-- Name: tipo_pessoa; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.tipo_pessoa AS ENUM (
    'JURÍDICA',
    'FÍSICA',
    'USUÁRIO'
);


ALTER TYPE pessoas.tipo_pessoa OWNER TO postgres;

--
-- TOC entry 656 (class 1247 OID 17330)
-- Name: tipo_relacionamento_pessoa; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.tipo_relacionamento_pessoa AS ENUM (
    'AMIGO',
    'PARENTE',
    'CONJUGE',
    'FILHO',
    'SÓCIO',
    'COLABORADOR',
    'CONTATO TÉCNICO',
    'CONTATATO FINANCEIRO',
    'CONTATO EMERGENCIAL',
    'CONTATO ADMINISTRATIVO',
    'SECRETÁRIO',
    'MATRIZ',
    'FILIAL',
    'FRANQUIA',
    'TERCEIRIZADA',
    'PAI',
    'MÃE',
    'IRMÃO'
);


ALTER TYPE pessoas.tipo_relacionamento_pessoa OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 221 (class 1259 OID 17416)
-- Name: documento; Type: TABLE; Schema: pessoas; Owner: postgres
--

CREATE TABLE pessoas.documento (
    id integer NOT NULL,
    id_pessoa integer NOT NULL,
    tipo pessoas.tipo_documento NOT NULL,
    data_cadastro timestamp(0) without time zone NOT NULL,
    valor character varying(255) NOT NULL
);


ALTER TABLE pessoas.documento OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17414)
-- Name: documento_id_seq; Type: SEQUENCE; Schema: pessoas; Owner: postgres
--

CREATE SEQUENCE pessoas.documento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pessoas.documento_id_seq OWNER TO postgres;

--
-- TOC entry 3031 (class 0 OID 0)
-- Dependencies: 220
-- Name: documento_id_seq; Type: SEQUENCE OWNED BY; Schema: pessoas; Owner: postgres
--

ALTER SEQUENCE pessoas.documento_id_seq OWNED BY pessoas.documento.id;


--
-- TOC entry 219 (class 1259 OID 17400)
-- Name: endereco; Type: TABLE; Schema: pessoas; Owner: postgres
--

CREATE TABLE pessoas.endereco (
    id integer NOT NULL,
    id_pessoa integer NOT NULL,
    tipo pessoas.tipo_endereco_pessoa NOT NULL,
    pais character varying(150) NOT NULL,
    estado character varying(150) NOT NULL,
    uf character varying(5) NOT NULL,
    cidade character varying(150) NOT NULL,
    bairro character varying(150) NOT NULL,
    logradouro character varying(150) NOT NULL,
    numero character varying(10) NOT NULL,
    cep character varying(20) NOT NULL,
    localizacao point,
    complemento text
);


ALTER TABLE pessoas.endereco OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17398)
-- Name: endereco_id_seq; Type: SEQUENCE; Schema: pessoas; Owner: postgres
--

CREATE SEQUENCE pessoas.endereco_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pessoas.endereco_id_seq OWNER TO postgres;

--
-- TOC entry 3032 (class 0 OID 0)
-- Dependencies: 218
-- Name: endereco_id_seq; Type: SEQUENCE OWNED BY; Schema: pessoas; Owner: postgres
--

ALTER SEQUENCE pessoas.endereco_id_seq OWNED BY pessoas.endereco.id;


--
-- TOC entry 223 (class 1259 OID 17429)
-- Name: nome; Type: TABLE; Schema: pessoas; Owner: postgres
--

CREATE TABLE pessoas.nome (
    id integer NOT NULL,
    id_pessoa integer NOT NULL,
    tipo pessoas.tipo_nome_pessoa NOT NULL,
    nome character varying(255) NOT NULL
);


ALTER TABLE pessoas.nome OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17427)
-- Name: nome_id_seq; Type: SEQUENCE; Schema: pessoas; Owner: postgres
--

CREATE SEQUENCE pessoas.nome_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pessoas.nome_id_seq OWNER TO postgres;

--
-- TOC entry 3033 (class 0 OID 0)
-- Dependencies: 222
-- Name: nome_id_seq; Type: SEQUENCE OWNED BY; Schema: pessoas; Owner: postgres
--

ALTER SEQUENCE pessoas.nome_id_seq OWNED BY pessoas.nome.id;


--
-- TOC entry 217 (class 1259 OID 17389)
-- Name: pessoa; Type: TABLE; Schema: pessoas; Owner: postgres
--

CREATE TABLE pessoas.pessoa (
    id integer NOT NULL,
    tipo pessoas.tipo_pessoa NOT NULL,
    nacionalidade pessoas.nacionalidade_pessoa NOT NULL,
    data_aniversario timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    data_cadastro timestamp(0) without time zone DEFAULT now() NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE pessoas.pessoa OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17387)
-- Name: pessoa_id_seq; Type: SEQUENCE; Schema: pessoas; Owner: postgres
--

CREATE SEQUENCE pessoas.pessoa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pessoas.pessoa_id_seq OWNER TO postgres;

--
-- TOC entry 3034 (class 0 OID 0)
-- Dependencies: 216
-- Name: pessoa_id_seq; Type: SEQUENCE OWNED BY; Schema: pessoas; Owner: postgres
--

ALTER SEQUENCE pessoas.pessoa_id_seq OWNED BY pessoas.pessoa.id;


--
-- TOC entry 224 (class 1259 OID 17440)
-- Name: pessoa_to_pessoa; Type: TABLE; Schema: pessoas; Owner: postgres
--

CREATE TABLE pessoas.pessoa_to_pessoa (
    id_pessoa integer NOT NULL,
    id_relacao integer NOT NULL,
    tipo pessoas.tipo_relacionamento_pessoa NOT NULL
);


ALTER TABLE pessoas.pessoa_to_pessoa OWNER TO postgres;

--
-- TOC entry 2886 (class 2604 OID 17419)
-- Name: documento id; Type: DEFAULT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.documento ALTER COLUMN id SET DEFAULT nextval('pessoas.documento_id_seq'::regclass);


--
-- TOC entry 2885 (class 2604 OID 17403)
-- Name: endereco id; Type: DEFAULT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.endereco ALTER COLUMN id SET DEFAULT nextval('pessoas.endereco_id_seq'::regclass);


--
-- TOC entry 2887 (class 2604 OID 17432)
-- Name: nome id; Type: DEFAULT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.nome ALTER COLUMN id SET DEFAULT nextval('pessoas.nome_id_seq'::regclass);


--
-- TOC entry 2881 (class 2604 OID 17392)
-- Name: pessoa id; Type: DEFAULT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa ALTER COLUMN id SET DEFAULT nextval('pessoas.pessoa_id_seq'::regclass);


--
-- TOC entry 2893 (class 2606 OID 17421)
-- Name: documento documento_pkey; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.documento
    ADD CONSTRAINT documento_pkey PRIMARY KEY (id);


--
-- TOC entry 2895 (class 2606 OID 24577)
-- Name: documento documento_un; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.documento
    ADD CONSTRAINT documento_un UNIQUE (id_pessoa, tipo);


--
-- TOC entry 2891 (class 2606 OID 17408)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- TOC entry 2897 (class 2606 OID 17434)
-- Name: nome nome_pkey; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.nome
    ADD CONSTRAINT nome_pkey PRIMARY KEY (id);


--
-- TOC entry 2889 (class 2606 OID 17397)
-- Name: pessoa pessoa_pkey; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (id);


--
-- TOC entry 2899 (class 2606 OID 17444)
-- Name: pessoa_to_pessoa pessoa_to_pessoa_pkey; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa_to_pessoa
    ADD CONSTRAINT pessoa_to_pessoa_pkey PRIMARY KEY (id_pessoa, id_relacao);


--
-- TOC entry 2901 (class 2606 OID 17422)
-- Name: documento documento_id_pessoa; Type: FK CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.documento
    ADD CONSTRAINT documento_id_pessoa FOREIGN KEY (id_pessoa) REFERENCES pessoas.pessoa(id);


--
-- TOC entry 2900 (class 2606 OID 17409)
-- Name: endereco endereco_id_pessoa_fkey; Type: FK CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.endereco
    ADD CONSTRAINT endereco_id_pessoa_fkey FOREIGN KEY (id_pessoa) REFERENCES pessoas.pessoa(id);


--
-- TOC entry 2902 (class 2606 OID 17435)
-- Name: nome nome_id_pessoa_fkey; Type: FK CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.nome
    ADD CONSTRAINT nome_id_pessoa_fkey FOREIGN KEY (id_pessoa) REFERENCES pessoas.pessoa(id);


--
-- TOC entry 2903 (class 2606 OID 17445)
-- Name: pessoa_to_pessoa pessoa_to_pessoa_id_pessoa_fkey; Type: FK CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa_to_pessoa
    ADD CONSTRAINT pessoa_to_pessoa_id_pessoa_fkey FOREIGN KEY (id_pessoa) REFERENCES pessoas.pessoa(id);


--
-- TOC entry 2904 (class 2606 OID 17450)
-- Name: pessoa_to_pessoa pessoa_to_pessoa_id_pessoa_realacao_fkey; Type: FK CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa_to_pessoa
    ADD CONSTRAINT pessoa_to_pessoa_id_pessoa_realacao_fkey FOREIGN KEY (id_relacao) REFERENCES pessoas.pessoa(id);


-- Completed on 2018-06-15 16:20:35 -03

--
-- PostgreSQL database dump complete
--

