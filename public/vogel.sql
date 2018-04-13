--
-- PostgreSQL database dump
--

-- Dumped from database version 10.3
-- Dumped by pg_dump version 10.3

-- Started on 2018-04-13 16:03:44 -03

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
-- TOC entry 15 (class 2615 OID 25251)
-- Name: autorizacao; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA autorizacao;


ALTER SCHEMA autorizacao OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 28672)
-- Name: comercial; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA comercial;


ALTER SCHEMA comercial OWNER TO postgres;

--
-- TOC entry 5 (class 2615 OID 33969)
-- Name: contratos; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA contratos;


ALTER SCHEMA contratos OWNER TO postgres;

--
-- TOC entry 6 (class 2615 OID 33597)
-- Name: engenharia; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA engenharia;


ALTER SCHEMA engenharia OWNER TO postgres;

--
-- TOC entry 13 (class 2615 OID 34164)
-- Name: luma; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA luma;


ALTER SCHEMA luma OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 34165)
-- Name: pessoas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA pessoas;


ALTER SCHEMA pessoas OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 33734)
-- Name: prevendas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA prevendas;


ALTER SCHEMA prevendas OWNER TO postgres;

--
-- TOC entry 16 (class 2615 OID 33994)
-- Name: redes; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA redes;


ALTER SCHEMA redes OWNER TO postgres;

--
-- TOC entry 4 (class 2615 OID 25089)
-- Name: troubleticket; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA troubleticket;


ALTER SCHEMA troubleticket OWNER TO postgres;

--
-- TOC entry 1 (class 3079 OID 13955)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 5203 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1397 (class 1247 OID 34250)
-- Name: nacionalidade_pessoa; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.nacionalidade_pessoa AS ENUM (
    'BRASILEIRA',
    'ESTRANGEIRA'
);


ALTER TYPE pessoas.nacionalidade_pessoa OWNER TO postgres;

--
-- TOC entry 1424 (class 1247 OID 34458)
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
-- TOC entry 1421 (class 1247 OID 34446)
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
-- TOC entry 1411 (class 1247 OID 34304)
-- Name: tipo_endereco_pessoa; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.tipo_endereco_pessoa AS ENUM (
    'COMERCIAL',
    'RESIDENCIAL',
    'COBRANÇA'
);


ALTER TYPE pessoas.tipo_endereco_pessoa OWNER TO postgres;

--
-- TOC entry 1400 (class 1247 OID 34256)
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
-- TOC entry 1394 (class 1247 OID 34242)
-- Name: tipo_pessoa; Type: TYPE; Schema: pessoas; Owner: postgres
--

CREATE TYPE pessoas.tipo_pessoa AS ENUM (
    'JURÍDICA',
    'FÍSICA',
    'USUÁRIO'
);


ALTER TYPE pessoas.tipo_pessoa OWNER TO postgres;

--
-- TOC entry 1418 (class 1247 OID 34366)
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

--
-- TOC entry 457 (class 1255 OID 25090)
-- Name: last_update_reports(); Type: FUNCTION; Schema: troubleticket; Owner: postgres
--

CREATE FUNCTION troubleticket.last_update_reports() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    stInsert VARCHAR;
BEGIN
    UPDATE troubleticket.reports SET last_update = NEW.date WHERE reports.id = NEW.report_id;

    RETURN NEW;
END;
$$;


ALTER FUNCTION troubleticket.last_update_reports() OWNER TO postgres;

--
-- TOC entry 462 (class 1255 OID 25091)
-- Name: last_update_update(); Type: FUNCTION; Schema: troubleticket; Owner: postgres
--

CREATE FUNCTION troubleticket.last_update_update() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    stSelect VARCHAR;
    reResult RECORD;
BEGIN
    stSelect := '
        SELECT MAX(date) AS data
             , report_id
          FROM troubleticket.history
      GROUP BY report_id
    ';

    FOR reResult IN EXECUTE stSelect
    LOOP
        RAISE NOTICE 'Executando boletim: %', reResult.report_id::varchar;
        UPDATE troubleticket.reports SET last_update = reResult.data WHERE reports.id = reResult.report_id;
    END LOOP;

    RETURN TRUE;
END;
$$;


ALTER FUNCTION troubleticket.last_update_update() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 440 (class 1259 OID 33983)
-- Name: menu; Type: TABLE; Schema: autorizacao; Owner: postgres
--

CREATE TABLE autorizacao.menu (
    id integer NOT NULL,
    menu_id integer,
    nome character varying(20) NOT NULL,
    ativo boolean NOT NULL,
    lft integer NOT NULL,
    rgt integer NOT NULL
);


ALTER TABLE autorizacao.menu OWNER TO postgres;

--
-- TOC entry 439 (class 1259 OID 33981)
-- Name: menu_id_seq; Type: SEQUENCE; Schema: autorizacao; Owner: postgres
--

CREATE SEQUENCE autorizacao.menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE autorizacao.menu_id_seq OWNER TO postgres;

--
-- TOC entry 5204 (class 0 OID 0)
-- Dependencies: 439
-- Name: menu_id_seq; Type: SEQUENCE OWNED BY; Schema: autorizacao; Owner: postgres
--

ALTER SEQUENCE autorizacao.menu_id_seq OWNED BY autorizacao.menu.id;


--
-- TOC entry 225 (class 1259 OID 25255)
-- Name: regra; Type: TABLE; Schema: autorizacao; Owner: postgres
--

CREATE TABLE autorizacao.regra (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    ativo boolean DEFAULT true
);


ALTER TABLE autorizacao.regra OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25288)
-- Name: regra_id_seq; Type: SEQUENCE; Schema: autorizacao; Owner: postgres
--

CREATE SEQUENCE autorizacao.regra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE autorizacao.regra_id_seq OWNER TO postgres;

--
-- TOC entry 5205 (class 0 OID 0)
-- Dependencies: 228
-- Name: regra_id_seq; Type: SEQUENCE OWNED BY; Schema: autorizacao; Owner: postgres
--

ALTER SEQUENCE autorizacao.regra_id_seq OWNED BY autorizacao.regra.id;


--
-- TOC entry 224 (class 1259 OID 25252)
-- Name: usuario; Type: TABLE; Schema: autorizacao; Owner: postgres
--

CREATE TABLE autorizacao.usuario (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    salt character varying(100) NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    data_cadastro timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE autorizacao.usuario OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25261)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: autorizacao; Owner: postgres
--

CREATE SEQUENCE autorizacao.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE autorizacao.usuario_id_seq OWNER TO postgres;

--
-- TOC entry 5206 (class 0 OID 0)
-- Dependencies: 227
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: autorizacao; Owner: postgres
--

ALTER SEQUENCE autorizacao.usuario_id_seq OWNED BY autorizacao.usuario.id;


--
-- TOC entry 226 (class 1259 OID 25258)
-- Name: usuario_regra; Type: TABLE; Schema: autorizacao; Owner: postgres
--

CREATE TABLE autorizacao.usuario_regra (
    id_usuarios integer NOT NULL,
    id_regras integer NOT NULL,
    valor integer NOT NULL
);


ALTER TABLE autorizacao.usuario_regra OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 28734)
-- Name: activation_deadline; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.activation_deadline (
    state character varying(2) NOT NULL,
    days_deadline integer NOT NULL
);


ALTER TABLE comercial.activation_deadline OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 28741)
-- Name: agreement; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.agreement (
    id integer NOT NULL,
    ip character varying(45) NOT NULL,
    agreed boolean NOT NULL,
    date timestamp(0) without time zone NOT NULL,
    proposal_id integer NOT NULL
);


ALTER TABLE comercial.agreement OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 28739)
-- Name: agreement_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.agreement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.agreement_id_seq OWNER TO postgres;

--
-- TOC entry 5207 (class 0 OID 0)
-- Dependencies: 240
-- Name: agreement_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.agreement_id_seq OWNED BY comercial.agreement.id;


--
-- TOC entry 243 (class 1259 OID 28749)
-- Name: bank_information; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.bank_information (
    id integer NOT NULL,
    cnpj character varying(14) NOT NULL,
    name character varying,
    number character varying(3),
    agency character varying(4),
    account character varying(20)
);


ALTER TABLE comercial.bank_information OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 28747)
-- Name: bank_information_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.bank_information_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.bank_information_id_seq OWNER TO postgres;

--
-- TOC entry 5208 (class 0 OID 0)
-- Dependencies: 242
-- Name: bank_information_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.bank_information_id_seq OWNED BY comercial.bank_information.id;


--
-- TOC entry 238 (class 1259 OID 28724)
-- Name: chance; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance (
    id integer NOT NULL,
    id_prospect integer NOT NULL,
    id_product integer NOT NULL,
    temperature integer NOT NULL,
    active boolean NOT NULL,
    description text,
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    date_update timestamp(0) without time zone,
    id_followup integer,
    id_last_proposal integer,
    service_type integer NOT NULL,
    id_contract integer,
    closing_value numeric,
    closing_date timestamp(0) without time zone
);


ALTER TABLE comercial.chance OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 28760)
-- Name: chance_classification; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance_classification (
    id integer NOT NULL,
    name character varying(250)
);


ALTER TABLE comercial.chance_classification OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 28758)
-- Name: chance_classification_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.chance_classification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.chance_classification_id_seq OWNER TO postgres;

--
-- TOC entry 5209 (class 0 OID 0)
-- Dependencies: 244
-- Name: chance_classification_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.chance_classification_id_seq OWNED BY comercial.chance_classification.id;


--
-- TOC entry 247 (class 1259 OID 28768)
-- Name: chance_closed; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance_closed (
    id integer NOT NULL,
    wallet_id integer,
    date_record timestamp(0) without time zone DEFAULT now(),
    date_approval timestamp(0) without time zone,
    approved_by integer,
    active boolean DEFAULT false,
    chance_id integer,
    date_closed timestamp(0) without time zone,
    description text,
    id_chance_classification integer,
    tag text,
    delta real
);


ALTER TABLE comercial.chance_closed OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 28766)
-- Name: chance_closed_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.chance_closed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.chance_closed_id_seq OWNER TO postgres;

--
-- TOC entry 5210 (class 0 OID 0)
-- Dependencies: 246
-- Name: chance_closed_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.chance_closed_id_seq OWNED BY comercial.chance_closed.id;


--
-- TOC entry 249 (class 1259 OID 28781)
-- Name: chance_contact; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance_contact (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    telephone character varying(15),
    email character varying(120),
    chance_id integer NOT NULL,
    warn boolean DEFAULT true NOT NULL
);


ALTER TABLE comercial.chance_contact OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 28779)
-- Name: chance_contact_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.chance_contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.chance_contact_id_seq OWNER TO postgres;

--
-- TOC entry 5211 (class 0 OID 0)
-- Dependencies: 248
-- Name: chance_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.chance_contact_id_seq OWNED BY comercial.chance_contact.id;


--
-- TOC entry 237 (class 1259 OID 28722)
-- Name: chance_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.chance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.chance_id_seq OWNER TO postgres;

--
-- TOC entry 5212 (class 0 OID 0)
-- Dependencies: 237
-- Name: chance_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.chance_id_seq OWNED BY comercial.chance.id;


--
-- TOC entry 251 (class 1259 OID 28789)
-- Name: chance_inactive; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance_inactive (
    id integer NOT NULL,
    chance_id integer,
    description text,
    record_date timestamp(0) without time zone DEFAULT now(),
    active boolean DEFAULT true
);


ALTER TABLE comercial.chance_inactive OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 28787)
-- Name: chance_inactive_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.chance_inactive_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.chance_inactive_id_seq OWNER TO postgres;

--
-- TOC entry 5213 (class 0 OID 0)
-- Dependencies: 250
-- Name: chance_inactive_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.chance_inactive_id_seq OWNED BY comercial.chance_inactive.id;


--
-- TOC entry 253 (class 1259 OID 28802)
-- Name: chance_inactive_log; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance_inactive_log (
    id integer NOT NULL,
    chance_inactive_id integer,
    date_record timestamp(0) without time zone DEFAULT now(),
    "user" integer,
    ev integer
);


ALTER TABLE comercial.chance_inactive_log OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 28800)
-- Name: chance_inactive_log_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.chance_inactive_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.chance_inactive_log_id_seq OWNER TO postgres;

--
-- TOC entry 5214 (class 0 OID 0)
-- Dependencies: 252
-- Name: chance_inactive_log_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.chance_inactive_log_id_seq OWNED BY comercial.chance_inactive_log.id;


--
-- TOC entry 255 (class 1259 OID 28811)
-- Name: chance_indication; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance_indication (
    id integer NOT NULL,
    type character varying(10),
    who character varying(200),
    email character varying(200),
    id_chance integer,
    warn boolean DEFAULT false
);


ALTER TABLE comercial.chance_indication OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 28809)
-- Name: chance_indication_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.chance_indication_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.chance_indication_id_seq OWNER TO postgres;

--
-- TOC entry 5215 (class 0 OID 0)
-- Dependencies: 254
-- Name: chance_indication_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.chance_indication_id_seq OWNED BY comercial.chance_indication.id;


--
-- TOC entry 257 (class 1259 OID 28820)
-- Name: chance_status; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance_status (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE comercial.chance_status OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 28818)
-- Name: chance_status_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.chance_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.chance_status_id_seq OWNER TO postgres;

--
-- TOC entry 5216 (class 0 OID 0)
-- Dependencies: 256
-- Name: chance_status_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.chance_status_id_seq OWNED BY comercial.chance_status.id;


--
-- TOC entry 258 (class 1259 OID 28827)
-- Name: chance_tag; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance_tag (
    id_chance integer NOT NULL,
    id_tag integer NOT NULL
);


ALTER TABLE comercial.chance_tag OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 28834)
-- Name: chance_type; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.chance_type (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE comercial.chance_type OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 28832)
-- Name: chance_type_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.chance_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.chance_type_id_seq OWNER TO postgres;

--
-- TOC entry 5217 (class 0 OID 0)
-- Dependencies: 259
-- Name: chance_type_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.chance_type_id_seq OWNED BY comercial.chance_type.id;


--
-- TOC entry 262 (class 1259 OID 28842)
-- Name: companies; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.companies (
    id integer NOT NULL,
    name character varying(100),
    spid integer
);


ALTER TABLE comercial.companies OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 28840)
-- Name: companies_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.companies_id_seq OWNER TO postgres;

--
-- TOC entry 5218 (class 0 OID 0)
-- Dependencies: 261
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.companies_id_seq OWNED BY comercial.companies.id;


--
-- TOC entry 264 (class 1259 OID 28850)
-- Name: contract_denial_reason; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.contract_denial_reason (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    contract_denial_reason_category_id integer NOT NULL
);


ALTER TABLE comercial.contract_denial_reason OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 28858)
-- Name: contract_denial_reason_category; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.contract_denial_reason_category (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE comercial.contract_denial_reason_category OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 28856)
-- Name: contract_denial_reason_category_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.contract_denial_reason_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.contract_denial_reason_category_id_seq OWNER TO postgres;

--
-- TOC entry 5219 (class 0 OID 0)
-- Dependencies: 265
-- Name: contract_denial_reason_category_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.contract_denial_reason_category_id_seq OWNED BY comercial.contract_denial_reason_category.id;


--
-- TOC entry 263 (class 1259 OID 28848)
-- Name: contract_denial_reason_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.contract_denial_reason_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.contract_denial_reason_id_seq OWNER TO postgres;

--
-- TOC entry 5220 (class 0 OID 0)
-- Dependencies: 263
-- Name: contract_denial_reason_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.contract_denial_reason_id_seq OWNED BY comercial.contract_denial_reason.id;


--
-- TOC entry 268 (class 1259 OID 28866)
-- Name: costs; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.costs (
    id integer NOT NULL,
    service_id integer,
    interface integer,
    capex_equipament numeric(10,2),
    capex_fiber numeric(10,2),
    ip numeric(10,2),
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    date_end timestamp(0) without time zone DEFAULT NULL::timestamp(0) without time zone
);


ALTER TABLE comercial.costs OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 28864)
-- Name: costs_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.costs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.costs_id_seq OWNER TO postgres;

--
-- TOC entry 5221 (class 0 OID 0)
-- Dependencies: 267
-- Name: costs_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.costs_id_seq OWNED BY comercial.costs.id;


--
-- TOC entry 270 (class 1259 OID 28876)
-- Name: datacenter; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.datacenter (
    id integer NOT NULL,
    nome text,
    uf text,
    cidade integer,
    lat character varying(100),
    lon character varying(100),
    cep text,
    logradouro text,
    numero text,
    complemento text,
    bairro character varying(255)
);


ALTER TABLE comercial.datacenter OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 28874)
-- Name: datacenter_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.datacenter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.datacenter_id_seq OWNER TO postgres;

--
-- TOC entry 5222 (class 0 OID 0)
-- Dependencies: 269
-- Name: datacenter_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.datacenter_id_seq OWNED BY comercial.datacenter.id;


--
-- TOC entry 272 (class 1259 OID 28887)
-- Name: discount_competence; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.discount_competence (
    id integer NOT NULL,
    id_user integer NOT NULL,
    date_record timestamp(6) without time zone NOT NULL,
    active boolean,
    percentage real NOT NULL,
    registrant integer NOT NULL
);


ALTER TABLE comercial.discount_competence OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 28885)
-- Name: discount_competence_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.discount_competence_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.discount_competence_id_seq OWNER TO postgres;

--
-- TOC entry 5223 (class 0 OID 0)
-- Dependencies: 271
-- Name: discount_competence_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.discount_competence_id_seq OWNED BY comercial.discount_competence.id;


--
-- TOC entry 274 (class 1259 OID 28895)
-- Name: discount_proposal; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.discount_proposal (
    id integer NOT NULL,
    user_id integer NOT NULL,
    date_inc timestamp(6) without time zone NOT NULL,
    proposal_id integer NOT NULL,
    tipo character varying(255) NOT NULL,
    descativval numeric(10,2) NOT NULL,
    descativporc numeric(10,2) NOT NULL,
    descmensval numeric(10,2) NOT NULL,
    descmensporc numeric(10,2) NOT NULL,
    motivo character varying(500) NOT NULL,
    status boolean,
    valorativ_atual money NOT NULL,
    valorativ_proposto money NOT NULL,
    valormens_atual money NOT NULL,
    valormens_proposto money NOT NULL,
    proposal_approved integer
);


ALTER TABLE comercial.discount_proposal OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 28893)
-- Name: discount_proposal_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.discount_proposal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.discount_proposal_id_seq OWNER TO postgres;

--
-- TOC entry 5224 (class 0 OID 0)
-- Dependencies: 273
-- Name: discount_proposal_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.discount_proposal_id_seq OWNED BY comercial.discount_proposal.id;


--
-- TOC entry 276 (class 1259 OID 28906)
-- Name: discount_proposal_status; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.discount_proposal_status (
    id integer NOT NULL,
    depr_codigoid integer NOT NULL,
    user_id smallint NOT NULL,
    alcada numeric(10,2) NOT NULL,
    date_inc timestamp(6) without time zone NOT NULL,
    status character varying DEFAULT 'G'::character varying,
    motivo character varying(255)
);


ALTER TABLE comercial.discount_proposal_status OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 28904)
-- Name: discount_proposal_status_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.discount_proposal_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.discount_proposal_status_id_seq OWNER TO postgres;

--
-- TOC entry 5225 (class 0 OID 0)
-- Dependencies: 275
-- Name: discount_proposal_status_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.discount_proposal_status_id_seq OWNED BY comercial.discount_proposal_status.id;


--
-- TOC entry 278 (class 1259 OID 28918)
-- Name: ev_change; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.ev_change (
    id integer NOT NULL,
    id_prospect integer
);


ALTER TABLE comercial.ev_change OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 28916)
-- Name: ev_change_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.ev_change_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.ev_change_id_seq OWNER TO postgres;

--
-- TOC entry 5226 (class 0 OID 0)
-- Dependencies: 277
-- Name: ev_change_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.ev_change_id_seq OWNED BY comercial.ev_change.id;


--
-- TOC entry 280 (class 1259 OID 28926)
-- Name: favorite_address; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.favorite_address (
    id integer NOT NULL,
    viable_id integer NOT NULL,
    wallet_id integer NOT NULL,
    name character varying NOT NULL,
    prospect_id integer NOT NULL
);


ALTER TABLE comercial.favorite_address OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 28924)
-- Name: favorite_address_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.favorite_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.favorite_address_id_seq OWNER TO postgres;

--
-- TOC entry 5227 (class 0 OID 0)
-- Dependencies: 279
-- Name: favorite_address_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.favorite_address_id_seq OWNED BY comercial.favorite_address.id;


--
-- TOC entry 282 (class 1259 OID 28937)
-- Name: followup; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.followup (
    id integer NOT NULL,
    chance_id integer,
    action_id integer,
    next_action_id integer,
    status_id integer,
    temperature integer,
    description text,
    next_action_date timestamp(0) without time zone,
    date_record timestamp(0) without time zone DEFAULT now(),
    file text,
    person integer,
    wallet integer,
    id_contract integer
);


ALTER TABLE comercial.followup OWNER TO postgres;

--
-- TOC entry 284 (class 1259 OID 28949)
-- Name: followup_action; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.followup_action (
    id integer NOT NULL,
    name character varying(100),
    subacao boolean DEFAULT true,
    parent_id integer,
    visivel boolean DEFAULT true
);


ALTER TABLE comercial.followup_action OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 28947)
-- Name: followup_action_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.followup_action_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.followup_action_id_seq OWNER TO postgres;

--
-- TOC entry 5228 (class 0 OID 0)
-- Dependencies: 283
-- Name: followup_action_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.followup_action_id_seq OWNED BY comercial.followup_action.id;


--
-- TOC entry 286 (class 1259 OID 28959)
-- Name: followup_contact; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.followup_contact (
    id integer NOT NULL,
    sistech_id integer,
    chance_contact_id integer,
    followup_id integer
);


ALTER TABLE comercial.followup_contact OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 28957)
-- Name: followup_contact_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.followup_contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.followup_contact_id_seq OWNER TO postgres;

--
-- TOC entry 5229 (class 0 OID 0)
-- Dependencies: 285
-- Name: followup_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.followup_contact_id_seq OWNED BY comercial.followup_contact.id;


--
-- TOC entry 281 (class 1259 OID 28935)
-- Name: followup_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.followup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.followup_id_seq OWNER TO postgres;

--
-- TOC entry 5230 (class 0 OID 0)
-- Dependencies: 281
-- Name: followup_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.followup_id_seq OWNED BY comercial.followup.id;


--
-- TOC entry 288 (class 1259 OID 28967)
-- Name: global_address; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.global_address (
    id integer NOT NULL,
    name character varying(2044) NOT NULL,
    cep character varying(2044) NOT NULL,
    city integer NOT NULL,
    complement text NOT NULL,
    date_record timestamp(0) without time zone NOT NULL,
    district character varying(2044) NOT NULL,
    lat character varying(2044) NOT NULL,
    lon character varying(2044) NOT NULL,
    street character varying(2044) NOT NULL,
    uf character varying(2044) NOT NULL,
    active boolean NOT NULL,
    number integer NOT NULL
);


ALTER TABLE comercial.global_address OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 28965)
-- Name: global_address_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.global_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.global_address_id_seq OWNER TO postgres;

--
-- TOC entry 5231 (class 0 OID 0)
-- Dependencies: 287
-- Name: global_address_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.global_address_id_seq OWNED BY comercial.global_address.id;


--
-- TOC entry 290 (class 1259 OID 28978)
-- Name: goal; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.goal (
    id integer NOT NULL,
    name character varying(100),
    function character varying(100),
    goal_type_id integer
);


ALTER TABLE comercial.goal OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 28986)
-- Name: goal_history; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.goal_history (
    id integer NOT NULL,
    goal_wallet_id integer,
    score numeric(9,2),
    date_record timestamp(0) without time zone DEFAULT now()
);


ALTER TABLE comercial.goal_history OWNER TO postgres;

--
-- TOC entry 291 (class 1259 OID 28984)
-- Name: goal_history_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.goal_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.goal_history_id_seq OWNER TO postgres;

--
-- TOC entry 5232 (class 0 OID 0)
-- Dependencies: 291
-- Name: goal_history_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.goal_history_id_seq OWNED BY comercial.goal_history.id;


--
-- TOC entry 289 (class 1259 OID 28976)
-- Name: goal_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.goal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.goal_id_seq OWNER TO postgres;

--
-- TOC entry 5233 (class 0 OID 0)
-- Dependencies: 289
-- Name: goal_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.goal_id_seq OWNED BY comercial.goal.id;


--
-- TOC entry 294 (class 1259 OID 28995)
-- Name: goal_type; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.goal_type (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE comercial.goal_type OWNER TO postgres;

--
-- TOC entry 293 (class 1259 OID 28993)
-- Name: goal_type_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.goal_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.goal_type_id_seq OWNER TO postgres;

--
-- TOC entry 5234 (class 0 OID 0)
-- Dependencies: 293
-- Name: goal_type_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.goal_type_id_seq OWNED BY comercial.goal_type.id;


--
-- TOC entry 296 (class 1259 OID 29003)
-- Name: goal_wallet; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.goal_wallet (
    id integer NOT NULL,
    wallet_id integer,
    goal_id integer,
    score numeric(10,2),
    team character varying(100),
    active boolean,
    chance_id integer
);


ALTER TABLE comercial.goal_wallet OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 29001)
-- Name: goal_wallet_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.goal_wallet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.goal_wallet_id_seq OWNER TO postgres;

--
-- TOC entry 5235 (class 0 OID 0)
-- Dependencies: 295
-- Name: goal_wallet_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.goal_wallet_id_seq OWNED BY comercial.goal_wallet.id;


--
-- TOC entry 298 (class 1259 OID 29011)
-- Name: group_item; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.group_item (
    id integer NOT NULL,
    group_id integer,
    product_luma integer,
    quantity real
);


ALTER TABLE comercial.group_item OWNER TO postgres;

--
-- TOC entry 297 (class 1259 OID 29009)
-- Name: group_item_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.group_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.group_item_id_seq OWNER TO postgres;

--
-- TOC entry 5236 (class 0 OID 0)
-- Dependencies: 297
-- Name: group_item_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.group_item_id_seq OWNED BY comercial.group_item.id;


--
-- TOC entry 300 (class 1259 OID 29019)
-- Name: grupo; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.grupo (
    id integer NOT NULL,
    group_name character varying(80) NOT NULL,
    group_description text,
    ativo boolean DEFAULT true
);


ALTER TABLE comercial.grupo OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 29017)
-- Name: grupo_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.grupo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.grupo_id_seq OWNER TO postgres;

--
-- TOC entry 5237 (class 0 OID 0)
-- Dependencies: 299
-- Name: grupo_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.grupo_id_seq OWNED BY comercial.grupo.id;


--
-- TOC entry 302 (class 1259 OID 29031)
-- Name: information; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.information (
    id integer NOT NULL,
    description text
);


ALTER TABLE comercial.information OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 29029)
-- Name: information_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.information_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.information_id_seq OWNER TO postgres;

--
-- TOC entry 5238 (class 0 OID 0)
-- Dependencies: 301
-- Name: information_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.information_id_seq OWNED BY comercial.information.id;


--
-- TOC entry 304 (class 1259 OID 29042)
-- Name: lost_action; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.lost_action (
    id integer NOT NULL,
    name character varying(200),
    parent_id integer,
    visible boolean,
    "select" boolean
);


ALTER TABLE comercial.lost_action OWNER TO postgres;

--
-- TOC entry 303 (class 1259 OID 29040)
-- Name: lost_action_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.lost_action_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.lost_action_id_seq OWNER TO postgres;

--
-- TOC entry 5239 (class 0 OID 0)
-- Dependencies: 303
-- Name: lost_action_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.lost_action_id_seq OWNED BY comercial.lost_action.id;


--
-- TOC entry 306 (class 1259 OID 29050)
-- Name: lost_chance; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.lost_chance (
    id integer NOT NULL,
    chance_id integer,
    lost_action_id integer,
    date_record timestamp(0) without time zone DEFAULT now(),
    wallet integer,
    description text
);


ALTER TABLE comercial.lost_chance OWNER TO postgres;

--
-- TOC entry 305 (class 1259 OID 29048)
-- Name: lost_chance_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.lost_chance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.lost_chance_id_seq OWNER TO postgres;

--
-- TOC entry 5240 (class 0 OID 0)
-- Dependencies: 305
-- Name: lost_chance_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.lost_chance_id_seq OWNED BY comercial.lost_chance.id;


--
-- TOC entry 308 (class 1259 OID 29062)
-- Name: number_imported; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.number_imported (
    id integer NOT NULL,
    number_imported character varying(15),
    ddd character varying(3)
);


ALTER TABLE comercial.number_imported OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 29060)
-- Name: number_imported_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.number_imported_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.number_imported_id_seq OWNER TO postgres;

--
-- TOC entry 5241 (class 0 OID 0)
-- Dependencies: 307
-- Name: number_imported_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.number_imported_id_seq OWNED BY comercial.number_imported.id;


--
-- TOC entry 310 (class 1259 OID 29070)
-- Name: proposal; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal (
    id integer NOT NULL,
    activation_fare money,
    monthly_cost money,
    speed integer,
    speed_unit integer,
    activation_days integer,
    contract_deadline integer,
    contract_unit integer,
    followup_id integer,
    description text,
    active boolean DEFAULT true,
    latitude character varying(100),
    longitude character varying(100),
    date_limit integer,
    price_right money,
    viable_id integer,
    lpu_id integer,
    monthly_cost_no_discount money,
    activation_fare_no_discount money,
    attribs text DEFAULT '{}'::text NOT NULL,
    cnpj character varying(14),
    bank_information_id integer,
    plan_type integer,
    franchise_cost money,
    franchise_cost_no_discount money,
    accept boolean,
    pay_day integer,
    has_permanence_term boolean DEFAULT false,
    contrato_sthima integer
);


ALTER TABLE comercial.proposal OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 29084)
-- Name: proposal_address; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_address (
    id integer NOT NULL,
    uf text,
    city integer,
    cep text,
    street text,
    number text,
    complement text,
    proposal_id integer,
    district character varying
);


ALTER TABLE comercial.proposal_address OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 29082)
-- Name: proposal_address_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_address_id_seq OWNER TO postgres;

--
-- TOC entry 5242 (class 0 OID 0)
-- Dependencies: 311
-- Name: proposal_address_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_address_id_seq OWNED BY comercial.proposal_address.id;


--
-- TOC entry 314 (class 1259 OID 29095)
-- Name: proposal_benefits; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_benefits (
    id integer NOT NULL,
    proposal_id integer,
    investment_value money,
    monthly_bonus_value money,
    activation_bonus_value money,
    permanence_deadline integer,
    permanence_unit integer
);


ALTER TABLE comercial.proposal_benefits OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 29093)
-- Name: proposal_benefits_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_benefits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_benefits_id_seq OWNER TO postgres;

--
-- TOC entry 5243 (class 0 OID 0)
-- Dependencies: 313
-- Name: proposal_benefits_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_benefits_id_seq OWNED BY comercial.proposal_benefits.id;


--
-- TOC entry 316 (class 1259 OID 29103)
-- Name: proposal_circuit; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_circuit (
    id integer NOT NULL,
    proposal_id integer,
    viable_id integer,
    discount numeric(10,2),
    lpu_id integer,
    speed integer,
    speed_unit integer,
    activation_fare money,
    activation_fare_no_discount money,
    monthly_cost money,
    monthly_cost_no_discount money,
    attribs text,
    percentual_lpu_discount real DEFAULT 0 NOT NULL,
    sva_activation_fare_discount money DEFAULT 0 NOT NULL,
    sva_monthly_cost_discount money DEFAULT 0 NOT NULL,
    sva_max_percentual_discount real DEFAULT 0 NOT NULL,
    final_client character varying(255)
);


ALTER TABLE comercial.proposal_circuit OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 29101)
-- Name: proposal_circuit_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_circuit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_circuit_id_seq OWNER TO postgres;

--
-- TOC entry 5244 (class 0 OID 0)
-- Dependencies: 315
-- Name: proposal_circuit_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_circuit_id_seq OWNED BY comercial.proposal_circuit.id;


--
-- TOC entry 318 (class 1259 OID 29118)
-- Name: proposal_circuit_sva; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_circuit_sva (
    id integer NOT NULL,
    proposal_circuit_id integer NOT NULL,
    sva_id integer NOT NULL,
    ativation_fare money DEFAULT 0 NOT NULL,
    monthly_cost money DEFAULT 0 NOT NULL
);


ALTER TABLE comercial.proposal_circuit_sva OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 29116)
-- Name: proposal_circuit_sva_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_circuit_sva_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_circuit_sva_id_seq OWNER TO postgres;

--
-- TOC entry 5245 (class 0 OID 0)
-- Dependencies: 317
-- Name: proposal_circuit_sva_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_circuit_sva_id_seq OWNED BY comercial.proposal_circuit_sva.id;


--
-- TOC entry 320 (class 1259 OID 29128)
-- Name: proposal_circuit_sva_products; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_circuit_sva_products (
    id integer NOT NULL,
    proposal_circuit_sva_id integer NOT NULL,
    external_id integer,
    name character varying(255) NOT NULL,
    amount integer NOT NULL,
    type character varying(100) NOT NULL
);


ALTER TABLE comercial.proposal_circuit_sva_products OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 29126)
-- Name: proposal_circuit_sva_products_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_circuit_sva_products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_circuit_sva_products_id_seq OWNER TO postgres;

--
-- TOC entry 5246 (class 0 OID 0)
-- Dependencies: 319
-- Name: proposal_circuit_sva_products_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_circuit_sva_products_id_seq OWNED BY comercial.proposal_circuit_sva_products.id;


--
-- TOC entry 322 (class 1259 OID 29136)
-- Name: proposal_document; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_document (
    id integer NOT NULL,
    proposal_id integer NOT NULL,
    proposal_odt_id integer,
    odt_file character varying,
    pdf_file character varying,
    user_id integer,
    dateinc timestamp(0) without time zone,
    dategen timestamp(0) without time zone
);


ALTER TABLE comercial.proposal_document OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 29134)
-- Name: proposal_document_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_document_id_seq OWNER TO postgres;

--
-- TOC entry 5247 (class 0 OID 0)
-- Dependencies: 321
-- Name: proposal_document_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_document_id_seq OWNED BY comercial.proposal_document.id;


--
-- TOC entry 324 (class 1259 OID 29147)
-- Name: proposal_feature; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_feature (
    id integer NOT NULL,
    atrivalo_codigoid integer,
    value character varying,
    activation_fare money,
    monthly_cost money,
    proposal_id integer,
    quantity integer
);


ALTER TABLE comercial.proposal_feature OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 29145)
-- Name: proposal_feature_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_feature_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_feature_id_seq OWNER TO postgres;

--
-- TOC entry 5248 (class 0 OID 0)
-- Dependencies: 323
-- Name: proposal_feature_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_feature_id_seq OWNED BY comercial.proposal_feature.id;


--
-- TOC entry 309 (class 1259 OID 29068)
-- Name: proposal_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_id_seq OWNER TO postgres;

--
-- TOC entry 5249 (class 0 OID 0)
-- Dependencies: 309
-- Name: proposal_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_id_seq OWNED BY comercial.proposal.id;


--
-- TOC entry 326 (class 1259 OID 29158)
-- Name: proposal_information; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_information (
    proposal_id integer NOT NULL,
    information_id integer NOT NULL
);


ALTER TABLE comercial.proposal_information OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 29156)
-- Name: proposal_information_proposal_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_information_proposal_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_information_proposal_id_seq OWNER TO postgres;

--
-- TOC entry 5250 (class 0 OID 0)
-- Dependencies: 325
-- Name: proposal_information_proposal_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_information_proposal_id_seq OWNED BY comercial.proposal_information.proposal_id;


--
-- TOC entry 328 (class 1259 OID 29166)
-- Name: proposal_number; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_number (
    id integer NOT NULL,
    proposal_id integer,
    number_type integer,
    quantity integer,
    activation_fare money,
    monthly_cost money
);


ALTER TABLE comercial.proposal_number OWNER TO postgres;

--
-- TOC entry 327 (class 1259 OID 29164)
-- Name: proposal_number_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_number_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_number_id_seq OWNER TO postgres;

--
-- TOC entry 5251 (class 0 OID 0)
-- Dependencies: 327
-- Name: proposal_number_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_number_id_seq OWNED BY comercial.proposal_number.id;


--
-- TOC entry 329 (class 1259 OID 29172)
-- Name: proposal_number_imported; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_number_imported (
    proposal_id integer NOT NULL,
    number_imported_id integer NOT NULL
);


ALTER TABLE comercial.proposal_number_imported OWNER TO postgres;

--
-- TOC entry 331 (class 1259 OID 29179)
-- Name: proposal_odt; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_odt (
    id integer NOT NULL,
    filename character varying(200),
    service_id integer,
    date_record timestamp(0) without time zone,
    author integer,
    active boolean
);


ALTER TABLE comercial.proposal_odt OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 29177)
-- Name: proposal_odt_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_odt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_odt_id_seq OWNER TO postgres;

--
-- TOC entry 5252 (class 0 OID 0)
-- Dependencies: 330
-- Name: proposal_odt_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_odt_id_seq OWNED BY comercial.proposal_odt.id;


--
-- TOC entry 333 (class 1259 OID 29187)
-- Name: proposal_protocol; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_protocol (
    id integer NOT NULL,
    proposal_id integer NOT NULL,
    client text,
    salesman text,
    activation_value character varying,
    monthly_payment character varying,
    date_record timestamp(0) without time zone NOT NULL,
    name_protocol character varying NOT NULL,
    date_proposal date,
    service character varying NOT NULL,
    status integer NOT NULL,
    date_assignment timestamp(0) without time zone,
    delta money,
    prev_monthly_payment character varying(2044) DEFAULT NULL::character varying,
    prev_delta money,
    prev_speed character varying(2044) DEFAULT NULL::character varying,
    activation_rule integer,
    estimated_date timestamp(0) without time zone,
    date_payment timestamp(0) without time zone DEFAULT NULL::timestamp(0) without time zone,
    fare integer,
    activation_date date,
    revenue_filial_id integer,
    business_rule_id integer,
    has_early_fare boolean,
    early_fare_due_date date,
    fare_quote_quantity integer,
    fare_periodicity character varying(60),
    fare_due_day integer,
    fare_bank_id integer,
    fare_delivery_type_id integer,
    has_grace_period boolean,
    grace_period_number character varying(60),
    grace_period_type character varying(60),
    comment text
);


ALTER TABLE comercial.proposal_protocol OWNER TO postgres;

--
-- TOC entry 335 (class 1259 OID 29201)
-- Name: proposal_protocol_historic; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_protocol_historic (
    id integer NOT NULL,
    date_inc timestamp(0) without time zone NOT NULL,
    proposal_protocol_id integer NOT NULL,
    aut_usuarios_id integer NOT NULL,
    department character varying(60) NOT NULL,
    proposal_protocol_status_id integer NOT NULL,
    reason_denial text NOT NULL,
    contract_denial_reason_id integer
);


ALTER TABLE comercial.proposal_protocol_historic OWNER TO postgres;

--
-- TOC entry 334 (class 1259 OID 29199)
-- Name: proposal_protocol_historic_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_protocol_historic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_protocol_historic_id_seq OWNER TO postgres;

--
-- TOC entry 5253 (class 0 OID 0)
-- Dependencies: 334
-- Name: proposal_protocol_historic_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_protocol_historic_id_seq OWNED BY comercial.proposal_protocol_historic.id;


--
-- TOC entry 332 (class 1259 OID 29185)
-- Name: proposal_protocol_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_protocol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_protocol_id_seq OWNER TO postgres;

--
-- TOC entry 5254 (class 0 OID 0)
-- Dependencies: 332
-- Name: proposal_protocol_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_protocol_id_seq OWNED BY comercial.proposal_protocol.id;


--
-- TOC entry 337 (class 1259 OID 29212)
-- Name: proposal_protocol_status; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_protocol_status (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE comercial.proposal_protocol_status OWNER TO postgres;

--
-- TOC entry 336 (class 1259 OID 29210)
-- Name: proposal_protocol_status_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_protocol_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_protocol_status_id_seq OWNER TO postgres;

--
-- TOC entry 5255 (class 0 OID 0)
-- Dependencies: 336
-- Name: proposal_protocol_status_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_protocol_status_id_seq OWNED BY comercial.proposal_protocol_status.id;


--
-- TOC entry 339 (class 1259 OID 29223)
-- Name: proposal_responsible; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_responsible (
    id integer NOT NULL,
    proposal_id integer NOT NULL,
    type_id integer NOT NULL,
    name character varying,
    cpf character varying,
    birthday date,
    phone character varying,
    cellphone character varying,
    email character varying,
    cad_users_id integer
);


ALTER TABLE comercial.proposal_responsible OWNER TO postgres;

--
-- TOC entry 338 (class 1259 OID 29221)
-- Name: proposal_responsible_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_responsible_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_responsible_id_seq OWNER TO postgres;

--
-- TOC entry 5256 (class 0 OID 0)
-- Dependencies: 338
-- Name: proposal_responsible_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_responsible_id_seq OWNED BY comercial.proposal_responsible.id;


--
-- TOC entry 341 (class 1259 OID 29234)
-- Name: proposal_responsible_type; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_responsible_type (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE comercial.proposal_responsible_type OWNER TO postgres;

--
-- TOC entry 340 (class 1259 OID 29232)
-- Name: proposal_responsible_type_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_responsible_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_responsible_type_id_seq OWNER TO postgres;

--
-- TOC entry 5257 (class 0 OID 0)
-- Dependencies: 340
-- Name: proposal_responsible_type_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_responsible_type_id_seq OWNED BY comercial.proposal_responsible_type.id;


--
-- TOC entry 343 (class 1259 OID 29245)
-- Name: proposal_status; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_status (
    id integer NOT NULL,
    valproposal_id boolean,
    physical_proposal_pendency boolean,
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    date_update timestamp(0) without time zone,
    motivo_proposta_invalida text,
    pending_seller boolean,
    id_reason integer
);


ALTER TABLE comercial.proposal_status OWNER TO postgres;

--
-- TOC entry 342 (class 1259 OID 29243)
-- Name: proposal_status_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_status_id_seq OWNER TO postgres;

--
-- TOC entry 5258 (class 0 OID 0)
-- Dependencies: 342
-- Name: proposal_status_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_status_id_seq OWNED BY comercial.proposal_status.id;


--
-- TOC entry 345 (class 1259 OID 29257)
-- Name: proposal_time_counters; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_time_counters (
    id integer NOT NULL,
    proposal_id integer NOT NULL,
    initial_date timestamp(0) without time zone DEFAULT now() NOT NULL,
    final_date timestamp(0) without time zone,
    proposal_time_counters_stacks_id integer NOT NULL,
    proposal_protocol_status_id integer
);


ALTER TABLE comercial.proposal_time_counters OWNER TO postgres;

--
-- TOC entry 344 (class 1259 OID 29255)
-- Name: proposal_time_counters_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_time_counters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_time_counters_id_seq OWNER TO postgres;

--
-- TOC entry 5259 (class 0 OID 0)
-- Dependencies: 344
-- Name: proposal_time_counters_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_time_counters_id_seq OWNED BY comercial.proposal_time_counters.id;


--
-- TOC entry 347 (class 1259 OID 29266)
-- Name: proposal_time_counters_stacks; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.proposal_time_counters_stacks (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    deadline integer NOT NULL
);


ALTER TABLE comercial.proposal_time_counters_stacks OWNER TO postgres;

--
-- TOC entry 346 (class 1259 OID 29264)
-- Name: proposal_time_counters_stacks_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.proposal_time_counters_stacks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.proposal_time_counters_stacks_id_seq OWNER TO postgres;

--
-- TOC entry 5260 (class 0 OID 0)
-- Dependencies: 346
-- Name: proposal_time_counters_stacks_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.proposal_time_counters_stacks_id_seq OWNED BY comercial.proposal_time_counters_stacks.id;


--
-- TOC entry 236 (class 1259 OID 28704)
-- Name: prospect; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.prospect (
    id integer NOT NULL,
    id_wallet integer NOT NULL,
    id_tag integer,
    id_cliente integer NOT NULL,
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    date_update timestamp(0) without time zone,
    active boolean DEFAULT true NOT NULL,
    client_name character varying(200) NOT NULL,
    cid integer,
    fake_name character varying(200)
);


ALTER TABLE comercial.prospect OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 28702)
-- Name: prospect_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.prospect_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.prospect_id_seq OWNER TO postgres;

--
-- TOC entry 5261 (class 0 OID 0)
-- Dependencies: 235
-- Name: prospect_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.prospect_id_seq OWNED BY comercial.prospect.id;


--
-- TOC entry 349 (class 1259 OID 29274)
-- Name: ranking; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.ranking (
    id integer NOT NULL,
    points integer,
    team character varying(200),
    date_record timestamp(0) without time zone DEFAULT now(),
    total integer,
    ciclo integer DEFAULT 1
);


ALTER TABLE comercial.ranking OWNER TO postgres;

--
-- TOC entry 348 (class 1259 OID 29272)
-- Name: ranking_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.ranking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.ranking_id_seq OWNER TO postgres;

--
-- TOC entry 5262 (class 0 OID 0)
-- Dependencies: 348
-- Name: ranking_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.ranking_id_seq OWNED BY comercial.ranking.id;


--
-- TOC entry 351 (class 1259 OID 29284)
-- Name: reason_category; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.reason_category (
    id integer NOT NULL,
    category character varying(255) NOT NULL,
    status boolean NOT NULL,
    date_record time(6) without time zone
);


ALTER TABLE comercial.reason_category OWNER TO postgres;

--
-- TOC entry 350 (class 1259 OID 29282)
-- Name: reason_category_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.reason_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.reason_category_id_seq OWNER TO postgres;

--
-- TOC entry 5263 (class 0 OID 0)
-- Dependencies: 350
-- Name: reason_category_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.reason_category_id_seq OWNED BY comercial.reason_category.id;


--
-- TOC entry 353 (class 1259 OID 29292)
-- Name: requirement; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.requirement (
    id integer NOT NULL,
    name character varying NOT NULL,
    luma_id integer,
    unit character varying(10)
);


ALTER TABLE comercial.requirement OWNER TO postgres;

--
-- TOC entry 352 (class 1259 OID 29290)
-- Name: requirement_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.requirement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.requirement_id_seq OWNER TO postgres;

--
-- TOC entry 5264 (class 0 OID 0)
-- Dependencies: 352
-- Name: requirement_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.requirement_id_seq OWNED BY comercial.requirement.id;


--
-- TOC entry 355 (class 1259 OID 29303)
-- Name: return_reason; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.return_reason (
    id integer NOT NULL,
    reason character varying(255) NOT NULL,
    category_id integer NOT NULL,
    status boolean NOT NULL,
    date_record timestamp(6) without time zone
);


ALTER TABLE comercial.return_reason OWNER TO postgres;

--
-- TOC entry 354 (class 1259 OID 29301)
-- Name: return_reason_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.return_reason_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.return_reason_id_seq OWNER TO postgres;

--
-- TOC entry 5265 (class 0 OID 0)
-- Dependencies: 354
-- Name: return_reason_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.return_reason_id_seq OWNED BY comercial.return_reason.id;


--
-- TOC entry 230 (class 1259 OID 28675)
-- Name: service; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.service (
    id integer NOT NULL,
    name character varying(100),
    servico_contrato integer NOT NULL,
    multiple_circuits boolean DEFAULT false NOT NULL,
    location_service integer,
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE comercial.service OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 28673)
-- Name: service_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.service_id_seq OWNER TO postgres;

--
-- TOC entry 5266 (class 0 OID 0)
-- Dependencies: 229
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.service_id_seq OWNED BY comercial.service.id;


--
-- TOC entry 357 (class 1259 OID 29311)
-- Name: sva; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.sva (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    nickname character varying(100) NOT NULL
);


ALTER TABLE comercial.sva OWNER TO postgres;

--
-- TOC entry 356 (class 1259 OID 29309)
-- Name: sva_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.sva_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.sva_id_seq OWNER TO postgres;

--
-- TOC entry 5267 (class 0 OID 0)
-- Dependencies: 356
-- Name: sva_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.sva_id_seq OWNED BY comercial.sva.id;


--
-- TOC entry 234 (class 1259 OID 28695)
-- Name: tag; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.tag (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    color character varying(7) NOT NULL,
    status boolean DEFAULT true NOT NULL
);


ALTER TABLE comercial.tag OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 28693)
-- Name: tag_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.tag_id_seq OWNER TO postgres;

--
-- TOC entry 5268 (class 0 OID 0)
-- Dependencies: 233
-- Name: tag_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.tag_id_seq OWNED BY comercial.tag.id;


--
-- TOC entry 359 (class 1259 OID 29319)
-- Name: team; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.team (
    id integer NOT NULL,
    teamtype_id integer NOT NULL,
    team_name character varying(150),
    team_active boolean DEFAULT true NOT NULL,
    team_date_record timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE comercial.team OWNER TO postgres;

--
-- TOC entry 358 (class 1259 OID 29317)
-- Name: team_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.team_id_seq OWNER TO postgres;

--
-- TOC entry 5269 (class 0 OID 0)
-- Dependencies: 358
-- Name: team_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.team_id_seq OWNED BY comercial.team.id;


--
-- TOC entry 361 (class 1259 OID 29329)
-- Name: team_state; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.team_state (
    id integer NOT NULL,
    team_id integer NOT NULL,
    teamstate_uf character varying(2) NOT NULL,
    teamstate_date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    teamstate_active boolean DEFAULT true NOT NULL
);


ALTER TABLE comercial.team_state OWNER TO postgres;

--
-- TOC entry 360 (class 1259 OID 29327)
-- Name: team_state_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.team_state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.team_state_id_seq OWNER TO postgres;

--
-- TOC entry 5270 (class 0 OID 0)
-- Dependencies: 360
-- Name: team_state_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.team_state_id_seq OWNED BY comercial.team_state.id;


--
-- TOC entry 363 (class 1259 OID 29339)
-- Name: team_type; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.team_type (
    id integer NOT NULL,
    teamtype_name character varying(150),
    teamtype_date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    teamtype_active boolean DEFAULT true NOT NULL
);


ALTER TABLE comercial.team_type OWNER TO postgres;

--
-- TOC entry 362 (class 1259 OID 29337)
-- Name: team_type_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.team_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.team_type_id_seq OWNER TO postgres;

--
-- TOC entry 5271 (class 0 OID 0)
-- Dependencies: 362
-- Name: team_type_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.team_type_id_seq OWNED BY comercial.team_type.id;


--
-- TOC entry 365 (class 1259 OID 29349)
-- Name: team_user; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.team_user (
    id integer NOT NULL,
    team_id integer NOT NULL,
    user_id integer NOT NULL,
    teamuser_date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    teamuser_active boolean DEFAULT true NOT NULL
);


ALTER TABLE comercial.team_user OWNER TO postgres;

--
-- TOC entry 364 (class 1259 OID 29347)
-- Name: team_user_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.team_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.team_user_id_seq OWNER TO postgres;

--
-- TOC entry 5272 (class 0 OID 0)
-- Dependencies: 364
-- Name: team_user_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.team_user_id_seq OWNED BY comercial.team_user.id;


--
-- TOC entry 367 (class 1259 OID 29359)
-- Name: thirdservice; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.thirdservice (
    id integer NOT NULL,
    name character varying NOT NULL,
    date_record timestamp(0) without time zone NOT NULL,
    cost numeric(10,2) NOT NULL,
    user_registrant integer NOT NULL,
    active boolean NOT NULL,
    type integer NOT NULL
);


ALTER TABLE comercial.thirdservice OWNER TO postgres;

--
-- TOC entry 366 (class 1259 OID 29357)
-- Name: thirdservice_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.thirdservice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.thirdservice_id_seq OWNER TO postgres;

--
-- TOC entry 5273 (class 0 OID 0)
-- Dependencies: 366
-- Name: thirdservice_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.thirdservice_id_seq OWNED BY comercial.thirdservice.id;


--
-- TOC entry 369 (class 1259 OID 29370)
-- Name: type_thirdservice; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.type_thirdservice (
    id integer NOT NULL,
    name character varying NOT NULL,
    active boolean NOT NULL,
    acronyn character varying NOT NULL
);


ALTER TABLE comercial.type_thirdservice OWNER TO postgres;

--
-- TOC entry 368 (class 1259 OID 29368)
-- Name: type_thirdservice_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.type_thirdservice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.type_thirdservice_id_seq OWNER TO postgres;

--
-- TOC entry 5274 (class 0 OID 0)
-- Dependencies: 368
-- Name: type_thirdservice_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.type_thirdservice_id_seq OWNED BY comercial.type_thirdservice.id;


--
-- TOC entry 371 (class 1259 OID 29381)
-- Name: viable; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.viable (
    id integer NOT NULL,
    lat character varying(100) NOT NULL,
    lon character varying(100) NOT NULL,
    cep character varying(100) NOT NULL,
    steet text NOT NULL,
    number character varying(2044) NOT NULL,
    complement text,
    viable boolean DEFAULT false,
    hash character varying(65),
    uf character varying(2) NOT NULL,
    city integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    viable_status integer NOT NULL,
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    author integer NOT NULL,
    chance_id integer,
    speed_type integer NOT NULL,
    min_activation numeric(12,2),
    min_monthly numeric(12,2),
    district character varying NOT NULL,
    speed integer NOT NULL,
    interface integer NOT NULL,
    coords text,
    shadow_lpu_id integer,
    price_zone integer,
    fiber_distance numeric(10,2),
    fiber_unit character varying(10),
    cont_codigoid integer,
    next_viable_id integer,
    latlon_manual boolean DEFAULT false NOT NULL,
    days_deadline integer NOT NULL,
    skip_engineer boolean,
    request_contract_deadline integer,
    request_contract_deadline_unit integer,
    interface_real integer NOT NULL,
    comment text,
    troca_endereco boolean DEFAULT false NOT NULL,
    pair integer,
    capilares integer,
    comment_presale text,
    total_fo numeric(10,2),
    id_group_sva integer,
    network_type character varying,
    id_datacenter integer,
    espaco_datacenter boolean DEFAULT false NOT NULL,
    delivery_place character varying,
    comment_voice text
);


ALTER TABLE comercial.viable OWNER TO postgres;

--
-- TOC entry 373 (class 1259 OID 29394)
-- Name: viable_approval; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.viable_approval (
    id integer NOT NULL,
    author integer,
    date_record timestamp(0) without time zone,
    viable_id integer,
    approved boolean,
    obs text,
    prev_viable_status integer NOT NULL,
    attachment character varying,
    deadline_approval timestamp(0) without time zone NOT NULL,
    date_approval timestamp(0) without time zone,
    min_ativation_days integer,
    network_type character varying
);


ALTER TABLE comercial.viable_approval OWNER TO postgres;

--
-- TOC entry 372 (class 1259 OID 29392)
-- Name: viable_approval_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.viable_approval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.viable_approval_id_seq OWNER TO postgres;

--
-- TOC entry 5275 (class 0 OID 0)
-- Dependencies: 372
-- Name: viable_approval_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.viable_approval_id_seq OWNED BY comercial.viable_approval.id;


--
-- TOC entry 375 (class 1259 OID 29405)
-- Name: viable_approval_thirdservice; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.viable_approval_thirdservice (
    id integer NOT NULL,
    viable_approval_id integer NOT NULL,
    thirdservice_id integer NOT NULL,
    quantity numeric(10,2) NOT NULL,
    total numeric(10,2) NOT NULL,
    price numeric(10,2) NOT NULL,
    viable integer
);


ALTER TABLE comercial.viable_approval_thirdservice OWNER TO postgres;

--
-- TOC entry 374 (class 1259 OID 29403)
-- Name: viable_approval_thirdservice_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.viable_approval_thirdservice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.viable_approval_thirdservice_id_seq OWNER TO postgres;

--
-- TOC entry 5276 (class 0 OID 0)
-- Dependencies: 374
-- Name: viable_approval_thirdservice_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.viable_approval_thirdservice_id_seq OWNED BY comercial.viable_approval_thirdservice.id;


--
-- TOC entry 377 (class 1259 OID 29413)
-- Name: viable_document; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.viable_document (
    id integer NOT NULL,
    viable_id integer NOT NULL,
    document_id integer,
    author integer NOT NULL,
    active boolean NOT NULL,
    date_record timestamp(0) without time zone DEFAULT now(),
    filename character varying(100),
    path character varying(200) NOT NULL
);


ALTER TABLE comercial.viable_document OWNER TO postgres;

--
-- TOC entry 376 (class 1259 OID 29411)
-- Name: viable_document_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.viable_document_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.viable_document_id_seq OWNER TO postgres;

--
-- TOC entry 5277 (class 0 OID 0)
-- Dependencies: 376
-- Name: viable_document_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.viable_document_id_seq OWNED BY comercial.viable_document.id;


--
-- TOC entry 379 (class 1259 OID 29422)
-- Name: viable_feature; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.viable_feature (
    id integer NOT NULL,
    featureattribute_id integer,
    viable_id integer,
    quantity integer,
    viable_feature_id integer
);


ALTER TABLE comercial.viable_feature OWNER TO postgres;

--
-- TOC entry 378 (class 1259 OID 29420)
-- Name: viable_feature_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.viable_feature_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.viable_feature_id_seq OWNER TO postgres;

--
-- TOC entry 5278 (class 0 OID 0)
-- Dependencies: 378
-- Name: viable_feature_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.viable_feature_id_seq OWNED BY comercial.viable_feature.id;


--
-- TOC entry 370 (class 1259 OID 29379)
-- Name: viable_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.viable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.viable_id_seq OWNER TO postgres;

--
-- TOC entry 5279 (class 0 OID 0)
-- Dependencies: 370
-- Name: viable_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.viable_id_seq OWNED BY comercial.viable.id;


--
-- TOC entry 380 (class 1259 OID 29428)
-- Name: viable_point; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.viable_point (
    viable_id integer NOT NULL,
    point_id integer NOT NULL
);


ALTER TABLE comercial.viable_point OWNER TO postgres;

--
-- TOC entry 382 (class 1259 OID 29435)
-- Name: viable_requirement; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.viable_requirement (
    id integer NOT NULL,
    viable_id integer,
    requirement_id integer,
    quantity numeric(10,2),
    price money,
    group_id integer,
    goal integer
);


ALTER TABLE comercial.viable_requirement OWNER TO postgres;

--
-- TOC entry 381 (class 1259 OID 29433)
-- Name: viable_requirement_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.viable_requirement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.viable_requirement_id_seq OWNER TO postgres;

--
-- TOC entry 5280 (class 0 OID 0)
-- Dependencies: 381
-- Name: viable_requirement_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.viable_requirement_id_seq OWNED BY comercial.viable_requirement.id;


--
-- TOC entry 384 (class 1259 OID 29443)
-- Name: viable_status; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.viable_status (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE comercial.viable_status OWNER TO postgres;

--
-- TOC entry 383 (class 1259 OID 29441)
-- Name: viable_status_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.viable_status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.viable_status_id_seq OWNER TO postgres;

--
-- TOC entry 5281 (class 0 OID 0)
-- Dependencies: 383
-- Name: viable_status_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.viable_status_id_seq OWNED BY comercial.viable_status.id;


--
-- TOC entry 386 (class 1259 OID 29451)
-- Name: vip; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.vip (
    id integer NOT NULL,
    user_id integer,
    date_record timestamp(0) without time zone DEFAULT now(),
    active boolean,
    description text,
    level_id integer
);


ALTER TABLE comercial.vip OWNER TO postgres;

--
-- TOC entry 385 (class 1259 OID 29449)
-- Name: vip_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.vip_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.vip_id_seq OWNER TO postgres;

--
-- TOC entry 5282 (class 0 OID 0)
-- Dependencies: 385
-- Name: vip_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.vip_id_seq OWNED BY comercial.vip.id;


--
-- TOC entry 388 (class 1259 OID 29463)
-- Name: vip_level; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.vip_level (
    id integer NOT NULL,
    level integer,
    name character varying(100)
);


ALTER TABLE comercial.vip_level OWNER TO postgres;

--
-- TOC entry 387 (class 1259 OID 29461)
-- Name: vip_level_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.vip_level_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.vip_level_id_seq OWNER TO postgres;

--
-- TOC entry 5283 (class 0 OID 0)
-- Dependencies: 387
-- Name: vip_level_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.vip_level_id_seq OWNED BY comercial.vip_level.id;


--
-- TOC entry 232 (class 1259 OID 28685)
-- Name: wallet; Type: TABLE; Schema: comercial; Owner: postgres
--

CREATE TABLE comercial.wallet (
    id integer NOT NULL,
    id_ev integer NOT NULL,
    active boolean DEFAULT true NOT NULL,
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    date_update timestamp(0) without time zone
);


ALTER TABLE comercial.wallet OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 28683)
-- Name: wallet_id_seq; Type: SEQUENCE; Schema: comercial; Owner: postgres
--

CREATE SEQUENCE comercial.wallet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comercial.wallet_id_seq OWNER TO postgres;

--
-- TOC entry 5284 (class 0 OID 0)
-- Dependencies: 231
-- Name: wallet_id_seq; Type: SEQUENCE OWNED BY; Schema: comercial; Owner: postgres
--

ALTER SEQUENCE comercial.wallet_id_seq OWNED BY comercial.wallet.id;


--
-- TOC entry 394 (class 1259 OID 33616)
-- Name: kmz; Type: TABLE; Schema: engenharia; Owner: postgres
--

CREATE TABLE engenharia.kmz (
    id integer NOT NULL,
    name character varying(500),
    latitude numeric(25,20),
    longitude numeric(25,20),
    type_id integer,
    kmz_file_id integer,
    active boolean,
    color character varying(6),
    date_valid timestamp without time zone,
    max_speed integer,
    radius integer,
    interface character varying(3),
    prox boolean,
    error boolean,
    tipo_arquivo character varying(15),
    coordenadas_poligono character varying,
    activation_deadline integer
);


ALTER TABLE engenharia.kmz OWNER TO postgres;

--
-- TOC entry 390 (class 1259 OID 33600)
-- Name: kmz_file; Type: TABLE; Schema: engenharia; Owner: postgres
--

CREATE TABLE engenharia.kmz_file (
    id integer NOT NULL,
    filename character varying(100),
    date_record timestamp without time zone,
    user_id character varying(4),
    path character varying(100)
);


ALTER TABLE engenharia.kmz_file OWNER TO postgres;

--
-- TOC entry 389 (class 1259 OID 33598)
-- Name: kmz_file_id_seq; Type: SEQUENCE; Schema: engenharia; Owner: postgres
--

CREATE SEQUENCE engenharia.kmz_file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE engenharia.kmz_file_id_seq OWNER TO postgres;

--
-- TOC entry 5285 (class 0 OID 0)
-- Dependencies: 389
-- Name: kmz_file_id_seq; Type: SEQUENCE OWNED BY; Schema: engenharia; Owner: postgres
--

ALTER SEQUENCE engenharia.kmz_file_id_seq OWNED BY engenharia.kmz_file.id;


--
-- TOC entry 393 (class 1259 OID 33614)
-- Name: kmz_id_seq; Type: SEQUENCE; Schema: engenharia; Owner: postgres
--

CREATE SEQUENCE engenharia.kmz_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE engenharia.kmz_id_seq OWNER TO postgres;

--
-- TOC entry 5286 (class 0 OID 0)
-- Dependencies: 393
-- Name: kmz_id_seq; Type: SEQUENCE OWNED BY; Schema: engenharia; Owner: postgres
--

ALTER SEQUENCE engenharia.kmz_id_seq OWNED BY engenharia.kmz.id;


--
-- TOC entry 398 (class 1259 OID 33654)
-- Name: location; Type: TABLE; Schema: engenharia; Owner: postgres
--

CREATE TABLE engenharia.location (
    id integer NOT NULL,
    latitude numeric(25,20),
    longitude numeric(25,20),
    location_id integer,
    point_id integer,
    radius integer
);


ALTER TABLE engenharia.location OWNER TO postgres;

--
-- TOC entry 397 (class 1259 OID 33652)
-- Name: location_id_seq; Type: SEQUENCE; Schema: engenharia; Owner: postgres
--

CREATE SEQUENCE engenharia.location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE engenharia.location_id_seq OWNER TO postgres;

--
-- TOC entry 5287 (class 0 OID 0)
-- Dependencies: 397
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: engenharia; Owner: postgres
--

ALTER SEQUENCE engenharia.location_id_seq OWNED BY engenharia.location.id;


--
-- TOC entry 396 (class 1259 OID 33637)
-- Name: point; Type: TABLE; Schema: engenharia; Owner: postgres
--

CREATE TABLE engenharia.point (
    id integer NOT NULL,
    name character varying(500) NOT NULL,
    color character varying(7) NOT NULL,
    type_id integer NOT NULL,
    date_valid timestamp without time zone,
    max_speed integer,
    interface character varying(3) NOT NULL,
    active boolean NOT NULL,
    location_type integer NOT NULL,
    author integer NOT NULL,
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    circ_codigoid integer,
    activation_deadline integer,
    state character varying(2) NOT NULL
);


ALTER TABLE engenharia.point OWNER TO postgres;

--
-- TOC entry 395 (class 1259 OID 33635)
-- Name: point_id_seq; Type: SEQUENCE; Schema: engenharia; Owner: postgres
--

CREATE SEQUENCE engenharia.point_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE engenharia.point_id_seq OWNER TO postgres;

--
-- TOC entry 5288 (class 0 OID 0)
-- Dependencies: 395
-- Name: point_id_seq; Type: SEQUENCE OWNED BY; Schema: engenharia; Owner: postgres
--

ALTER SEQUENCE engenharia.point_id_seq OWNED BY engenharia.point.id;


--
-- TOC entry 392 (class 1259 OID 33608)
-- Name: type; Type: TABLE; Schema: engenharia; Owner: postgres
--

CREATE TABLE engenharia.type (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE engenharia.type OWNER TO postgres;

--
-- TOC entry 391 (class 1259 OID 33606)
-- Name: type_id_seq; Type: SEQUENCE; Schema: engenharia; Owner: postgres
--

CREATE SEQUENCE engenharia.type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE engenharia.type_id_seq OWNER TO postgres;

--
-- TOC entry 5289 (class 0 OID 0)
-- Dependencies: 391
-- Name: type_id_seq; Type: SEQUENCE OWNED BY; Schema: engenharia; Owner: postgres
--

ALTER SEQUENCE engenharia.type_id_seq OWNED BY engenharia.type.id;


--
-- TOC entry 454 (class 1259 OID 34297)
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
-- TOC entry 453 (class 1259 OID 34295)
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
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 453
-- Name: endereco_id_seq; Type: SEQUENCE OWNED BY; Schema: pessoas; Owner: postgres
--

ALTER SEQUENCE pessoas.endereco_id_seq OWNED BY pessoas.endereco.id;


--
-- TOC entry 452 (class 1259 OID 34284)
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
-- TOC entry 451 (class 1259 OID 34282)
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
-- TOC entry 5291 (class 0 OID 0)
-- Dependencies: 451
-- Name: nome_id_seq; Type: SEQUENCE OWNED BY; Schema: pessoas; Owner: postgres
--

ALTER SEQUENCE pessoas.nome_id_seq OWNED BY pessoas.nome.id;


--
-- TOC entry 450 (class 1259 OID 34185)
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
-- TOC entry 449 (class 1259 OID 34183)
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
-- TOC entry 5292 (class 0 OID 0)
-- Dependencies: 449
-- Name: pessoa_id_seq; Type: SEQUENCE OWNED BY; Schema: pessoas; Owner: postgres
--

ALTER SEQUENCE pessoas.pessoa_id_seq OWNED BY pessoas.pessoa.id;


--
-- TOC entry 455 (class 1259 OID 34324)
-- Name: pessoa_to_pessoa; Type: TABLE; Schema: pessoas; Owner: postgres
--

CREATE TABLE pessoas.pessoa_to_pessoa (
    pessoa_origem integer NOT NULL,
    pessoa_destino integer NOT NULL,
    tipo pessoas.tipo_relacionamento_pessoa NOT NULL
);


ALTER TABLE pessoas.pessoa_to_pessoa OWNER TO postgres;

--
-- TOC entry 400 (class 1259 OID 33765)
-- Name: capex; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.capex (
    id integer NOT NULL,
    lpu_id integer,
    initial_speed integer,
    initial_speed_type_id integer,
    final_speed integer,
    final_speed_type_id integer,
    cost money
);


ALTER TABLE prevendas.capex OWNER TO postgres;

--
-- TOC entry 399 (class 1259 OID 33763)
-- Name: capex_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.capex_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.capex_id_seq OWNER TO postgres;

--
-- TOC entry 5293 (class 0 OID 0)
-- Dependencies: 399
-- Name: capex_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.capex_id_seq OWNED BY prevendas.capex.id;


--
-- TOC entry 402 (class 1259 OID 33773)
-- Name: distance; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.distance (
    id integer NOT NULL,
    service_id integer,
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    min_distance numeric(10,2) NOT NULL,
    max_distance numeric(10,2) NOT NULL,
    price numeric(10,2) NOT NULL,
    active boolean DEFAULT true NOT NULL,
    author integer,
    min_speed integer,
    max_speed integer,
    author_edit integer,
    date_edit timestamp without time zone
);


ALTER TABLE prevendas.distance OWNER TO postgres;

--
-- TOC entry 401 (class 1259 OID 33771)
-- Name: distance_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.distance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.distance_id_seq OWNER TO postgres;

--
-- TOC entry 5294 (class 0 OID 0)
-- Dependencies: 401
-- Name: distance_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.distance_id_seq OWNED BY prevendas.distance.id;


--
-- TOC entry 404 (class 1259 OID 33783)
-- Name: feature; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.feature (
    id integer NOT NULL,
    name character varying NOT NULL,
    atri_codigoid bigint,
    mandatory boolean NOT NULL,
    service_id bigint NOT NULL,
    active boolean DEFAULT true NOT NULL,
    "group" integer
);


ALTER TABLE prevendas.feature OWNER TO postgres;

--
-- TOC entry 406 (class 1259 OID 33795)
-- Name: feature_attribute; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.feature_attribute (
    id integer NOT NULL,
    name character varying,
    feature_id integer,
    default_selected boolean DEFAULT false NOT NULL,
    active boolean DEFAULT true NOT NULL
);


ALTER TABLE prevendas.feature_attribute OWNER TO postgres;

--
-- TOC entry 405 (class 1259 OID 33793)
-- Name: feature_attribute_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.feature_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.feature_attribute_id_seq OWNER TO postgres;

--
-- TOC entry 5295 (class 0 OID 0)
-- Dependencies: 405
-- Name: feature_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.feature_attribute_id_seq OWNED BY prevendas.feature_attribute.id;


--
-- TOC entry 403 (class 1259 OID 33781)
-- Name: feature_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.feature_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.feature_id_seq OWNER TO postgres;

--
-- TOC entry 5296 (class 0 OID 0)
-- Dependencies: 403
-- Name: feature_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.feature_id_seq OWNED BY prevendas.feature.id;


--
-- TOC entry 408 (class 1259 OID 33808)
-- Name: lpu; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.lpu (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    service_id integer NOT NULL,
    author integer NOT NULL,
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    date_valid timestamp(0) without time zone,
    distance integer,
    active boolean DEFAULT true NOT NULL,
    min_contract_deadline integer DEFAULT 12,
    min_contract_unit integer DEFAULT 1,
    sla numeric(5,2),
    mode_codigoid integer,
    minimum_price numeric(10,2),
    online_sales boolean DEFAULT false NOT NULL,
    type character varying(1) DEFAULT 'P'::bpchar NOT NULL
);


ALTER TABLE prevendas.lpu OWNER TO postgres;

--
-- TOC entry 410 (class 1259 OID 33820)
-- Name: lpu_customer; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.lpu_customer (
    id integer NOT NULL,
    lpu_id integer,
    custumer integer,
    date_record timestamp without time zone
);


ALTER TABLE prevendas.lpu_customer OWNER TO postgres;

--
-- TOC entry 409 (class 1259 OID 33818)
-- Name: lpu_customer_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.lpu_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.lpu_customer_id_seq OWNER TO postgres;

--
-- TOC entry 5297 (class 0 OID 0)
-- Dependencies: 409
-- Name: lpu_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.lpu_customer_id_seq OWNED BY prevendas.lpu_customer.id;


--
-- TOC entry 412 (class 1259 OID 33828)
-- Name: lpu_feature; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.lpu_feature (
    id integer NOT NULL,
    activation_fare numeric(15,2),
    monthly_cost numeric(15,2),
    date_record timestamp without time zone,
    lpu_id bigint,
    date_valid timestamp without time zone,
    feature_attribute_id bigint,
    quantity integer
);


ALTER TABLE prevendas.lpu_feature OWNER TO postgres;

--
-- TOC entry 411 (class 1259 OID 33826)
-- Name: lpu_feature_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.lpu_feature_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.lpu_feature_id_seq OWNER TO postgres;

--
-- TOC entry 5298 (class 0 OID 0)
-- Dependencies: 411
-- Name: lpu_feature_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.lpu_feature_id_seq OWNED BY prevendas.lpu_feature.id;


--
-- TOC entry 407 (class 1259 OID 33806)
-- Name: lpu_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.lpu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.lpu_id_seq OWNER TO postgres;

--
-- TOC entry 5299 (class 0 OID 0)
-- Dependencies: 407
-- Name: lpu_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.lpu_id_seq OWNED BY prevendas.lpu.id;


--
-- TOC entry 414 (class 1259 OID 33836)
-- Name: lpu_plan; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.lpu_plan (
    id integer NOT NULL,
    lpu_id integer,
    plan_id integer,
    activation_fare numeric(10,2),
    monthly_cost numeric(10,2),
    franchise_cost numeric(10,2),
    discount_ipc numeric(10,2)
);


ALTER TABLE prevendas.lpu_plan OWNER TO postgres;

--
-- TOC entry 413 (class 1259 OID 33834)
-- Name: lpu_plan_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.lpu_plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.lpu_plan_id_seq OWNER TO postgres;

--
-- TOC entry 5300 (class 0 OID 0)
-- Dependencies: 413
-- Name: lpu_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.lpu_plan_id_seq OWNED BY prevendas.lpu_plan.id;


--
-- TOC entry 416 (class 1259 OID 33844)
-- Name: lpu_point; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.lpu_point (
    id integer NOT NULL,
    lpu_id integer,
    point_id integer,
    date_record timestamp(0) without time zone,
    author integer
);


ALTER TABLE prevendas.lpu_point OWNER TO postgres;

--
-- TOC entry 415 (class 1259 OID 33842)
-- Name: lpu_point_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.lpu_point_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.lpu_point_id_seq OWNER TO postgres;

--
-- TOC entry 5301 (class 0 OID 0)
-- Dependencies: 415
-- Name: lpu_point_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.lpu_point_id_seq OWNED BY prevendas.lpu_point.id;


--
-- TOC entry 418 (class 1259 OID 33852)
-- Name: lpu_price; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.lpu_price (
    id integer NOT NULL,
    lpu_id integer,
    region_id integer,
    price integer
);


ALTER TABLE prevendas.lpu_price OWNER TO postgres;

--
-- TOC entry 417 (class 1259 OID 33850)
-- Name: lpu_price_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.lpu_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.lpu_price_id_seq OWNER TO postgres;

--
-- TOC entry 5302 (class 0 OID 0)
-- Dependencies: 417
-- Name: lpu_price_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.lpu_price_id_seq OWNED BY prevendas.lpu_price.id;


--
-- TOC entry 420 (class 1259 OID 33860)
-- Name: number; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.number (
    id integer NOT NULL,
    number_type_id integer NOT NULL,
    lpu_plan_id integer,
    activation_fare numeric(10,2),
    monthly_cost numeric(10,2)
);


ALTER TABLE prevendas.number OWNER TO postgres;

--
-- TOC entry 419 (class 1259 OID 33858)
-- Name: number_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.number_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.number_id_seq OWNER TO postgres;

--
-- TOC entry 5303 (class 0 OID 0)
-- Dependencies: 419
-- Name: number_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.number_id_seq OWNED BY prevendas.number.id;


--
-- TOC entry 422 (class 1259 OID 33868)
-- Name: number_type; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.number_type (
    id integer NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE prevendas.number_type OWNER TO postgres;

--
-- TOC entry 421 (class 1259 OID 33866)
-- Name: number_type_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.number_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.number_type_id_seq OWNER TO postgres;

--
-- TOC entry 5304 (class 0 OID 0)
-- Dependencies: 421
-- Name: number_type_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.number_type_id_seq OWNED BY prevendas.number_type.id;


--
-- TOC entry 424 (class 1259 OID 33879)
-- Name: plan; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.plan (
    id integer NOT NULL,
    fee_codigoid integer,
    name character varying NOT NULL,
    max_ddr integer,
    date_record timestamp(0) without time zone,
    date_end timestamp(0) without time zone,
    author integer
);


ALTER TABLE prevendas.plan OWNER TO postgres;

--
-- TOC entry 423 (class 1259 OID 33877)
-- Name: plan_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.plan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.plan_id_seq OWNER TO postgres;

--
-- TOC entry 5305 (class 0 OID 0)
-- Dependencies: 423
-- Name: plan_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.plan_id_seq OWNED BY prevendas.plan.id;


--
-- TOC entry 426 (class 1259 OID 33890)
-- Name: quotation; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.quotation (
    id integer NOT NULL,
    author integer,
    date_record timestamp(0) without time zone DEFAULT now() NOT NULL,
    client integer NOT NULL,
    service_id integer,
    speed integer,
    deadline integer
);


ALTER TABLE prevendas.quotation OWNER TO postgres;

--
-- TOC entry 428 (class 1259 OID 33899)
-- Name: quotation_address; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.quotation_address (
    id integer NOT NULL,
    cep character varying(8),
    street character varying(255),
    number character varying,
    lat numeric(15,10),
    lon numeric(15,10),
    quotation_id integer,
    selecao boolean
);


ALTER TABLE prevendas.quotation_address OWNER TO postgres;

--
-- TOC entry 427 (class 1259 OID 33897)
-- Name: quotation_address_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.quotation_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.quotation_address_id_seq OWNER TO postgres;

--
-- TOC entry 5306 (class 0 OID 0)
-- Dependencies: 427
-- Name: quotation_address_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.quotation_address_id_seq OWNED BY prevendas.quotation_address.id;


--
-- TOC entry 430 (class 1259 OID 33910)
-- Name: quotation_address_point; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.quotation_address_point (
    id integer NOT NULL,
    quotation_address_id integer,
    point_id integer,
    distance numeric(10,2),
    approximate boolean DEFAULT false NOT NULL,
    lpus text,
    name character varying
);


ALTER TABLE prevendas.quotation_address_point OWNER TO postgres;

--
-- TOC entry 429 (class 1259 OID 33908)
-- Name: quotation_address_point_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.quotation_address_point_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.quotation_address_point_id_seq OWNER TO postgres;

--
-- TOC entry 5307 (class 0 OID 0)
-- Dependencies: 429
-- Name: quotation_address_point_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.quotation_address_point_id_seq OWNED BY prevendas.quotation_address_point.id;


--
-- TOC entry 425 (class 1259 OID 33888)
-- Name: quotation_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.quotation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.quotation_id_seq OWNER TO postgres;

--
-- TOC entry 5308 (class 0 OID 0)
-- Dependencies: 425
-- Name: quotation_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.quotation_id_seq OWNED BY prevendas.quotation.id;


--
-- TOC entry 432 (class 1259 OID 33922)
-- Name: region; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.region (
    id integer NOT NULL,
    name character varying(100),
    max integer
);


ALTER TABLE prevendas.region OWNER TO postgres;

--
-- TOC entry 431 (class 1259 OID 33920)
-- Name: region_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.region_id_seq OWNER TO postgres;

--
-- TOC entry 5309 (class 0 OID 0)
-- Dependencies: 431
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.region_id_seq OWNED BY prevendas.region.id;


--
-- TOC entry 434 (class 1259 OID 33930)
-- Name: service; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.service (
    id integer NOT NULL,
    name character varying(100),
    serv_codigoid bigint,
    active boolean DEFAULT true,
    quotable boolean DEFAULT false NOT NULL
);


ALTER TABLE prevendas.service OWNER TO postgres;

--
-- TOC entry 433 (class 1259 OID 33928)
-- Name: service_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.service_id_seq OWNER TO postgres;

--
-- TOC entry 5310 (class 0 OID 0)
-- Dependencies: 433
-- Name: service_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.service_id_seq OWNED BY prevendas.service.id;


--
-- TOC entry 436 (class 1259 OID 33940)
-- Name: speed; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.speed (
    id integer NOT NULL,
    speed integer,
    activation_fare numeric(15,2),
    monthly_cost numeric(15,2),
    lpu_id integer,
    speed_type_id integer
);


ALTER TABLE prevendas.speed OWNER TO postgres;

--
-- TOC entry 435 (class 1259 OID 33938)
-- Name: speed_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.speed_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.speed_id_seq OWNER TO postgres;

--
-- TOC entry 5311 (class 0 OID 0)
-- Dependencies: 435
-- Name: speed_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.speed_id_seq OWNED BY prevendas.speed.id;


--
-- TOC entry 438 (class 1259 OID 33948)
-- Name: speed_type; Type: TABLE; Schema: prevendas; Owner: postgres
--

CREATE TABLE prevendas.speed_type (
    id integer NOT NULL,
    name character varying(10),
    multiplier integer DEFAULT 1 NOT NULL
);


ALTER TABLE prevendas.speed_type OWNER TO postgres;

--
-- TOC entry 437 (class 1259 OID 33946)
-- Name: speed_type_id_seq; Type: SEQUENCE; Schema: prevendas; Owner: postgres
--

CREATE SEQUENCE prevendas.speed_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE prevendas.speed_type_id_seq OWNER TO postgres;

--
-- TOC entry 5312 (class 0 OID 0)
-- Dependencies: 437
-- Name: speed_type_id_seq; Type: SEQUENCE OWNED BY; Schema: prevendas; Owner: postgres
--

ALTER SEQUENCE prevendas.speed_type_id_seq OWNED BY prevendas.speed_type.id;


--
-- TOC entry 442 (class 1259 OID 34006)
-- Name: modelo_switch; Type: TABLE; Schema: redes; Owner: postgres
--

CREATE TABLE redes.modelo_switch (
    id integer NOT NULL,
    nome character varying(255) NOT NULL,
    ativo boolean DEFAULT true NOT NULL
);


ALTER TABLE redes.modelo_switch OWNER TO postgres;

--
-- TOC entry 441 (class 1259 OID 34004)
-- Name: modelo_switch_id_seq; Type: SEQUENCE; Schema: redes; Owner: postgres
--

CREATE SEQUENCE redes.modelo_switch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE redes.modelo_switch_id_seq OWNER TO postgres;

--
-- TOC entry 5313 (class 0 OID 0)
-- Dependencies: 441
-- Name: modelo_switch_id_seq; Type: SEQUENCE OWNED BY; Schema: redes; Owner: postgres
--

ALTER SEQUENCE redes.modelo_switch_id_seq OWNED BY redes.modelo_switch.id;


--
-- TOC entry 446 (class 1259 OID 34064)
-- Name: porta; Type: TABLE; Schema: redes; Owner: postgres
--

CREATE TABLE redes.porta (
    id integer NOT NULL,
    switch_id integer NOT NULL,
    porta character varying(10) NOT NULL,
    admin_status character varying(10) DEFAULT 'down(2)'::character varying NOT NULL,
    oper_status character varying(10) NOT NULL,
    auto_neg character varying(10) NOT NULL,
    speed character varying(10) DEFAULT NULL::character varying,
    duplex character varying(13) DEFAULT NULL::character varying,
    modo character varying(14) NOT NULL,
    vlan_base character varying(10) DEFAULT NULL::character varying,
    flow_ctrl character varying(10) NOT NULL
);


ALTER TABLE redes.porta OWNER TO postgres;

--
-- TOC entry 445 (class 1259 OID 34062)
-- Name: porta_id_seq; Type: SEQUENCE; Schema: redes; Owner: postgres
--

CREATE SEQUENCE redes.porta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE redes.porta_id_seq OWNER TO postgres;

--
-- TOC entry 5314 (class 0 OID 0)
-- Dependencies: 445
-- Name: porta_id_seq; Type: SEQUENCE OWNED BY; Schema: redes; Owner: postgres
--

ALTER SEQUENCE redes.porta_id_seq OWNED BY redes.porta.id;


--
-- TOC entry 444 (class 1259 OID 34031)
-- Name: switch; Type: TABLE; Schema: redes; Owner: postgres
--

CREATE TABLE redes.switch (
    id integer NOT NULL,
    modelo_switch_id integer NOT NULL,
    nome character varying(255) NOT NULL,
    ip inet NOT NULL,
    vlan_base integer,
    ativo boolean DEFAULT true NOT NULL,
    data_cadastro timestamp(0) without time zone DEFAULT now() NOT NULL
);


ALTER TABLE redes.switch OWNER TO postgres;

--
-- TOC entry 443 (class 1259 OID 34029)
-- Name: switch_id_seq; Type: SEQUENCE; Schema: redes; Owner: postgres
--

CREATE SEQUENCE redes.switch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE redes.switch_id_seq OWNER TO postgres;

--
-- TOC entry 5315 (class 0 OID 0)
-- Dependencies: 443
-- Name: switch_id_seq; Type: SEQUENCE OWNED BY; Schema: redes; Owner: postgres
--

ALTER SEQUENCE redes.switch_id_seq OWNED BY redes.switch.id;


--
-- TOC entry 448 (class 1259 OID 34149)
-- Name: vlan; Type: TABLE; Schema: redes; Owner: postgres
--

CREATE TABLE redes.vlan (
    id integer NOT NULL,
    switch_id integer NOT NULL,
    descricao text,
    servico_id integer,
    status integer NOT NULL
);


ALTER TABLE redes.vlan OWNER TO postgres;

--
-- TOC entry 447 (class 1259 OID 34147)
-- Name: vlan_id_seq; Type: SEQUENCE; Schema: redes; Owner: postgres
--

CREATE SEQUENCE redes.vlan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE redes.vlan_id_seq OWNER TO postgres;

--
-- TOC entry 5316 (class 0 OID 0)
-- Dependencies: 447
-- Name: vlan_id_seq; Type: SEQUENCE OWNED BY; Schema: redes; Owner: postgres
--

ALTER SEQUENCE redes.vlan_id_seq OWNED BY redes.vlan.id;


--
-- TOC entry 205 (class 1259 OID 25092)
-- Name: circuits_cache; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.circuits_cache (
    id integer NOT NULL,
    designation character varying(255) NOT NULL,
    final_client character varying(255) NOT NULL,
    uf_ponta_a character varying(255) NOT NULL,
    client_id integer,
    sla character varying(255),
    city character varying(255)
);


ALTER TABLE troubleticket.circuits_cache OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 25098)
-- Name: clients_cache; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.clients_cache (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    nivel character varying(255) NOT NULL
);


ALTER TABLE troubleticket.clients_cache OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 25104)
-- Name: colaborators_cache; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.colaborators_cache (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE troubleticket.colaborators_cache OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 25107)
-- Name: configs; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.configs (
    name character varying(255) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE troubleticket.configs OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 25113)
-- Name: history; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.history (
    id integer NOT NULL,
    report_id integer NOT NULL,
    subcase_id integer,
    comment text NOT NULL,
    date timestamp without time zone NOT NULL,
    reason text,
    support_level character varying(255),
    report_status integer NOT NULL,
    usuario character varying(255)
);


ALTER TABLE troubleticket.history OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 25119)
-- Name: history_id_seq; Type: SEQUENCE; Schema: troubleticket; Owner: postgres
--

CREATE SEQUENCE troubleticket.history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE troubleticket.history_id_seq OWNER TO postgres;

--
-- TOC entry 5317 (class 0 OID 0)
-- Dependencies: 210
-- Name: history_id_seq; Type: SEQUENCE OWNED BY; Schema: troubleticket; Owner: postgres
--

ALTER SEQUENCE troubleticket.history_id_seq OWNED BY troubleticket.history.id;


--
-- TOC entry 211 (class 1259 OID 25121)
-- Name: messages; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.messages (
    id integer NOT NULL,
    report_id integer NOT NULL,
    message text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    user_id integer NOT NULL,
    reference_repository character varying(255) NOT NULL,
    reference_id character varying(255) NOT NULL,
    viewed_by integer
);


ALTER TABLE troubleticket.messages OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 25127)
-- Name: messages_id_seq; Type: SEQUENCE; Schema: troubleticket; Owner: postgres
--

CREATE SEQUENCE troubleticket.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE troubleticket.messages_id_seq OWNER TO postgres;

--
-- TOC entry 5318 (class 0 OID 0)
-- Dependencies: 212
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: troubleticket; Owner: postgres
--

ALTER SEQUENCE troubleticket.messages_id_seq OWNED BY troubleticket.messages.id;


--
-- TOC entry 213 (class 1259 OID 25132)
-- Name: pops_cache; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.pops_cache (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE troubleticket.pops_cache OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 25135)
-- Name: providers_cache; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.providers_cache (
    id integer NOT NULL,
    cnpj character varying(255) NOT NULL,
    razao_social character varying(255),
    nome_fantasia character varying(255)
);


ALTER TABLE troubleticket.providers_cache OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 25141)
-- Name: reports; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.reports (
    id integer NOT NULL,
    parent_id integer,
    circuit_id integer NOT NULL,
    designation character varying(255) NOT NULL,
    initial_date timestamp without time zone NOT NULL,
    final_date timestamp without time zone,
    type integer NOT NULL,
    description text,
    stack integer NOT NULL,
    operator_report_identifier character varying(255),
    responsible character varying(255),
    requester_name character varying(255),
    requester_phone character varying(255),
    requester_email character varying(255),
    cause character varying(255),
    failure character varying(255),
    failure_local character varying(255),
    problem character varying(255),
    status integer NOT NULL,
    solution character varying(255),
    tme_counter integer,
    paused_counter integer,
    solved_counter integer,
    tmr_counter integer,
    noc_counter integer,
    sn1_counter integer,
    sn2_counter integer,
    coc_counter integer,
    displacement_counter integer,
    infra_counter integer,
    field_counter integer,
    client_counter integer,
    sn1 integer,
    sn2 integer,
    code character varying(255) NOT NULL,
    close_reason text,
    symptom integer,
    stretch text,
    sn3 integer,
    sn3_counter integer,
    voz integer,
    voz_counter integer,
    last_update timestamp without time zone,
    created_by_client boolean NOT NULL,
    service_channel integer,
    closed_symptom integer,
    structure character varying(255),
    element character varying(255),
    pop_id integer,
    provider_id integer,
    incident character varying(255),
    created_by_system integer,
    mantainer_counter integer,
    first_combat timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    reopen_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    attendance_protocol character varying(255) DEFAULT NULL::character varying,
    opening_classification integer,
    service_type integer,
    monitoring_counter integer,
    opening_user integer,
    closing_user integer,
    bi_counter integer,
    issue character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE troubleticket.reports OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 25151)
-- Name: reports_ba_sequence; Type: SEQUENCE; Schema: troubleticket; Owner: postgres
--

CREATE SEQUENCE troubleticket.reports_ba_sequence
    START WITH 8
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE troubleticket.reports_ba_sequence OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 25153)
-- Name: reports_bi_sequence; Type: SEQUENCE; Schema: troubleticket; Owner: postgres
--

CREATE SEQUENCE troubleticket.reports_bi_sequence
    START WITH 7
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE troubleticket.reports_bi_sequence OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 25155)
-- Name: reports_bs_sequence; Type: SEQUENCE; Schema: troubleticket; Owner: postgres
--

CREATE SEQUENCE troubleticket.reports_bs_sequence
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE troubleticket.reports_bs_sequence OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 25157)
-- Name: reports_id_seq; Type: SEQUENCE; Schema: troubleticket; Owner: postgres
--

CREATE SEQUENCE troubleticket.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 999999999
    CACHE 1
    CYCLE;


ALTER TABLE troubleticket.reports_id_seq OWNER TO postgres;

--
-- TOC entry 5319 (class 0 OID 0)
-- Dependencies: 219
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: troubleticket; Owner: postgres
--

ALTER SEQUENCE troubleticket.reports_id_seq OWNED BY troubleticket.reports.id;


--
-- TOC entry 220 (class 1259 OID 25159)
-- Name: subcases; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.subcases (
    id integer NOT NULL,
    team character varying(255),
    forecast time without time zone,
    status integer NOT NULL,
    type integer NOT NULL,
    report_id integer NOT NULL,
    code character varying(255) NOT NULL,
    list_of_materials text,
    id_activity integer,
    activity_type character varying(12),
    provider integer,
    maintainer integer,
    maintainer_contact character varying(255) DEFAULT NULL::character varying,
    phone character varying(255) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    ticket character varying(255) DEFAULT NULL::character varying,
    element character varying(255) DEFAULT NULL::character varying,
    cause character varying(255) DEFAULT NULL::character varying,
    problem character varying(255) DEFAULT NULL::character varying,
    solution character varying(255) DEFAULT NULL::character varying,
    comment text,
    opening_user integer,
    closing_user integer,
    tme_counter integer,
    paused_counter integer,
    third_team_counter integer,
    displacement_counter integer,
    infra_counter integer,
    field_counter integer,
    client_counter integer,
    tmr_counter integer,
    initial_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    final_date timestamp(0) without time zone DEFAULT NULL::timestamp without time zone
);


ALTER TABLE troubleticket.subcases OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 25175)
-- Name: subcases_id_seq; Type: SEQUENCE; Schema: troubleticket; Owner: postgres
--

CREATE SEQUENCE troubleticket.subcases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE troubleticket.subcases_id_seq OWNER TO postgres;

--
-- TOC entry 5320 (class 0 OID 0)
-- Dependencies: 221
-- Name: subcases_id_seq; Type: SEQUENCE OWNED BY; Schema: troubleticket; Owner: postgres
--

ALTER SEQUENCE troubleticket.subcases_id_seq OWNED BY troubleticket.subcases.id;


--
-- TOC entry 222 (class 1259 OID 25177)
-- Name: time_counters; Type: TABLE; Schema: troubleticket; Owner: postgres
--

CREATE TABLE troubleticket.time_counters (
    id integer NOT NULL,
    report_id integer NOT NULL,
    initial_date timestamp without time zone NOT NULL,
    final_date timestamp without time zone,
    stack integer NOT NULL,
    subcase_id integer,
    subcase_status integer,
    report_status integer DEFAULT 0 NOT NULL
);


ALTER TABLE troubleticket.time_counters OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 25181)
-- Name: time_counters_id_seq; Type: SEQUENCE; Schema: troubleticket; Owner: postgres
--

CREATE SEQUENCE troubleticket.time_counters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE troubleticket.time_counters_id_seq OWNER TO postgres;

--
-- TOC entry 5321 (class 0 OID 0)
-- Dependencies: 223
-- Name: time_counters_id_seq; Type: SEQUENCE OWNED BY; Schema: troubleticket; Owner: postgres
--

ALTER SEQUENCE troubleticket.time_counters_id_seq OWNED BY troubleticket.time_counters.id;


--
-- TOC entry 4740 (class 2604 OID 33986)
-- Name: menu id; Type: DEFAULT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.menu ALTER COLUMN id SET DEFAULT nextval('autorizacao.menu_id_seq'::regclass);


--
-- TOC entry 4561 (class 2604 OID 25290)
-- Name: regra id; Type: DEFAULT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.regra ALTER COLUMN id SET DEFAULT nextval('autorizacao.regra_id_seq'::regclass);


--
-- TOC entry 4558 (class 2604 OID 25263)
-- Name: usuario id; Type: DEFAULT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.usuario ALTER COLUMN id SET DEFAULT nextval('autorizacao.usuario_id_seq'::regclass);


--
-- TOC entry 4577 (class 2604 OID 28744)
-- Name: agreement id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.agreement ALTER COLUMN id SET DEFAULT nextval('comercial.agreement_id_seq'::regclass);


--
-- TOC entry 4578 (class 2604 OID 28752)
-- Name: bank_information id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.bank_information ALTER COLUMN id SET DEFAULT nextval('comercial.bank_information_id_seq'::regclass);


--
-- TOC entry 4575 (class 2604 OID 28727)
-- Name: chance id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance ALTER COLUMN id SET DEFAULT nextval('comercial.chance_id_seq'::regclass);


--
-- TOC entry 4579 (class 2604 OID 28763)
-- Name: chance_classification id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_classification ALTER COLUMN id SET DEFAULT nextval('comercial.chance_classification_id_seq'::regclass);


--
-- TOC entry 4580 (class 2604 OID 28771)
-- Name: chance_closed id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_closed ALTER COLUMN id SET DEFAULT nextval('comercial.chance_closed_id_seq'::regclass);


--
-- TOC entry 4583 (class 2604 OID 28784)
-- Name: chance_contact id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_contact ALTER COLUMN id SET DEFAULT nextval('comercial.chance_contact_id_seq'::regclass);


--
-- TOC entry 4585 (class 2604 OID 28792)
-- Name: chance_inactive id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_inactive ALTER COLUMN id SET DEFAULT nextval('comercial.chance_inactive_id_seq'::regclass);


--
-- TOC entry 4588 (class 2604 OID 28805)
-- Name: chance_inactive_log id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_inactive_log ALTER COLUMN id SET DEFAULT nextval('comercial.chance_inactive_log_id_seq'::regclass);


--
-- TOC entry 4590 (class 2604 OID 28814)
-- Name: chance_indication id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_indication ALTER COLUMN id SET DEFAULT nextval('comercial.chance_indication_id_seq'::regclass);


--
-- TOC entry 4592 (class 2604 OID 28823)
-- Name: chance_status id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_status ALTER COLUMN id SET DEFAULT nextval('comercial.chance_status_id_seq'::regclass);


--
-- TOC entry 4593 (class 2604 OID 28837)
-- Name: chance_type id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_type ALTER COLUMN id SET DEFAULT nextval('comercial.chance_type_id_seq'::regclass);


--
-- TOC entry 4594 (class 2604 OID 28845)
-- Name: companies id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.companies ALTER COLUMN id SET DEFAULT nextval('comercial.companies_id_seq'::regclass);


--
-- TOC entry 4595 (class 2604 OID 28853)
-- Name: contract_denial_reason id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.contract_denial_reason ALTER COLUMN id SET DEFAULT nextval('comercial.contract_denial_reason_id_seq'::regclass);


--
-- TOC entry 4596 (class 2604 OID 28861)
-- Name: contract_denial_reason_category id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.contract_denial_reason_category ALTER COLUMN id SET DEFAULT nextval('comercial.contract_denial_reason_category_id_seq'::regclass);


--
-- TOC entry 4597 (class 2604 OID 28869)
-- Name: costs id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.costs ALTER COLUMN id SET DEFAULT nextval('comercial.costs_id_seq'::regclass);


--
-- TOC entry 4600 (class 2604 OID 28879)
-- Name: datacenter id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.datacenter ALTER COLUMN id SET DEFAULT nextval('comercial.datacenter_id_seq'::regclass);


--
-- TOC entry 4601 (class 2604 OID 28890)
-- Name: discount_competence id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.discount_competence ALTER COLUMN id SET DEFAULT nextval('comercial.discount_competence_id_seq'::regclass);


--
-- TOC entry 4602 (class 2604 OID 28898)
-- Name: discount_proposal id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.discount_proposal ALTER COLUMN id SET DEFAULT nextval('comercial.discount_proposal_id_seq'::regclass);


--
-- TOC entry 4603 (class 2604 OID 28909)
-- Name: discount_proposal_status id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.discount_proposal_status ALTER COLUMN id SET DEFAULT nextval('comercial.discount_proposal_status_id_seq'::regclass);


--
-- TOC entry 4605 (class 2604 OID 28921)
-- Name: ev_change id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.ev_change ALTER COLUMN id SET DEFAULT nextval('comercial.ev_change_id_seq'::regclass);


--
-- TOC entry 4606 (class 2604 OID 28929)
-- Name: favorite_address id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.favorite_address ALTER COLUMN id SET DEFAULT nextval('comercial.favorite_address_id_seq'::regclass);


--
-- TOC entry 4607 (class 2604 OID 28940)
-- Name: followup id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.followup ALTER COLUMN id SET DEFAULT nextval('comercial.followup_id_seq'::regclass);


--
-- TOC entry 4609 (class 2604 OID 28952)
-- Name: followup_action id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.followup_action ALTER COLUMN id SET DEFAULT nextval('comercial.followup_action_id_seq'::regclass);


--
-- TOC entry 4612 (class 2604 OID 28962)
-- Name: followup_contact id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.followup_contact ALTER COLUMN id SET DEFAULT nextval('comercial.followup_contact_id_seq'::regclass);


--
-- TOC entry 4613 (class 2604 OID 28970)
-- Name: global_address id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.global_address ALTER COLUMN id SET DEFAULT nextval('comercial.global_address_id_seq'::regclass);


--
-- TOC entry 4614 (class 2604 OID 28981)
-- Name: goal id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.goal ALTER COLUMN id SET DEFAULT nextval('comercial.goal_id_seq'::regclass);


--
-- TOC entry 4615 (class 2604 OID 28989)
-- Name: goal_history id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.goal_history ALTER COLUMN id SET DEFAULT nextval('comercial.goal_history_id_seq'::regclass);


--
-- TOC entry 4617 (class 2604 OID 28998)
-- Name: goal_type id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.goal_type ALTER COLUMN id SET DEFAULT nextval('comercial.goal_type_id_seq'::regclass);


--
-- TOC entry 4618 (class 2604 OID 29006)
-- Name: goal_wallet id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.goal_wallet ALTER COLUMN id SET DEFAULT nextval('comercial.goal_wallet_id_seq'::regclass);


--
-- TOC entry 4619 (class 2604 OID 29014)
-- Name: group_item id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.group_item ALTER COLUMN id SET DEFAULT nextval('comercial.group_item_id_seq'::regclass);


--
-- TOC entry 4620 (class 2604 OID 29022)
-- Name: grupo id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.grupo ALTER COLUMN id SET DEFAULT nextval('comercial.grupo_id_seq'::regclass);


--
-- TOC entry 4622 (class 2604 OID 29034)
-- Name: information id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.information ALTER COLUMN id SET DEFAULT nextval('comercial.information_id_seq'::regclass);


--
-- TOC entry 4623 (class 2604 OID 29045)
-- Name: lost_action id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.lost_action ALTER COLUMN id SET DEFAULT nextval('comercial.lost_action_id_seq'::regclass);


--
-- TOC entry 4624 (class 2604 OID 29053)
-- Name: lost_chance id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.lost_chance ALTER COLUMN id SET DEFAULT nextval('comercial.lost_chance_id_seq'::regclass);


--
-- TOC entry 4626 (class 2604 OID 29065)
-- Name: number_imported id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.number_imported ALTER COLUMN id SET DEFAULT nextval('comercial.number_imported_id_seq'::regclass);


--
-- TOC entry 4627 (class 2604 OID 29073)
-- Name: proposal id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_id_seq'::regclass);


--
-- TOC entry 4631 (class 2604 OID 29087)
-- Name: proposal_address id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_address ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_address_id_seq'::regclass);


--
-- TOC entry 4632 (class 2604 OID 29098)
-- Name: proposal_benefits id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_benefits ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_benefits_id_seq'::regclass);


--
-- TOC entry 4633 (class 2604 OID 29106)
-- Name: proposal_circuit id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_circuit ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_circuit_id_seq'::regclass);


--
-- TOC entry 4638 (class 2604 OID 29121)
-- Name: proposal_circuit_sva id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_circuit_sva ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_circuit_sva_id_seq'::regclass);


--
-- TOC entry 4641 (class 2604 OID 29131)
-- Name: proposal_circuit_sva_products id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_circuit_sva_products ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_circuit_sva_products_id_seq'::regclass);


--
-- TOC entry 4642 (class 2604 OID 29139)
-- Name: proposal_document id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_document ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_document_id_seq'::regclass);


--
-- TOC entry 4643 (class 2604 OID 29150)
-- Name: proposal_feature id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_feature ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_feature_id_seq'::regclass);


--
-- TOC entry 4644 (class 2604 OID 29161)
-- Name: proposal_information proposal_id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_information ALTER COLUMN proposal_id SET DEFAULT nextval('comercial.proposal_information_proposal_id_seq'::regclass);


--
-- TOC entry 4645 (class 2604 OID 29169)
-- Name: proposal_number id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_number ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_number_id_seq'::regclass);


--
-- TOC entry 4646 (class 2604 OID 29182)
-- Name: proposal_odt id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_odt ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_odt_id_seq'::regclass);


--
-- TOC entry 4647 (class 2604 OID 29190)
-- Name: proposal_protocol id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_protocol ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_protocol_id_seq'::regclass);


--
-- TOC entry 4651 (class 2604 OID 29204)
-- Name: proposal_protocol_historic id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_protocol_historic ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_protocol_historic_id_seq'::regclass);


--
-- TOC entry 4652 (class 2604 OID 29215)
-- Name: proposal_protocol_status id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_protocol_status ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_protocol_status_id_seq'::regclass);


--
-- TOC entry 4653 (class 2604 OID 29226)
-- Name: proposal_responsible id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_responsible ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_responsible_id_seq'::regclass);


--
-- TOC entry 4654 (class 2604 OID 29237)
-- Name: proposal_responsible_type id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_responsible_type ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_responsible_type_id_seq'::regclass);


--
-- TOC entry 4655 (class 2604 OID 29248)
-- Name: proposal_status id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_status ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_status_id_seq'::regclass);


--
-- TOC entry 4657 (class 2604 OID 29260)
-- Name: proposal_time_counters id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_time_counters ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_time_counters_id_seq'::regclass);


--
-- TOC entry 4659 (class 2604 OID 29269)
-- Name: proposal_time_counters_stacks id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_time_counters_stacks ALTER COLUMN id SET DEFAULT nextval('comercial.proposal_time_counters_stacks_id_seq'::regclass);


--
-- TOC entry 4572 (class 2604 OID 28707)
-- Name: prospect id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.prospect ALTER COLUMN id SET DEFAULT nextval('comercial.prospect_id_seq'::regclass);


--
-- TOC entry 4660 (class 2604 OID 29277)
-- Name: ranking id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.ranking ALTER COLUMN id SET DEFAULT nextval('comercial.ranking_id_seq'::regclass);


--
-- TOC entry 4663 (class 2604 OID 29287)
-- Name: reason_category id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.reason_category ALTER COLUMN id SET DEFAULT nextval('comercial.reason_category_id_seq'::regclass);


--
-- TOC entry 4664 (class 2604 OID 29295)
-- Name: requirement id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.requirement ALTER COLUMN id SET DEFAULT nextval('comercial.requirement_id_seq'::regclass);


--
-- TOC entry 4665 (class 2604 OID 29306)
-- Name: return_reason id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.return_reason ALTER COLUMN id SET DEFAULT nextval('comercial.return_reason_id_seq'::regclass);


--
-- TOC entry 4564 (class 2604 OID 28678)
-- Name: service id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.service ALTER COLUMN id SET DEFAULT nextval('comercial.service_id_seq'::regclass);


--
-- TOC entry 4666 (class 2604 OID 29314)
-- Name: sva id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.sva ALTER COLUMN id SET DEFAULT nextval('comercial.sva_id_seq'::regclass);


--
-- TOC entry 4570 (class 2604 OID 28698)
-- Name: tag id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.tag ALTER COLUMN id SET DEFAULT nextval('comercial.tag_id_seq'::regclass);


--
-- TOC entry 4667 (class 2604 OID 29322)
-- Name: team id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.team ALTER COLUMN id SET DEFAULT nextval('comercial.team_id_seq'::regclass);


--
-- TOC entry 4670 (class 2604 OID 29332)
-- Name: team_state id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.team_state ALTER COLUMN id SET DEFAULT nextval('comercial.team_state_id_seq'::regclass);


--
-- TOC entry 4673 (class 2604 OID 29342)
-- Name: team_type id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.team_type ALTER COLUMN id SET DEFAULT nextval('comercial.team_type_id_seq'::regclass);


--
-- TOC entry 4676 (class 2604 OID 29352)
-- Name: team_user id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.team_user ALTER COLUMN id SET DEFAULT nextval('comercial.team_user_id_seq'::regclass);


--
-- TOC entry 4679 (class 2604 OID 29362)
-- Name: thirdservice id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.thirdservice ALTER COLUMN id SET DEFAULT nextval('comercial.thirdservice_id_seq'::regclass);


--
-- TOC entry 4680 (class 2604 OID 29373)
-- Name: type_thirdservice id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.type_thirdservice ALTER COLUMN id SET DEFAULT nextval('comercial.type_thirdservice_id_seq'::regclass);


--
-- TOC entry 4681 (class 2604 OID 29384)
-- Name: viable id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable ALTER COLUMN id SET DEFAULT nextval('comercial.viable_id_seq'::regclass);


--
-- TOC entry 4688 (class 2604 OID 29397)
-- Name: viable_approval id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_approval ALTER COLUMN id SET DEFAULT nextval('comercial.viable_approval_id_seq'::regclass);


--
-- TOC entry 4689 (class 2604 OID 29408)
-- Name: viable_approval_thirdservice id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_approval_thirdservice ALTER COLUMN id SET DEFAULT nextval('comercial.viable_approval_thirdservice_id_seq'::regclass);


--
-- TOC entry 4690 (class 2604 OID 29416)
-- Name: viable_document id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_document ALTER COLUMN id SET DEFAULT nextval('comercial.viable_document_id_seq'::regclass);


--
-- TOC entry 4692 (class 2604 OID 29425)
-- Name: viable_feature id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_feature ALTER COLUMN id SET DEFAULT nextval('comercial.viable_feature_id_seq'::regclass);


--
-- TOC entry 4693 (class 2604 OID 29438)
-- Name: viable_requirement id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_requirement ALTER COLUMN id SET DEFAULT nextval('comercial.viable_requirement_id_seq'::regclass);


--
-- TOC entry 4694 (class 2604 OID 29446)
-- Name: viable_status id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_status ALTER COLUMN id SET DEFAULT nextval('comercial.viable_status_id_seq'::regclass);


--
-- TOC entry 4695 (class 2604 OID 29454)
-- Name: vip id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.vip ALTER COLUMN id SET DEFAULT nextval('comercial.vip_id_seq'::regclass);


--
-- TOC entry 4697 (class 2604 OID 29466)
-- Name: vip_level id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.vip_level ALTER COLUMN id SET DEFAULT nextval('comercial.vip_level_id_seq'::regclass);


--
-- TOC entry 4567 (class 2604 OID 28688)
-- Name: wallet id; Type: DEFAULT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.wallet ALTER COLUMN id SET DEFAULT nextval('comercial.wallet_id_seq'::regclass);


--
-- TOC entry 4700 (class 2604 OID 33619)
-- Name: kmz id; Type: DEFAULT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.kmz ALTER COLUMN id SET DEFAULT nextval('engenharia.kmz_id_seq'::regclass);


--
-- TOC entry 4698 (class 2604 OID 33603)
-- Name: kmz_file id; Type: DEFAULT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.kmz_file ALTER COLUMN id SET DEFAULT nextval('engenharia.kmz_file_id_seq'::regclass);


--
-- TOC entry 4703 (class 2604 OID 33657)
-- Name: location id; Type: DEFAULT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.location ALTER COLUMN id SET DEFAULT nextval('engenharia.location_id_seq'::regclass);


--
-- TOC entry 4701 (class 2604 OID 33640)
-- Name: point id; Type: DEFAULT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.point ALTER COLUMN id SET DEFAULT nextval('engenharia.point_id_seq'::regclass);


--
-- TOC entry 4699 (class 2604 OID 33611)
-- Name: type id; Type: DEFAULT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.type ALTER COLUMN id SET DEFAULT nextval('engenharia.type_id_seq'::regclass);


--
-- TOC entry 4757 (class 2604 OID 34300)
-- Name: endereco id; Type: DEFAULT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.endereco ALTER COLUMN id SET DEFAULT nextval('pessoas.endereco_id_seq'::regclass);


--
-- TOC entry 4756 (class 2604 OID 34287)
-- Name: nome id; Type: DEFAULT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.nome ALTER COLUMN id SET DEFAULT nextval('pessoas.nome_id_seq'::regclass);


--
-- TOC entry 4752 (class 2604 OID 34188)
-- Name: pessoa id; Type: DEFAULT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa ALTER COLUMN id SET DEFAULT nextval('pessoas.pessoa_id_seq'::regclass);


--
-- TOC entry 4704 (class 2604 OID 33768)
-- Name: capex id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.capex ALTER COLUMN id SET DEFAULT nextval('prevendas.capex_id_seq'::regclass);


--
-- TOC entry 4705 (class 2604 OID 33776)
-- Name: distance id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.distance ALTER COLUMN id SET DEFAULT nextval('prevendas.distance_id_seq'::regclass);


--
-- TOC entry 4708 (class 2604 OID 33786)
-- Name: feature id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.feature ALTER COLUMN id SET DEFAULT nextval('prevendas.feature_id_seq'::regclass);


--
-- TOC entry 4710 (class 2604 OID 33798)
-- Name: feature_attribute id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.feature_attribute ALTER COLUMN id SET DEFAULT nextval('prevendas.feature_attribute_id_seq'::regclass);


--
-- TOC entry 4713 (class 2604 OID 33811)
-- Name: lpu id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu ALTER COLUMN id SET DEFAULT nextval('prevendas.lpu_id_seq'::regclass);


--
-- TOC entry 4720 (class 2604 OID 33823)
-- Name: lpu_customer id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_customer ALTER COLUMN id SET DEFAULT nextval('prevendas.lpu_customer_id_seq'::regclass);


--
-- TOC entry 4721 (class 2604 OID 33831)
-- Name: lpu_feature id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_feature ALTER COLUMN id SET DEFAULT nextval('prevendas.lpu_feature_id_seq'::regclass);


--
-- TOC entry 4722 (class 2604 OID 33839)
-- Name: lpu_plan id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_plan ALTER COLUMN id SET DEFAULT nextval('prevendas.lpu_plan_id_seq'::regclass);


--
-- TOC entry 4723 (class 2604 OID 33847)
-- Name: lpu_point id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_point ALTER COLUMN id SET DEFAULT nextval('prevendas.lpu_point_id_seq'::regclass);


--
-- TOC entry 4724 (class 2604 OID 33855)
-- Name: lpu_price id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_price ALTER COLUMN id SET DEFAULT nextval('prevendas.lpu_price_id_seq'::regclass);


--
-- TOC entry 4725 (class 2604 OID 33863)
-- Name: number id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.number ALTER COLUMN id SET DEFAULT nextval('prevendas.number_id_seq'::regclass);


--
-- TOC entry 4726 (class 2604 OID 33871)
-- Name: number_type id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.number_type ALTER COLUMN id SET DEFAULT nextval('prevendas.number_type_id_seq'::regclass);


--
-- TOC entry 4727 (class 2604 OID 33882)
-- Name: plan id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.plan ALTER COLUMN id SET DEFAULT nextval('prevendas.plan_id_seq'::regclass);


--
-- TOC entry 4728 (class 2604 OID 33893)
-- Name: quotation id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.quotation ALTER COLUMN id SET DEFAULT nextval('prevendas.quotation_id_seq'::regclass);


--
-- TOC entry 4730 (class 2604 OID 33902)
-- Name: quotation_address id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.quotation_address ALTER COLUMN id SET DEFAULT nextval('prevendas.quotation_address_id_seq'::regclass);


--
-- TOC entry 4731 (class 2604 OID 33913)
-- Name: quotation_address_point id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.quotation_address_point ALTER COLUMN id SET DEFAULT nextval('prevendas.quotation_address_point_id_seq'::regclass);


--
-- TOC entry 4733 (class 2604 OID 33925)
-- Name: region id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.region ALTER COLUMN id SET DEFAULT nextval('prevendas.region_id_seq'::regclass);


--
-- TOC entry 4734 (class 2604 OID 33933)
-- Name: service id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.service ALTER COLUMN id SET DEFAULT nextval('prevendas.service_id_seq'::regclass);


--
-- TOC entry 4737 (class 2604 OID 33943)
-- Name: speed id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.speed ALTER COLUMN id SET DEFAULT nextval('prevendas.speed_id_seq'::regclass);


--
-- TOC entry 4738 (class 2604 OID 33951)
-- Name: speed_type id; Type: DEFAULT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.speed_type ALTER COLUMN id SET DEFAULT nextval('prevendas.speed_type_id_seq'::regclass);


--
-- TOC entry 4741 (class 2604 OID 34009)
-- Name: modelo_switch id; Type: DEFAULT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.modelo_switch ALTER COLUMN id SET DEFAULT nextval('redes.modelo_switch_id_seq'::regclass);


--
-- TOC entry 4746 (class 2604 OID 34067)
-- Name: porta id; Type: DEFAULT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.porta ALTER COLUMN id SET DEFAULT nextval('redes.porta_id_seq'::regclass);


--
-- TOC entry 4743 (class 2604 OID 34034)
-- Name: switch id; Type: DEFAULT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.switch ALTER COLUMN id SET DEFAULT nextval('redes.switch_id_seq'::regclass);


--
-- TOC entry 4751 (class 2604 OID 34152)
-- Name: vlan id; Type: DEFAULT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.vlan ALTER COLUMN id SET DEFAULT nextval('redes.vlan_id_seq'::regclass);


--
-- TOC entry 4538 (class 2604 OID 25183)
-- Name: history id; Type: DEFAULT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.history ALTER COLUMN id SET DEFAULT nextval('troubleticket.history_id_seq'::regclass);


--
-- TOC entry 4539 (class 2604 OID 25184)
-- Name: messages id; Type: DEFAULT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.messages ALTER COLUMN id SET DEFAULT nextval('troubleticket.messages_id_seq'::regclass);


--
-- TOC entry 4543 (class 2604 OID 25185)
-- Name: reports id; Type: DEFAULT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.reports ALTER COLUMN id SET DEFAULT nextval('troubleticket.reports_id_seq'::regclass);


--
-- TOC entry 4555 (class 2604 OID 25186)
-- Name: subcases id; Type: DEFAULT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.subcases ALTER COLUMN id SET DEFAULT nextval('troubleticket.subcases_id_seq'::regclass);


--
-- TOC entry 4556 (class 2604 OID 25187)
-- Name: time_counters id; Type: DEFAULT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.time_counters ALTER COLUMN id SET DEFAULT nextval('troubleticket.time_counters_id_seq'::regclass);


--
-- TOC entry 5018 (class 2606 OID 33988)
-- Name: menu menu_pkey; Type: CONSTRAINT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (id);


--
-- TOC entry 4787 (class 2606 OID 25295)
-- Name: regra regras_pkey; Type: CONSTRAINT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.regra
    ADD CONSTRAINT regras_pkey PRIMARY KEY (id);


--
-- TOC entry 4563 (class 2606 OID 33980)
-- Name: usuario_regra usuario_regra_check; Type: CHECK CONSTRAINT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE autorizacao.usuario_regra
    ADD CONSTRAINT usuario_regra_check CHECK (((valor >= 1) OR (valor <= 15))) NOT VALID;


--
-- TOC entry 4789 (class 2606 OID 25297)
-- Name: usuario_regra usuario_regra_pkey; Type: CONSTRAINT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.usuario_regra
    ADD CONSTRAINT usuario_regra_pkey PRIMARY KEY (id_usuarios, id_regras);


--
-- TOC entry 4783 (class 2606 OID 25285)
-- Name: usuario usuarios_pkey; Type: CONSTRAINT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.usuario
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4785 (class 2606 OID 25287)
-- Name: usuario usuarios_unique; Type: CONSTRAINT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.usuario
    ADD CONSTRAINT usuarios_unique UNIQUE (username);


--
-- TOC entry 4805 (class 2606 OID 28738)
-- Name: activation_deadline activation_deadline_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.activation_deadline
    ADD CONSTRAINT activation_deadline_pkey PRIMARY KEY (state);


--
-- TOC entry 4807 (class 2606 OID 28746)
-- Name: agreement agreement_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.agreement
    ADD CONSTRAINT agreement_pkey PRIMARY KEY (id);


--
-- TOC entry 4809 (class 2606 OID 28757)
-- Name: bank_information banc_information_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.bank_information
    ADD CONSTRAINT banc_information_pkey PRIMARY KEY (id);


--
-- TOC entry 4811 (class 2606 OID 28765)
-- Name: chance_classification chance_classification_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_classification
    ADD CONSTRAINT chance_classification_pkey PRIMARY KEY (id);


--
-- TOC entry 4813 (class 2606 OID 28778)
-- Name: chance_closed chance_closed_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_closed
    ADD CONSTRAINT chance_closed_pkey PRIMARY KEY (id);


--
-- TOC entry 4816 (class 2606 OID 28786)
-- Name: chance_contact chance_contact_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_contact
    ADD CONSTRAINT chance_contact_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 28808)
-- Name: chance_inactive_log chance_inactive_log_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_inactive_log
    ADD CONSTRAINT chance_inactive_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4819 (class 2606 OID 28799)
-- Name: chance_inactive chance_inactive_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_inactive
    ADD CONSTRAINT chance_inactive_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 28817)
-- Name: chance_indication chance_indication_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_indication
    ADD CONSTRAINT chance_indication_pkey PRIMARY KEY (id);


--
-- TOC entry 4799 (class 2606 OID 28733)
-- Name: chance chance_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance
    ADD CONSTRAINT chance_pkey PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 28825)
-- Name: chance_status chance_status_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_status
    ADD CONSTRAINT chance_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 28831)
-- Name: chance_tag chance_tag_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_tag
    ADD CONSTRAINT chance_tag_pkey PRIMARY KEY (id_tag, id_chance);


--
-- TOC entry 4831 (class 2606 OID 28839)
-- Name: chance_type chance_type_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_type
    ADD CONSTRAINT chance_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 28847)
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 28863)
-- Name: contract_denial_reason_category contract_denial_reason_category_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.contract_denial_reason_category
    ADD CONSTRAINT contract_denial_reason_category_pkey PRIMARY KEY (id);


--
-- TOC entry 4835 (class 2606 OID 28855)
-- Name: contract_denial_reason contract_denial_reason_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.contract_denial_reason
    ADD CONSTRAINT contract_denial_reason_pkey PRIMARY KEY (id);


--
-- TOC entry 4839 (class 2606 OID 28873)
-- Name: costs costs_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.costs
    ADD CONSTRAINT costs_pkey PRIMARY KEY (id);


--
-- TOC entry 4841 (class 2606 OID 28884)
-- Name: datacenter datacenter_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.datacenter
    ADD CONSTRAINT datacenter_pkey PRIMARY KEY (id);


--
-- TOC entry 4843 (class 2606 OID 28892)
-- Name: discount_competence discount_competence_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.discount_competence
    ADD CONSTRAINT discount_competence_pkey PRIMARY KEY (id);


--
-- TOC entry 4845 (class 2606 OID 28903)
-- Name: discount_proposal discount_proposal_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.discount_proposal
    ADD CONSTRAINT discount_proposal_pkey PRIMARY KEY (id);


--
-- TOC entry 4847 (class 2606 OID 28915)
-- Name: discount_proposal_status discount_proposal_status_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.discount_proposal_status
    ADD CONSTRAINT discount_proposal_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4849 (class 2606 OID 28923)
-- Name: ev_change ev_change_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.ev_change
    ADD CONSTRAINT ev_change_pkey PRIMARY KEY (id);


--
-- TOC entry 4851 (class 2606 OID 28934)
-- Name: favorite_address favorite_address_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.favorite_address
    ADD CONSTRAINT favorite_address_pkey PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 28956)
-- Name: followup_action followup_action_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.followup_action
    ADD CONSTRAINT followup_action_pkey PRIMARY KEY (id);


--
-- TOC entry 4857 (class 2606 OID 28964)
-- Name: followup_contact followup_contact_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.followup_contact
    ADD CONSTRAINT followup_contact_pkey PRIMARY KEY (id);


--
-- TOC entry 4853 (class 2606 OID 28946)
-- Name: followup followup_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.followup
    ADD CONSTRAINT followup_pkey PRIMARY KEY (id);


--
-- TOC entry 4859 (class 2606 OID 28975)
-- Name: global_address global_address_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.global_address
    ADD CONSTRAINT global_address_pkey PRIMARY KEY (id);


--
-- TOC entry 4863 (class 2606 OID 28992)
-- Name: goal_history goal_history_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.goal_history
    ADD CONSTRAINT goal_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4861 (class 2606 OID 28983)
-- Name: goal goal_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.goal
    ADD CONSTRAINT goal_pkey PRIMARY KEY (id);


--
-- TOC entry 4865 (class 2606 OID 29000)
-- Name: goal_type goal_type_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.goal_type
    ADD CONSTRAINT goal_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 29008)
-- Name: goal_wallet goal_wallet_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.goal_wallet
    ADD CONSTRAINT goal_wallet_pkey PRIMARY KEY (id);


--
-- TOC entry 4869 (class 2606 OID 29016)
-- Name: group_item group_item_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.group_item
    ADD CONSTRAINT group_item_pkey PRIMARY KEY (id);


--
-- TOC entry 4871 (class 2606 OID 29028)
-- Name: grupo group_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.grupo
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);


--
-- TOC entry 4873 (class 2606 OID 29039)
-- Name: information information_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.information
    ADD CONSTRAINT information_pkey PRIMARY KEY (id);


--
-- TOC entry 4876 (class 2606 OID 29047)
-- Name: lost_action lost_action_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.lost_action
    ADD CONSTRAINT lost_action_pkey PRIMARY KEY (id);


--
-- TOC entry 4881 (class 2606 OID 29059)
-- Name: lost_chance lost_chance_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.lost_chance
    ADD CONSTRAINT lost_chance_pkey PRIMARY KEY (id);


--
-- TOC entry 4883 (class 2606 OID 29067)
-- Name: number_imported number_imported_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.number_imported
    ADD CONSTRAINT number_imported_pkey PRIMARY KEY (id);


--
-- TOC entry 4887 (class 2606 OID 29092)
-- Name: proposal_address proposal_address_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_address
    ADD CONSTRAINT proposal_address_pkey PRIMARY KEY (id);


--
-- TOC entry 4889 (class 2606 OID 29100)
-- Name: proposal_benefits proposal_benefits_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_benefits
    ADD CONSTRAINT proposal_benefits_pkey PRIMARY KEY (id);


--
-- TOC entry 4891 (class 2606 OID 29115)
-- Name: proposal_circuit proposal_circuit_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_circuit
    ADD CONSTRAINT proposal_circuit_pkey PRIMARY KEY (id);


--
-- TOC entry 4893 (class 2606 OID 29125)
-- Name: proposal_circuit_sva proposal_circuit_sva_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_circuit_sva
    ADD CONSTRAINT proposal_circuit_sva_pkey PRIMARY KEY (id);


--
-- TOC entry 4895 (class 2606 OID 29133)
-- Name: proposal_circuit_sva_products proposal_circuit_sva_products_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_circuit_sva_products
    ADD CONSTRAINT proposal_circuit_sva_products_pkey PRIMARY KEY (id);


--
-- TOC entry 4897 (class 2606 OID 29144)
-- Name: proposal_document proposal_document_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_document
    ADD CONSTRAINT proposal_document_pkey PRIMARY KEY (id);


--
-- TOC entry 4899 (class 2606 OID 29155)
-- Name: proposal_feature proposal_feature_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_feature
    ADD CONSTRAINT proposal_feature_pkey PRIMARY KEY (id);


--
-- TOC entry 4901 (class 2606 OID 29163)
-- Name: proposal_information proposal_information_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_information
    ADD CONSTRAINT proposal_information_pkey PRIMARY KEY (proposal_id, information_id);


--
-- TOC entry 4905 (class 2606 OID 29176)
-- Name: proposal_number_imported proposal_number_imported_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_number_imported
    ADD CONSTRAINT proposal_number_imported_pkey PRIMARY KEY (proposal_id, number_imported_id);


--
-- TOC entry 4903 (class 2606 OID 29171)
-- Name: proposal_number proposal_number_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_number
    ADD CONSTRAINT proposal_number_pkey PRIMARY KEY (id);


--
-- TOC entry 4907 (class 2606 OID 29184)
-- Name: proposal_odt proposal_odt_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_odt
    ADD CONSTRAINT proposal_odt_pkey PRIMARY KEY (id);


--
-- TOC entry 4885 (class 2606 OID 29081)
-- Name: proposal proposal_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal
    ADD CONSTRAINT proposal_pkey PRIMARY KEY (id);


--
-- TOC entry 4911 (class 2606 OID 29209)
-- Name: proposal_protocol_historic proposal_protocol_historic_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_protocol_historic
    ADD CONSTRAINT proposal_protocol_historic_pkey PRIMARY KEY (id);


--
-- TOC entry 4909 (class 2606 OID 29198)
-- Name: proposal_protocol proposal_protocol_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_protocol
    ADD CONSTRAINT proposal_protocol_pkey PRIMARY KEY (id);


--
-- TOC entry 4913 (class 2606 OID 29220)
-- Name: proposal_protocol_status proposal_protocol_status_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_protocol_status
    ADD CONSTRAINT proposal_protocol_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4915 (class 2606 OID 29231)
-- Name: proposal_responsible proposal_responsible_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_responsible
    ADD CONSTRAINT proposal_responsible_pkey PRIMARY KEY (id);


--
-- TOC entry 4917 (class 2606 OID 29242)
-- Name: proposal_responsible_type proposal_responsible_type_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_responsible_type
    ADD CONSTRAINT proposal_responsible_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4919 (class 2606 OID 29254)
-- Name: proposal_status proposal_status_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_status
    ADD CONSTRAINT proposal_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4921 (class 2606 OID 29263)
-- Name: proposal_time_counters proposal_time_counters_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_time_counters
    ADD CONSTRAINT proposal_time_counters_pkey PRIMARY KEY (id);


--
-- TOC entry 4923 (class 2606 OID 29271)
-- Name: proposal_time_counters_stacks proposal_time_counters_stacks_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.proposal_time_counters_stacks
    ADD CONSTRAINT proposal_time_counters_stacks_pkey PRIMARY KEY (id);


--
-- TOC entry 4797 (class 2606 OID 28711)
-- Name: prospect prospect_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.prospect
    ADD CONSTRAINT prospect_pkey PRIMARY KEY (id);


--
-- TOC entry 4925 (class 2606 OID 29281)
-- Name: ranking ranking_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.ranking
    ADD CONSTRAINT ranking_pkey PRIMARY KEY (id);


--
-- TOC entry 4927 (class 2606 OID 29289)
-- Name: reason_category reason_category_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.reason_category
    ADD CONSTRAINT reason_category_pkey PRIMARY KEY (id);


--
-- TOC entry 4929 (class 2606 OID 29300)
-- Name: requirement requirement_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.requirement
    ADD CONSTRAINT requirement_pkey PRIMARY KEY (id);


--
-- TOC entry 4931 (class 2606 OID 29308)
-- Name: return_reason return_reason_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.return_reason
    ADD CONSTRAINT return_reason_pkey PRIMARY KEY (id);


--
-- TOC entry 4791 (class 2606 OID 28682)
-- Name: service service_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- TOC entry 4933 (class 2606 OID 29316)
-- Name: sva sva_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.sva
    ADD CONSTRAINT sva_pkey PRIMARY KEY (id);


--
-- TOC entry 4795 (class 2606 OID 28701)
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);


--
-- TOC entry 4935 (class 2606 OID 29326)
-- Name: team team_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.team
    ADD CONSTRAINT team_pkey PRIMARY KEY (id);


--
-- TOC entry 4937 (class 2606 OID 29336)
-- Name: team_state team_state_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.team_state
    ADD CONSTRAINT team_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4939 (class 2606 OID 29346)
-- Name: team_type team_type_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.team_type
    ADD CONSTRAINT team_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4941 (class 2606 OID 29356)
-- Name: team_user team_user_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.team_user
    ADD CONSTRAINT team_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4943 (class 2606 OID 29367)
-- Name: thirdservice thirdservice_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.thirdservice
    ADD CONSTRAINT thirdservice_pkey PRIMARY KEY (id);


--
-- TOC entry 4945 (class 2606 OID 29378)
-- Name: type_thirdservice type_thirdservice_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.type_thirdservice
    ADD CONSTRAINT type_thirdservice_pkey PRIMARY KEY (id);


--
-- TOC entry 4950 (class 2606 OID 29402)
-- Name: viable_approval viable_approval_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_approval
    ADD CONSTRAINT viable_approval_pkey PRIMARY KEY (id);


--
-- TOC entry 4952 (class 2606 OID 29410)
-- Name: viable_approval_thirdservice viable_approval_thirdservice_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_approval_thirdservice
    ADD CONSTRAINT viable_approval_thirdservice_pkey PRIMARY KEY (id);


--
-- TOC entry 4954 (class 2606 OID 29419)
-- Name: viable_document viable_document_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_document
    ADD CONSTRAINT viable_document_pkey PRIMARY KEY (id);


--
-- TOC entry 4956 (class 2606 OID 29427)
-- Name: viable_feature viable_feature_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_feature
    ADD CONSTRAINT viable_feature_pkey PRIMARY KEY (id);


--
-- TOC entry 4948 (class 2606 OID 29391)
-- Name: viable viable_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable
    ADD CONSTRAINT viable_pkey PRIMARY KEY (id);


--
-- TOC entry 4958 (class 2606 OID 29432)
-- Name: viable_point viable_point_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_point
    ADD CONSTRAINT viable_point_pkey PRIMARY KEY (viable_id, point_id);


--
-- TOC entry 4960 (class 2606 OID 29440)
-- Name: viable_requirement viable_requirement_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_requirement
    ADD CONSTRAINT viable_requirement_pkey PRIMARY KEY (id);


--
-- TOC entry 4962 (class 2606 OID 29448)
-- Name: viable_status viable_status_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable_status
    ADD CONSTRAINT viable_status_pkey PRIMARY KEY (id);


--
-- TOC entry 4966 (class 2606 OID 29468)
-- Name: vip_level vip_level_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.vip_level
    ADD CONSTRAINT vip_level_pkey PRIMARY KEY (id);


--
-- TOC entry 4964 (class 2606 OID 29460)
-- Name: vip vip_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.vip
    ADD CONSTRAINT vip_pkey PRIMARY KEY (id);


--
-- TOC entry 4793 (class 2606 OID 28692)
-- Name: wallet wallet_pkey; Type: CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.wallet
    ADD CONSTRAINT wallet_pkey PRIMARY KEY (id);


--
-- TOC entry 4968 (class 2606 OID 33605)
-- Name: kmz_file kmz_file_pkey; Type: CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.kmz_file
    ADD CONSTRAINT kmz_file_pkey PRIMARY KEY (id);


--
-- TOC entry 4972 (class 2606 OID 33624)
-- Name: kmz kmz_pkey; Type: CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.kmz
    ADD CONSTRAINT kmz_pkey PRIMARY KEY (id);


--
-- TOC entry 4976 (class 2606 OID 33659)
-- Name: location location_pkey; Type: CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- TOC entry 4974 (class 2606 OID 33646)
-- Name: point point_pkey; Type: CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.point
    ADD CONSTRAINT point_pkey PRIMARY KEY (id);


--
-- TOC entry 4970 (class 2606 OID 33613)
-- Name: type type_pk; Type: CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.type
    ADD CONSTRAINT type_pk PRIMARY KEY (id);


--
-- TOC entry 5034 (class 2606 OID 34302)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- TOC entry 5030 (class 2606 OID 34468)
-- Name: nome nome_pessoa_tipo_un; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.nome
    ADD CONSTRAINT nome_pessoa_tipo_un UNIQUE (id_pessoa, tipo);


--
-- TOC entry 5032 (class 2606 OID 34289)
-- Name: nome nome_pkey; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.nome
    ADD CONSTRAINT nome_pkey PRIMARY KEY (id);


--
-- TOC entry 5028 (class 2606 OID 34190)
-- Name: pessoa pessoa_pkey; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (id);


--
-- TOC entry 5036 (class 2606 OID 34404)
-- Name: pessoa_to_pessoa pessoa_to_pessoa_pkey; Type: CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa_to_pessoa
    ADD CONSTRAINT pessoa_to_pessoa_pkey PRIMARY KEY (pessoa_origem, pessoa_destino, tipo);


--
-- TOC entry 4978 (class 2606 OID 33770)
-- Name: capex capex_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.capex
    ADD CONSTRAINT capex_pkey PRIMARY KEY (id);


--
-- TOC entry 4980 (class 2606 OID 33780)
-- Name: distance distance_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.distance
    ADD CONSTRAINT distance_pkey PRIMARY KEY (id);


--
-- TOC entry 4984 (class 2606 OID 33805)
-- Name: feature_attribute feature_attribute_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.feature_attribute
    ADD CONSTRAINT feature_attribute_pkey PRIMARY KEY (id);


--
-- TOC entry 4982 (class 2606 OID 33792)
-- Name: feature feature_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.feature
    ADD CONSTRAINT feature_pkey PRIMARY KEY (id);


--
-- TOC entry 4988 (class 2606 OID 33825)
-- Name: lpu_customer lpu_customer_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_customer
    ADD CONSTRAINT lpu_customer_pkey PRIMARY KEY (id);


--
-- TOC entry 4990 (class 2606 OID 33833)
-- Name: lpu_feature lpu_feature_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_feature
    ADD CONSTRAINT lpu_feature_pkey PRIMARY KEY (id);


--
-- TOC entry 4986 (class 2606 OID 33817)
-- Name: lpu lpu_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu
    ADD CONSTRAINT lpu_pkey PRIMARY KEY (id);


--
-- TOC entry 4992 (class 2606 OID 33841)
-- Name: lpu_plan lpu_plan_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_plan
    ADD CONSTRAINT lpu_plan_pkey PRIMARY KEY (id);


--
-- TOC entry 4994 (class 2606 OID 33849)
-- Name: lpu_point lpu_point_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_point
    ADD CONSTRAINT lpu_point_pkey PRIMARY KEY (id);


--
-- TOC entry 4996 (class 2606 OID 33857)
-- Name: lpu_price lpu_price_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.lpu_price
    ADD CONSTRAINT lpu_price_pkey PRIMARY KEY (id);


--
-- TOC entry 4998 (class 2606 OID 33865)
-- Name: number number_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.number
    ADD CONSTRAINT number_pkey PRIMARY KEY (id);


--
-- TOC entry 5000 (class 2606 OID 33876)
-- Name: number_type number_type_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.number_type
    ADD CONSTRAINT number_type_pkey PRIMARY KEY (id);


--
-- TOC entry 5002 (class 2606 OID 33887)
-- Name: plan plan_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.plan
    ADD CONSTRAINT plan_pkey PRIMARY KEY (id);


--
-- TOC entry 5006 (class 2606 OID 33907)
-- Name: quotation_address quotation_address_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.quotation_address
    ADD CONSTRAINT quotation_address_pkey PRIMARY KEY (id);


--
-- TOC entry 5008 (class 2606 OID 33919)
-- Name: quotation_address_point quotation_address_point_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.quotation_address_point
    ADD CONSTRAINT quotation_address_point_pkey PRIMARY KEY (id);


--
-- TOC entry 5004 (class 2606 OID 33896)
-- Name: quotation quotation_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.quotation
    ADD CONSTRAINT quotation_pkey PRIMARY KEY (id);


--
-- TOC entry 5010 (class 2606 OID 33927)
-- Name: region region_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- TOC entry 5012 (class 2606 OID 33937)
-- Name: service service_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.service
    ADD CONSTRAINT service_pkey PRIMARY KEY (id);


--
-- TOC entry 5014 (class 2606 OID 33945)
-- Name: speed speed_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.speed
    ADD CONSTRAINT speed_pkey PRIMARY KEY (id);


--
-- TOC entry 5016 (class 2606 OID 33954)
-- Name: speed_type speed_type_pkey; Type: CONSTRAINT; Schema: prevendas; Owner: postgres
--

ALTER TABLE ONLY prevendas.speed_type
    ADD CONSTRAINT speed_type_pkey PRIMARY KEY (id);


--
-- TOC entry 5020 (class 2606 OID 34041)
-- Name: modelo_switch modelo_switch_pkey; Type: CONSTRAINT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.modelo_switch
    ADD CONSTRAINT modelo_switch_pkey PRIMARY KEY (id);


--
-- TOC entry 5024 (class 2606 OID 34070)
-- Name: porta porta_pkey; Type: CONSTRAINT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.porta
    ADD CONSTRAINT porta_pkey PRIMARY KEY (id);


--
-- TOC entry 5022 (class 2606 OID 34043)
-- Name: switch switch_pkey; Type: CONSTRAINT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.switch
    ADD CONSTRAINT switch_pkey PRIMARY KEY (id);


--
-- TOC entry 5026 (class 2606 OID 34157)
-- Name: vlan vlan_pkey; Type: CONSTRAINT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.vlan
    ADD CONSTRAINT vlan_pkey PRIMARY KEY (id);


--
-- TOC entry 4759 (class 2606 OID 25189)
-- Name: circuits_cache circuits_cache_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.circuits_cache
    ADD CONSTRAINT circuits_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 4761 (class 2606 OID 25191)
-- Name: clients_cache clientes_cache_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.clients_cache
    ADD CONSTRAINT clientes_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 4763 (class 2606 OID 25193)
-- Name: colaborators_cache colaborators_cache_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.colaborators_cache
    ADD CONSTRAINT colaborators_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 4765 (class 2606 OID 25195)
-- Name: configs configs_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.configs
    ADD CONSTRAINT configs_pkey PRIMARY KEY (name);


--
-- TOC entry 4767 (class 2606 OID 25197)
-- Name: history history_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id);


--
-- TOC entry 4769 (class 2606 OID 25199)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- TOC entry 4771 (class 2606 OID 25203)
-- Name: pops_cache pops_cache_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.pops_cache
    ADD CONSTRAINT pops_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 4773 (class 2606 OID 25205)
-- Name: providers_cache providers_cache_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.providers_cache
    ADD CONSTRAINT providers_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 4776 (class 2606 OID 25207)
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4779 (class 2606 OID 25209)
-- Name: subcases subcases_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.subcases
    ADD CONSTRAINT subcases_pkey PRIMARY KEY (id);


--
-- TOC entry 4781 (class 2606 OID 25211)
-- Name: time_counters time_counters_pkey; Type: CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.time_counters
    ADD CONSTRAINT time_counters_pkey PRIMARY KEY (id);


--
-- TOC entry 4800 (class 1259 OID 33533)
-- Name: fki_chance_chance_type_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_chance_chance_type_id_fkey ON comercial.chance USING btree (service_type);


--
-- TOC entry 4814 (class 1259 OID 33545)
-- Name: fki_chance_closed_chance_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_chance_closed_chance_id_fkey ON comercial.chance_closed USING btree (chance_id);


--
-- TOC entry 4817 (class 1259 OID 33539)
-- Name: fki_chance_contact_chance_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_chance_contact_chance_id_fkey ON comercial.chance_contact USING btree (chance_id);


--
-- TOC entry 4801 (class 1259 OID 33527)
-- Name: fki_chance_followup_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_chance_followup_id_fkey ON comercial.chance USING btree (id_followup);


--
-- TOC entry 4820 (class 1259 OID 33551)
-- Name: fki_chance_inactive_chance_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_chance_inactive_chance_id_fkey ON comercial.chance_inactive USING btree (chance_id);


--
-- TOC entry 4825 (class 1259 OID 33557)
-- Name: fki_chance_indication_chance_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_chance_indication_chance_id_fkey ON comercial.chance_indication USING btree (id_chance);


--
-- TOC entry 4802 (class 1259 OID 33515)
-- Name: fki_chance_prospect_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_chance_prospect_id_fkey ON comercial.chance USING btree (id_prospect);


--
-- TOC entry 4803 (class 1259 OID 33521)
-- Name: fki_chance_service_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_chance_service_id_fkey ON comercial.chance USING btree (id_product);


--
-- TOC entry 4874 (class 1259 OID 33586)
-- Name: fki_lost_action_lost_action_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_lost_action_lost_action_id_fkey ON comercial.lost_action USING btree (parent_id);


--
-- TOC entry 4877 (class 1259 OID 33563)
-- Name: fki_lost_chance_chance_id_pkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_lost_chance_chance_id_pkey ON comercial.lost_chance USING btree (chance_id);


--
-- TOC entry 4878 (class 1259 OID 33580)
-- Name: fki_lost_chance_lost_action_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_lost_chance_lost_action_id_fkey ON comercial.lost_chance USING btree (lost_action_id);


--
-- TOC entry 4879 (class 1259 OID 33574)
-- Name: fki_lost_chance_wallet_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_lost_chance_wallet_id_fkey ON comercial.lost_chance USING btree (wallet);


--
-- TOC entry 4946 (class 1259 OID 33592)
-- Name: fki_viabel_chance_id_fkey; Type: INDEX; Schema: comercial; Owner: postgres
--

CREATE INDEX fki_viabel_chance_id_fkey ON comercial.viable USING btree (chance_id);


--
-- TOC entry 4774 (class 1259 OID 25212)
-- Name: reports_code; Type: INDEX; Schema: troubleticket; Owner: postgres
--

CREATE UNIQUE INDEX reports_code ON troubleticket.reports USING btree (code);


--
-- TOC entry 4777 (class 1259 OID 25213)
-- Name: subcases_code; Type: INDEX; Schema: troubleticket; Owner: postgres
--

CREATE UNIQUE INDEX subcases_code ON troubleticket.subcases USING btree (code);


--
-- TOC entry 5074 (class 2620 OID 25214)
-- Name: history last_update_reports_trigger; Type: TRIGGER; Schema: troubleticket; Owner: postgres
--

CREATE TRIGGER last_update_reports_trigger AFTER INSERT OR UPDATE ON troubleticket.history FOR EACH ROW EXECUTE PROCEDURE troubleticket.last_update_reports();


--
-- TOC entry 5066 (class 2606 OID 33989)
-- Name: menu menu_menu_fkey; Type: FK CONSTRAINT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.menu
    ADD CONSTRAINT menu_menu_fkey FOREIGN KEY (menu_id) REFERENCES autorizacao.menu(id);


--
-- TOC entry 5045 (class 2606 OID 25313)
-- Name: usuario_regra usuario_regra_regras_fkey; Type: FK CONSTRAINT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.usuario_regra
    ADD CONSTRAINT usuario_regra_regras_fkey FOREIGN KEY (id_regras) REFERENCES autorizacao.regra(id);


--
-- TOC entry 5044 (class 2606 OID 25308)
-- Name: usuario_regra usuario_regra_usuarios_fkey; Type: FK CONSTRAINT; Schema: autorizacao; Owner: postgres
--

ALTER TABLE ONLY autorizacao.usuario_regra
    ADD CONSTRAINT usuario_regra_usuarios_fkey FOREIGN KEY (id_usuarios) REFERENCES autorizacao.usuario(id);


--
-- TOC entry 5051 (class 2606 OID 33528)
-- Name: chance chance_chance_type_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance
    ADD CONSTRAINT chance_chance_type_id_fkey FOREIGN KEY (service_type) REFERENCES comercial.chance_type(id);


--
-- TOC entry 5052 (class 2606 OID 33540)
-- Name: chance_closed chance_closed_chance_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_closed
    ADD CONSTRAINT chance_closed_chance_id_fkey FOREIGN KEY (chance_id) REFERENCES comercial.chance(id);


--
-- TOC entry 5053 (class 2606 OID 33534)
-- Name: chance_contact chance_contact_chance_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_contact
    ADD CONSTRAINT chance_contact_chance_id_fkey FOREIGN KEY (chance_id) REFERENCES comercial.chance(id);


--
-- TOC entry 5050 (class 2606 OID 33522)
-- Name: chance chance_followup_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance
    ADD CONSTRAINT chance_followup_id_fkey FOREIGN KEY (id_followup) REFERENCES comercial.followup(id);


--
-- TOC entry 5054 (class 2606 OID 33546)
-- Name: chance_inactive chance_inactive_chance_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_inactive
    ADD CONSTRAINT chance_inactive_chance_id_fkey FOREIGN KEY (chance_id) REFERENCES comercial.chance(id);


--
-- TOC entry 5055 (class 2606 OID 33552)
-- Name: chance_indication chance_indication_chance_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance_indication
    ADD CONSTRAINT chance_indication_chance_id_fkey FOREIGN KEY (id_chance) REFERENCES comercial.chance(id);


--
-- TOC entry 5048 (class 2606 OID 33510)
-- Name: chance chance_prospect_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance
    ADD CONSTRAINT chance_prospect_id_fkey FOREIGN KEY (id_prospect) REFERENCES comercial.prospect(id);


--
-- TOC entry 5049 (class 2606 OID 33516)
-- Name: chance chance_service_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.chance
    ADD CONSTRAINT chance_service_id_fkey FOREIGN KEY (id_product) REFERENCES comercial.service(id);


--
-- TOC entry 5056 (class 2606 OID 33581)
-- Name: lost_action lost_action_lost_action_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.lost_action
    ADD CONSTRAINT lost_action_lost_action_id_fkey FOREIGN KEY (parent_id) REFERENCES comercial.lost_action(id);


--
-- TOC entry 5057 (class 2606 OID 33558)
-- Name: lost_chance lost_chance_chance_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.lost_chance
    ADD CONSTRAINT lost_chance_chance_id_fkey FOREIGN KEY (chance_id) REFERENCES comercial.chance(id);


--
-- TOC entry 5059 (class 2606 OID 33575)
-- Name: lost_chance lost_chance_lost_action_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.lost_chance
    ADD CONSTRAINT lost_chance_lost_action_id_fkey FOREIGN KEY (lost_action_id) REFERENCES comercial.lost_action(id);


--
-- TOC entry 5058 (class 2606 OID 33569)
-- Name: lost_chance lost_chance_wallet_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.lost_chance
    ADD CONSTRAINT lost_chance_wallet_id_fkey FOREIGN KEY (wallet) REFERENCES comercial.wallet(id);


--
-- TOC entry 5046 (class 2606 OID 28712)
-- Name: prospect prospect_tag_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.prospect
    ADD CONSTRAINT prospect_tag_id_fkey FOREIGN KEY (id_tag) REFERENCES comercial.tag(id);


--
-- TOC entry 5047 (class 2606 OID 28717)
-- Name: prospect prospect_wallet_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.prospect
    ADD CONSTRAINT prospect_wallet_id_fkey FOREIGN KEY (id_wallet) REFERENCES comercial.wallet(id);


--
-- TOC entry 5060 (class 2606 OID 33587)
-- Name: viable viabel_chance_id_fkey; Type: FK CONSTRAINT; Schema: comercial; Owner: postgres
--

ALTER TABLE ONLY comercial.viable
    ADD CONSTRAINT viabel_chance_id_fkey FOREIGN KEY (chance_id) REFERENCES comercial.chance(id);


--
-- TOC entry 5061 (class 2606 OID 33625)
-- Name: kmz kmz_kmz_file_id_kmz_file_id_fkey; Type: FK CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.kmz
    ADD CONSTRAINT kmz_kmz_file_id_kmz_file_id_fkey FOREIGN KEY (kmz_file_id) REFERENCES engenharia.kmz_file(id);


--
-- TOC entry 5062 (class 2606 OID 33630)
-- Name: kmz kmz_type_id_type_id; Type: FK CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.kmz
    ADD CONSTRAINT kmz_type_id_type_id FOREIGN KEY (type_id) REFERENCES engenharia.type(id);


--
-- TOC entry 5064 (class 2606 OID 33660)
-- Name: location location_location_id_location_id_fk; Type: FK CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.location
    ADD CONSTRAINT location_location_id_location_id_fk FOREIGN KEY (location_id) REFERENCES engenharia.location(id);


--
-- TOC entry 5065 (class 2606 OID 33665)
-- Name: location location_point_id_point_id_fk; Type: FK CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.location
    ADD CONSTRAINT location_point_id_point_id_fk FOREIGN KEY (point_id) REFERENCES engenharia.point(id);


--
-- TOC entry 5063 (class 2606 OID 33647)
-- Name: point point_type_id_type_id_fk; Type: FK CONSTRAINT; Schema: engenharia; Owner: postgres
--

ALTER TABLE ONLY engenharia.point
    ADD CONSTRAINT point_type_id_type_id_fk FOREIGN KEY (type_id) REFERENCES engenharia.type(id);


--
-- TOC entry 5071 (class 2606 OID 34314)
-- Name: endereco endereco_pessoa_fkey; Type: FK CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.endereco
    ADD CONSTRAINT endereco_pessoa_fkey FOREIGN KEY (id_pessoa) REFERENCES pessoas.pessoa(id);


--
-- TOC entry 5070 (class 2606 OID 34319)
-- Name: nome nome_pessoa_fkey; Type: FK CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.nome
    ADD CONSTRAINT nome_pessoa_fkey FOREIGN KEY (id_pessoa) REFERENCES pessoas.pessoa(id);


--
-- TOC entry 5073 (class 2606 OID 34410)
-- Name: pessoa_to_pessoa pessoa_to_pessoa_pessoa_destino_fkey; Type: FK CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa_to_pessoa
    ADD CONSTRAINT pessoa_to_pessoa_pessoa_destino_fkey FOREIGN KEY (pessoa_destino) REFERENCES pessoas.pessoa(id);


--
-- TOC entry 5072 (class 2606 OID 34405)
-- Name: pessoa_to_pessoa pessoa_to_pessoa_pessoa_origem_fkey; Type: FK CONSTRAINT; Schema: pessoas; Owner: postgres
--

ALTER TABLE ONLY pessoas.pessoa_to_pessoa
    ADD CONSTRAINT pessoa_to_pessoa_pessoa_origem_fkey FOREIGN KEY (pessoa_origem) REFERENCES pessoas.pessoa(id);


--
-- TOC entry 5068 (class 2606 OID 34071)
-- Name: porta porta_switch_id_fkey; Type: FK CONSTRAINT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.porta
    ADD CONSTRAINT porta_switch_id_fkey FOREIGN KEY (switch_id) REFERENCES redes.switch(id);


--
-- TOC entry 5067 (class 2606 OID 34044)
-- Name: switch switch_modelo_switch_id_fkey; Type: FK CONSTRAINT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.switch
    ADD CONSTRAINT switch_modelo_switch_id_fkey FOREIGN KEY (modelo_switch_id) REFERENCES redes.modelo_switch(id);


--
-- TOC entry 5069 (class 2606 OID 34158)
-- Name: vlan vlan_switch_id_fkey; Type: FK CONSTRAINT; Schema: redes; Owner: postgres
--

ALTER TABLE ONLY redes.vlan
    ADD CONSTRAINT vlan_switch_id_fkey FOREIGN KEY (switch_id) REFERENCES redes.switch(id);


--
-- TOC entry 5037 (class 2606 OID 25215)
-- Name: history history_report_id; Type: FK CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.history
    ADD CONSTRAINT history_report_id FOREIGN KEY (report_id) REFERENCES troubleticket.reports(id);


--
-- TOC entry 5038 (class 2606 OID 25220)
-- Name: history history_subcase_id; Type: FK CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.history
    ADD CONSTRAINT history_subcase_id FOREIGN KEY (subcase_id) REFERENCES troubleticket.subcases(id);


--
-- TOC entry 5039 (class 2606 OID 25225)
-- Name: messages messages_report_id; Type: FK CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.messages
    ADD CONSTRAINT messages_report_id FOREIGN KEY (report_id) REFERENCES troubleticket.reports(id);


--
-- TOC entry 5040 (class 2606 OID 25230)
-- Name: reports reports_parent_id; Type: FK CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.reports
    ADD CONSTRAINT reports_parent_id FOREIGN KEY (parent_id) REFERENCES troubleticket.reports(id);


--
-- TOC entry 5041 (class 2606 OID 25235)
-- Name: subcases subcases_report_id; Type: FK CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.subcases
    ADD CONSTRAINT subcases_report_id FOREIGN KEY (report_id) REFERENCES troubleticket.reports(id);


--
-- TOC entry 5042 (class 2606 OID 25240)
-- Name: time_counters time_counters_report_id; Type: FK CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.time_counters
    ADD CONSTRAINT time_counters_report_id FOREIGN KEY (report_id) REFERENCES troubleticket.reports(id);


--
-- TOC entry 5043 (class 2606 OID 25245)
-- Name: time_counters time_counters_subcase_id; Type: FK CONSTRAINT; Schema: troubleticket; Owner: postgres
--

ALTER TABLE ONLY troubleticket.time_counters
    ADD CONSTRAINT time_counters_subcase_id FOREIGN KEY (subcase_id) REFERENCES troubleticket.subcases(id);


-- Completed on 2018-04-13 16:03:45 -03

--
-- PostgreSQL database dump complete
--

