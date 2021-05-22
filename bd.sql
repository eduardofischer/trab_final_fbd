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
	primary key(clube, titulo)
);

create table if not exists Mensagens (
	data_mensagem timestamp not null,
	conteudo varchar(255) not null,
	id_topico uuid not null references Topicos(id_topico)
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

-- Usuários
insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha)
values ('magnus',  'magzzy@gmail.com', 'NO', '234fdsa86t2');

insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha)
values ('caruana',  'fabi@outlook.com', 'ITA', '2dcfdsa86t3');

insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha)
values ('bobbyfischer', 'fischer@outlook.com', 'USA', '234fdwd86t3');

insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha)
values ('hikaru', 'hikaru@outlook.com', 'USA', '786fdwdd86t3');

-- Formatos Partidas
insert into Formatos_Partida values ('32e64910-c824-4060-8054-0c80ccc2d072', 'rapid', '10 minutes', '0 seconds');
insert into Formatos_Partida values ('c9309e01-832b-4eee-a6d5-9642327537f3', 'bullet', '30 seconds', '0 seconds');
insert into Formatos_Partida values ('9b82a31d-d546-4417-bbeb-eacd100f6177', 'blitz', '3 minutes', '2 seconds');

-- Partidas
insert into Partidas values ('d7a23240-d749-4aca-94ff-6d44e9fd0a48', 'brancas', '2021-03-28T20:25:15+00:00', 'magnus', 'caruana', '32e64910-c824-4060-8054-0c80ccc2d072', 100, 100);
insert into Partidas values ('473448d3-efd3-43c9-8708-e0a38c3f6601', 'pretas', '2021-03-28T20:25:15+00:00', 'caruana', 'magnus', 'c9309e01-832b-4eee-a6d5-9642327537f3', 100, 100);
insert into Partidas values ('fc32a022-69c4-41a6-94a7-3cf2f6ec7f68', 'empate', '2021-03-28T20:25:15+00:00', 'magnus', 'bobbyfischer', '9b82a31d-d546-4417-bbeb-eacd100f6177', 100, 100);

-- Jogadas
insert into Jogadas values ('d7a23240-d749-4aca-94ff-6d44e9fd0a48', row('brancas', 'e4', '2021-03-28T20:43:06+00:00'));
insert into Jogadas values ('d7a23240-d749-4aca-94ff-6d44e9fd0a48', row('pretas', 'e5', '2021-03-28T20:44:34+00:00'));
insert into Jogadas values ('d7a23240-d749-4aca-94ff-6d44e9fd0a48', row('brancas', 'd4', '2021-03-28T20:46:54+00:00'));

-- Comentarios
insert into Comentarios values ('A imortal de Caruana!', 'magnus', NOW(), 'd7a23240-d749-4aca-94ff-6d44e9fd0a48');
insert into Comentarios values ('A imortal de Magnus!', 'caruana', NOW(), '473448d3-efd3-43c9-8708-e0a38c3f6601');
insert into Comentarios values ('A imortal de Fischer!', 'caruana', NOW(), 'fc32a022-69c4-41a6-94a7-3cf2f6ec7f68');

-- Problemas
insert into Problemas values ('32babc93-3560-421a-9dde-d37b0f2dd49b', 1900, 'cheque em 4', 0.527);
insert into Problemas values ('f24d950e-28ee-4c27-862a-da18298aa78c', 2700, 'cheque em 10', 0.01);
insert into Problemas values ('591a1bfe-6b2a-4eec-ae73-4832dd8dfed3', 500, 'en-passant', 0.6);

-- Solucoes_Problemas
insert into Solucoes_Problemas values ('f24d950e-28ee-4c27-862a-da18298aa78c', 1, row('brancas', 'e4', '2021-03-28T20:43:06+00:00'));
insert into Solucoes_Problemas values ('f24d950e-28ee-4c27-862a-da18298aa78c', 2, row('pretas', 'e5', '2021-03-28T20:44:34+00:00'));
insert into Solucoes_Problemas values ('f24d950e-28ee-4c27-862a-da18298aa78c', 3, row('brancas', 'd4', '2021-03-28T20:46:54+00:00'));

-- Dicas
insert into Dicas values ('f24d950e-28ee-4c27-862a-da18298aa78c', 'Não se esqueça das oportunidades de cheque em descoberto.');
insert into Dicas values ('f24d950e-28ee-4c27-862a-da18298aa78c', 'O cavalo é a única peça capaz de passar por cima das outras.');
insert into Dicas values ('f24d950e-28ee-4c27-862a-da18298aa78c', 'Tente controlar o centro.');

-- Corridas de Problemas
insert into Corridas_de_Problemas values ('ebc73e57-5dd5-4aa0-95be-26967422ee6f', 'magnus', 34, 'survival', 20);
insert into Corridas_de_Problemas values ('e28bbb28-981a-4217-a674-f6e9980a1dbc', 'caruana', 15, '3 minutes', 20);
insert into Corridas_de_Problemas values ('e84c1ed5-dcdd-4e2a-bb86-005188298cc4', 'bobbyfischer', 27, '5 minutes', 20);

-- Problemas Corrida
insert into Problemas_Corrida values ('ebc73e57-5dd5-4aa0-95be-26967422ee6f', '32babc93-3560-421a-9dde-d37b0f2dd49b');
insert into Problemas_Corrida values ('ebc73e57-5dd5-4aa0-95be-26967422ee6f', 'f24d950e-28ee-4c27-862a-da18298aa78c');
insert into Problemas_Corrida values ('ebc73e57-5dd5-4aa0-95be-26967422ee6f', '591a1bfe-6b2a-4eec-ae73-4832dd8dfed3');

-- Batalhas de Problemas
insert into Batalhas_de_Problemas values ('8d0389a6-52f4-49fc-9c44-06f9a21699d8', 'magnus', 'caruana', 'caruana', 20, 25, 20, 20);
insert into Batalhas_de_Problemas values ('e88dc9cb-2dd3-4589-8d59-5742fb877cdb', 'magnus', 'bobbyfischer', 'magnus', 25, 20, 20, 20);
insert into Batalhas_de_Problemas values ('1f47bfe4-c72a-4534-92ff-ad0a74e843a2', 'magnus', 'bobbyfischer', 'bobbyfischer', 20, 25, 20, 20);

-- Problemas Batalha
insert into Problemas_Batalha values ('8d0389a6-52f4-49fc-9c44-06f9a21699d8', '32babc93-3560-421a-9dde-d37b0f2dd49b');
insert into Problemas_Batalha values ('8d0389a6-52f4-49fc-9c44-06f9a21699d8', 'f24d950e-28ee-4c27-862a-da18298aa78c');
insert into Problemas_Batalha values ('8d0389a6-52f4-49fc-9c44-06f9a21699d8', '591a1bfe-6b2a-4eec-ae73-4832dd8dfed3');

-- Clubes
insert into Clubes values ('Enxadristas Angolanos', 'angola_flag.png', 'Clube voltado a promoção do Xadrez na Angola');
insert into Clubes values ('Enxadristas Otakus', 'akatsuki_flag.png', 'Anime e Xadrez duas paixões');
insert into Clubes values ('FIDE GMs', 'FIDE.png', 'A mais alta elite do xadrez mundial');

-- Topicos
insert into Topicos values ('a2d195ef-c037-4941-bf17-e5a9d80c22b9', 'FIDE GMs', 'O que é roque?');
insert into Topicos values ('2e44417f-ccdf-4ae4-802c-187ed648073a', 'FIDE GMs', 'O que é en passant?');
insert into Topicos values ('cbd26e4d-f643-4b44-b511-1b1c33f3427a', 'Enxadristas Otakus', 'Sciciliana vs Gambito do Elefante');

-- Mensagens
insert into Mensagens values (NOW(), 'Prefira ativar os peões do centro aos das laterais', 'cbd26e4d-f643-4b44-b511-1b1c33f3427a');
insert into Mensagens values (NOW(), 'O rei move-se duas casas para esquerda ou direita, e a torre move-se sobre o rei!', 'a2d195ef-c037-4941-bf17-e5a9d80c22b9');
insert into Mensagens values (NOW(), 'É quando um peão pode capturar outro que está ao seu lado.', '2e44417f-ccdf-4ae4-802c-187ed648073a');

-- Torneios
insert into Torneios values ('b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2', 'FIDE GMs', 'Torneio Mundial de Xadrez', 'O maior torneio de xadrez do planeta.', '2021-03-28T21:06:10+00:00', '2021-04-28T21:06:10+00:00');
insert into Torneios values ('9a9817c7-d987-4a65-a322-9790f0ced469', 'Enxadristas Angolanos', 'Torneio Felicidade', 'Venha competir e ser feliz.', '2021-03-28T21:06:10+00:00', '2021-04-28T21:06:10+00:00');
insert into Torneios values ('0cfa37aa-9711-4e1c-885e-b7a481e68938', 'Enxadristas Otakus', 'Torneio Attack on Titan', 'Duelo entre os titãs do xadrez.', '2021-03-28T21:06:10+00:00', '2021-04-28T21:06:10+00:00');

-- Filiação Clube
insert into Filiacao_Clube values ('magnus', false, 'FIDE GMs');
insert into Filiacao_Clube values ('magnus', true, 'Enxadristas Otakus');
insert into Filiacao_Clube values ('caruana', false, 'Enxadristas Otakus');
insert into Filiacao_Clube values ('bobbyfischer', true, 'FIDE GMs');
insert into Filiacao_Clube values ('bobbyfischer', false, 'Enxadristas Otakus');
insert into Filiacao_Clube values ('bobbyfischer', false, 'Enxadristas Angolanos');

-- Participação Torneio
insert into Participacao_Torneio values ('magnus', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');
insert into Participacao_Torneio values ('caruana', '0cfa37aa-9711-4e1c-885e-b7a481e68938');
insert into Participacao_Torneio values ('bobbyfischer', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');

-- CORRECAO E2
-- TODO: PARTIDAS TORNEIO

insert into Amizades values ('magnus', 'bobbyfischer');
insert into Amizades values ('magnus', 'caruana');
insert into Amizades values ('hikaru', 'caruana');