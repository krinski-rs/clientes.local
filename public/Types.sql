DROP TYPE IF EXISTS vogel.pessoas.tipo_pessoa;
CREATE TYPE vogel.pessoas.tipo_pessoa AS ENUM ('JURÍDICA', 'FÍSICA', 'USUÁRIO');
DROP TYPE IF EXISTS vogel.pessoas.nacionalidade_pessoa;
CREATE TYPE vogel.pessoas.nacionalidade_pessoa AS ENUM ('BRASILEIRA', 'ESTRANGEIRA');
DROP TYPE IF EXISTS vogel.pessoas.tipo_nome_pessoa;
CREATE TYPE vogel.pessoas.tipo_nome_pessoa AS ENUM ('RAZÃO SOCIAL', 'NOME FANTASIA', 'NOME', 'USERNAME', 'NICKNAME');
DROP TYPE IF EXISTS vogel.pessoas.tipo_endereco_pessoa;
CREATE TYPE vogel.pessoas.tipo_endereco_pessoa AS ENUM ('COMERCIAL', 'RESIDENCIAL', 'COBRANÇA');
DROP TYPE IF EXISTS vogel.pessoas.tipo_relacionamento_pessoa;
CREATE TYPE vogel.pessoas.tipo_relacionamento_pessoa AS ENUM ('AMIGO','PARENTE','CONJUGE','FILHO','SÓCIO','COLABORADOR','CONTATO TÉCNICO','CONTATATO FINANCEIRO','CONTATO EMERGENCIAL','CONTATO ADMINISTRATIVO','SECRETÁRIO','MATRIZ','FILIAL','FRANQUIA','TERCEIRIZADA','PAI', 'MÃE', 'IRMÃO');
DROP TYPE IF EXISTS vogel.pessoas.tipo_contato_pessoa;
CREATE TYPE vogel.pessoas.tipo_contato_pessoa AS ENUM ('CONTATO TÉCNICO','CONTATATO FINANCEIRO','CONTATO EMERGENCIAL','CONTATO ADMINISTRATIVO','PESSOAL');

DROP TYPE IF EXISTS vogel.pessoas.tipo_contato;
CREATE TYPE vogel.pessoas.tipo_contato AS ENUM ('E-MAIL','CELULAR','TELEFONE FIXO','SKYPE');

