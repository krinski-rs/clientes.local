CREATE SCHEMA pessoas;

CREATE TYPE pessoas.nacionalidade_pessoa AS ENUM (
    'BRASILEIRA',
    'ESTRANGEIRA'
);

CREATE TYPE pessoas.tipo_contato AS ENUM (
    'E-MAIL',
    'CELULAR',
    'TELEFONE FIXO',
    'SKYPE'
);

CREATE TYPE pessoas.tipo_contato_pessoa AS ENUM (
    'CONTATO TÉCNICO',
    'CONTATATO FINANCEIRO',
    'CONTATO EMERGENCIAL',
    'CONTATO ADMINISTRATIVO',
    'PESSOAL'
);

CREATE TYPE pessoas.tipo_endereco_pessoa AS ENUM (
    'COMERCIAL',
    'RESIDENCIAL',
    'COBRANÇA'
);

CREATE TYPE pessoas.tipo_nome_pessoa AS ENUM (
    'RAZÃO SOCIAL',
    'NOME FANTASIA',
    'NOME',
    'USERNAME',
    'NICKNAME'
);

CREATE TYPE pessoas.tipo_pessoa AS ENUM (
    'JURÍDICA',
    'FÍSICA',
    'USUÁRIO'
);

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

CREATE TABLE pessoas.pessoa (
    id serial NOT NULL,
    tipo pessoas.tipo_pessoa NOT NULL,
    nacionalidade pessoas.nacionalidade_pessoa NOT NULL,
    data_aniversario timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    data_cadastro timestamp(0) without time zone DEFAULT now() NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    CONSTRAINT pessoa_pkey PRIMARY KEY (id)
);

CREATE TABLE pessoas.endereco (
    id serial NOT NULL,
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
    complemento text,
    CONSTRAINT endereco_pkey PRIMARY KEY (id),
    CONSTRAINT endereco_id_pessoa_fkey FOREIGN KEY (id_pessoa)
        REFERENCES pessoas.pessoa (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE pessoas.documento
(
    id serial NOT NULL,
    id_pessoa integer NOT NULL,
    tipo pessoas.tipo_documento NOT NULL,
    data_cadastro timestamp(0) without time zone NOT NULL,
    valor character varying(255) NOT NULL,
    CONSTRAINT documento_pkey PRIMARY KEY (id),
    CONSTRAINT documento_id_pessoa FOREIGN KEY (id_pessoa)
        REFERENCES pessoas.pessoa (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE pessoas.nome (
    id serial NOT NULL,
    id_pessoa integer NOT NULL,
    tipo pessoas.tipo_nome_pessoa NOT NULL,
    nome character varying(255) NOT NULL,
    CONSTRAINT nome_pkey PRIMARY KEY (id),
    CONSTRAINT nome_id_pessoa_fkey FOREIGN KEY (id_pessoa)
        REFERENCES pessoas.pessoa (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE pessoas.pessoa_to_pessoa (
    id_pessoa integer NOT NULL,
    id_realacao integer NOT NULL,
    tipo pessoas.tipo_relacionamento_pessoa NOT NULL,
    CONSTRAINT pessoa_to_pessoa_pkey PRIMARY KEY (id_pessoa, id_realacao),
    CONSTRAINT pessoa_to_pessoa_id_pessoa_fkey FOREIGN KEY (id_pessoa)
        REFERENCES pessoas.pessoa (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT pessoa_to_pessoa_id_pessoa_realacao_fkey FOREIGN KEY (id_realacao)
        REFERENCES pessoas.pessoa (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

