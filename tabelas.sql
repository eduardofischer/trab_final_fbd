-- ESTE ARQUIVO FOI CONFECCIONADO PARA POSTGRESQL

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

create table if not exists Usuarios (
	nome_de_usuario varchar(100) PRIMARY KEY,
	email varchar(100) UNIQUE NOT NULL,
	nacionalidade varchar(3) NOT NULL,
	hash_senha varchar(35) NOT NULL,
	insignia varchar(32),
	avatar varchar(32),
	glicko_corrida_de_problemas smallint default 400,
	glicko_batalha_de_problemas smallint default 400,
	glicko_bullet smallint default 400,
	glicko_blitz smallint default 400,
	glicko_rapid smallint default 400
);

-- A tabela Formatos_Partida contém as combinações possíveis de modalidade x tempo inicial x tempo adicional por jogada
create type modalidade as enum ('bullet',  'blitz',  'rapid');
create table if not exists Formatos_Partida (
	id_formato uuid primary key,
	modalidade modalidade not null, 
	tempo_inicial interval not null,
	tempo_adc_jogada interval not null
);

create type resultados_xadrez as enum ( 'brancas',  'pretas',  'empate');
create table if not exists Partidas (
	id_partida uuid primary key,
	resultado resultados_xadrez not null,
	inicio timestamp not null,
	jogador_brancas varchar(100) not null references Usuarios,
	jogador_pretas varchar(100) not null references Usuarios,
	id_formato uuid references Formatos_Partida,
	mudanca_glicko_jogador_brancas smallint not null,
	mudanca_glicko_jogador_pretas smallint not null
);

create type cores as enum('brancas', 'pretas');
create type jogada as (
    cor cores,
    movimento varchar(8),
	data_hora timestamp
);

create table if not exists Jogadas (
	id_partida uuid not null references Partidas,
	jogada jogada not null
);

create table if not exists Comentarios (
	conteudo varchar(250) not null,
	autor varchar(100) not null references Usuarios,
	data_hora timestamp not null,
	id_partida uuid not null references Partidas
);

create table if not exists Problemas (
	id_problema uuid primary key,
	dificuldade smallint not null,
	tema varchar(250),
	taxa_acerto decimal(5,4) check (1 >= taxa_acerto and taxa_acerto >= 0)
);

create table if not exists Solucoes_Problemas (
	id_problema uuid not null references problemas,
	ordem smallint not null,
	jogada jogada not null
);

create table if not exists Dicas (
	id_problema uuid not null references Problemas,
	texto varchar(500) not null,
	primary key(id_problema, texto)
);

create type formatos_corrida as enum('3 minutes', '5 minutes', 'survival');
create table if not exists Corridas_de_Problemas (
	id_corrida uuid primary key,
	usuario varchar(100) not null references Usuarios,
	score smallint not null,
	modalidade formatos_corrida not null,
	mudanca_glicko smallint not null
);

create table if not exists Batalhas_de_Problemas (
	id_batalha uuid primary key,
	usuario1 varchar(100) not null references Usuarios,
	usuario2 varchar(100) not null references Usuarios,
	resultado varchar(100) not null references Usuarios,
	pontos_usuario1 smallint not null,
	pontos_usuario2 smallint not null,
	mudanca_glicko_usuario1 smallint not null,
	mudanca_glicko_usuario2 smallint not null,
	-- Verifica se o vencedor é um dos usuários
	check (resultado = usuario1 or resultado = usuario2),
	-- Verifica se o usuário vencedor tem mais pontos que o usuário perdedor
	check ((usuario1 = resultado and pontos_usuario1 > pontos_usuario2) or (usuario2 = resultado and pontos_usuario2 > pontos_usuario1))
);

create table if not exists Problemas_Batalha (
	id_batalha uuid not null references Batalhas_de_Problemas,
	id_problema uuid not null references Problemas
);

create table if not exists Problemas_Corrida (
	id_corrida uuid not null references Corridas_de_Problemas,
	id_problema uuid not null references Problemas
);

create table if not exists Clubes (
	nome varchar(200) primary key,
	foto char(32),
	descricao varchar(500)
);

create table if not exists Topicos (
	id_topico uuid unique not null,
	clube varchar(200) not null references Clubes,
	titulo varchar(64) not null,
	autor varchar(100) not null references Usuarios(nome_de_usuario),
	primary key(clube, titulo)
);

create table if not exists Mensagens (
	data_mensagem timestamp not null,
	conteudo varchar(255) not null,
	id_topico uuid not null references Topicos(id_topico),
	autor varchar(100) not null references Usuarios(nome_de_usuario)
);

create table if not exists Torneios (
	id_torneio uuid not null unique,
	nome_clube varchar(200) not null references Clubes,
	titulo varchar(65) not null,
	descricao varchar(500) not null,
	inicio timestamp not null,
	fim timestamp not null,
	primary key(nome_clube, titulo)
);

create table if not exists Filiacao_Clube (
	nome_de_usuario varchar(100) not null references Usuarios,
	administrador boolean not null,
	nome_clube varchar(200) not null references Clubes
);

create table if not exists Participacao_Torneio (
	nome_de_usuario varchar(100) not null references Usuarios,
	id_torneio uuid not null references Torneios(id_torneio)
);

-- CORRECAO E2
create table if not exists Partida_Torneio (
	id_partida uuid not null references Partidas(id_partida),
	id_torneio uuid not null references Torneios(id_torneio)
);

create table if not exists Amizades (
	nome_usuario_1 varchar(100) not null references Usuarios,
	nome_usuario_2 varchar(100) not null references Usuarios
);
