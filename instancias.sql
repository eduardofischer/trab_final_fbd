-- Usuários
insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha, glicko_rapid)
values ('magnus',  'magzzy@gmail.com', 'NO', '234fdsa86t2', 2780);

insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha, glicko_rapid)
values ('caruana',  'fabi@outlook.com', 'ITA', '2dcfdsa86t3', 2690);

insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha, glicko_rapid)
values ('bobbyfischer', 'fischer@outlook.com', 'USA', '234fdwd86t3', 2505);

insert into Usuarios (nome_de_usuario, email, nacionalidade, hash_senha, glicko_rapid)
values ('hikaru', 'hikaru@outlook.com', 'USA', '786fdwdd86t3', 2590);

-- Formatos Partidas
insert into Formatos_Partida values ('32e64910-c824-4060-8054-0c80ccc2d072', 'rapid', '10 minutes', '0 seconds');
insert into Formatos_Partida values ('c9309e01-832b-4eee-a6d5-9642327537f3', 'bullet', '30 seconds', '0 seconds');
insert into Formatos_Partida values ('9b82a31d-d546-4417-bbeb-eacd100f6177', 'blitz', '3 minutes', '2 seconds');

-- Partidas
insert into Partidas values ('d7a23240-d749-4aca-94ff-6d44e9fd0a48', 'pretas', '2021-03-28T20:25:15+00:00', 'magnus', 'caruana', '32e64910-c824-4060-8054-0c80ccc2d072', 100, 100);
insert into Partidas values ('d7a23240-d749-4aca-94ff-6d44e9fd0149', 'brancas', '2021-03-28T20:25:15+00:00', 'magnus', 'caruana', '32e64910-c824-4060-8054-0c80ccc2d072', 100, 100);
insert into Partidas values ('473448d3-efd3-43c9-8708-e0a38c3f6601', 'brancas', '2021-03-28T20:25:15+00:00', 'caruana', 'magnus', 'c9309e01-832b-4eee-a6d5-9642327537f3', 100, 100);
insert into Partidas values ('fc32a022-69c4-41a6-94a7-3cf2f6ec7f68', 'empate', '2021-03-28T20:25:15+00:00', 'magnus', 'bobbyfischer', '9b82a31d-d546-4417-bbeb-eacd100f6177', 100, 100);
insert into Partidas values ('abc448d3-efd3-43c9-8708-e0a38c3f6601', 'pretas', '2021-03-28T20:25:15+00:00', 'caruana', 'bobbyfischer', 'c9309e01-832b-4eee-a6d5-9642327537f3', 100, 100);
insert into Partidas values ('abc448d3-efd3-43c9-8708-e0a38c3f6699', 'pretas', '2021-03-28T20:25:15+00:00', 'magnus', 'bobbyfischer', 'c9309e01-832b-4eee-a6d5-9642327537f3', 100, 100);
insert into Partidas values ('d8b23240-d749-4aca-94ff-6d44e9fd0a48', 'brancas', '2021-03-28T20:25:15+00:00', 'magnus', 'caruana', '32e64910-c824-4060-8054-0c80ccc2d072', 100, 100);
insert into Partidas values ('abc448d3-efd3-43c9-8708-e0a38c3f6688', 'brancas', '2021-03-28T20:25:15+00:00', 'bobbyfischer', 'caruana', 'c9309e01-832b-4eee-a6d5-9642327537f3', 100, 100);
    
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
insert into Problemas_Corrida values ('e84c1ed5-dcdd-4e2a-bb86-005188298cc4', '32babc93-3560-421a-9dde-d37b0f2dd49b');
insert into Problemas_Corrida values ('e84c1ed5-dcdd-4e2a-bb86-005188298cc4', 'f24d950e-28ee-4c27-862a-da18298aa78c');
insert into Problemas_Corrida values ('e28bbb28-981a-4217-a674-f6e9980a1dbc', '591a1bfe-6b2a-4eec-ae73-4832dd8dfed3');

-- Batalhas de Problemas
insert into Batalhas_de_Problemas values ('8d0389a6-52f4-49fc-9c44-06f9a21699d8', 'magnus', 'caruana', 'caruana', 20, 25, 20, 20);
insert into Batalhas_de_Problemas values ('e88dc9cb-2dd3-4589-8d59-5742fb877cdb', 'magnus', 'bobbyfischer', 'magnus', 25, 20, 20, 20);
insert into Batalhas_de_Problemas values ('1f47bfe4-c72a-4534-92ff-ad0a74e843a2', 'magnus', 'bobbyfischer', 'bobbyfischer', 20, 25, 20, 20);

-- Problemas Batalha
insert into Problemas_Batalha values ('8d0389a6-52f4-49fc-9c44-06f9a21699d8', '32babc93-3560-421a-9dde-d37b0f2dd49b');
insert into Problemas_Batalha values ('8d0389a6-52f4-49fc-9c44-06f9a21699d8', 'f24d950e-28ee-4c27-862a-da18298aa78c');
insert into Problemas_Batalha values ('8d0389a6-52f4-49fc-9c44-06f9a21699d8', '591a1bfe-6b2a-4eec-ae73-4832dd8dfed3');
insert into Problemas_Batalha values ('e88dc9cb-2dd3-4589-8d59-5742fb877cdb', '32babc93-3560-421a-9dde-d37b0f2dd49b');
insert into Problemas_Batalha values ('e88dc9cb-2dd3-4589-8d59-5742fb877cdb', 'f24d950e-28ee-4c27-862a-da18298aa78c');
insert into Problemas_Batalha values ('1f47bfe4-c72a-4534-92ff-ad0a74e843a2', '591a1bfe-6b2a-4eec-ae73-4832dd8dfed3');

-- Clubes
insert into Clubes values ('Enxadristas Angolanos', 'angola_flag.png', 'Clube voltado a promoção do Xadrez na Angola');
insert into Clubes values ('Enxadristas Otakus', 'akatsuki_flag.png', 'Anime e Xadrez duas paixões');
insert into Clubes values ('FIDE GMs', 'FIDE.png', 'A mais alta elite do xadrez mundial');

-- Topicos
insert into Topicos values ('a2d195ef-c037-4941-bf17-e5a9d80c22b9', 'FIDE GMs', 'O que é roque?', 'magnus');
insert into Topicos values ('2e44417f-ccdf-4ae4-802c-187ed648073a', 'FIDE GMs', 'O que é en passant?', 'caruana');
insert into Topicos values ('cbd26e4d-f643-4b44-b511-1b1c33f3427a', 'Enxadristas Otakus', 'Sciciliana vs Gambito do Elefante', 'bobbyfischer');

-- Mensagens
insert into Mensagens values (NOW(), 'Prefira ativar os peões do centro aos das laterais', 'cbd26e4d-f643-4b44-b511-1b1c33f3427a', 'magnus');
insert into Mensagens values (NOW(), 'O rei move-se duas casas para esquerda ou direita, e a torre move-se sobre o rei!', 'a2d195ef-c037-4941-bf17-e5a9d80c22b9', 'caruana');
insert into Mensagens values (NOW(), 'É quando um peão pode capturar outro que está ao seu lado.', '2e44417f-ccdf-4ae4-802c-187ed648073a', 'bobbyfischer');

-- Torneios
insert into Torneios values ('b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2', 'FIDE GMs', 'Torneio Mundial de Xadrez', 'O maior torneio de xadrez do planeta.', '2021-03-28T21:06:10+00:00', '2021-04-28T21:06:10+00:00');
insert into Torneios values ('9a9817c7-d987-4a65-a322-9790f0ced469', 'Enxadristas Angolanos', 'Torneio Felicidade', 'Venha competir e ser feliz.', '2021-03-28T21:06:10+00:00', '2021-04-28T21:06:10+00:00');
insert into Torneios values ('0cfa37aa-9711-4e1c-885e-b7a481e68938', 'Enxadristas Otakus', 'Torneio Attack on Titan', 'Duelo entre os titãs do xadrez.', '2021-03-28T21:06:10+00:00', '2021-04-28T21:06:10+00:00');

-- Filiação Clube
insert into Filiacao_Clube values ('magnus', true, 'FIDE GMs');
insert into Filiacao_Clube values ('magnus', false, 'Enxadristas Otakus');
insert into Filiacao_Clube values ('caruana', false, 'Enxadristas Otakus');
insert into Filiacao_Clube values ('bobbyfischer', true, 'FIDE GMs');
insert into Filiacao_Clube values ('bobbyfischer', false, 'Enxadristas Otakus');
insert into Filiacao_Clube values ('hikaru', true, 'Enxadristas Angolanos');
insert into Filiacao_Clube values ('hikaru', true, 'Enxadristas Otakus');

-- Participação Torneio
insert into Participacao_Torneio values ('magnus', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');
insert into Participacao_Torneio values ('magnus', '9a9817c7-d987-4a65-a322-9790f0ced469');
insert into Participacao_Torneio values ('hikaru', '0cfa37aa-9711-4e1c-885e-b7a481e68938');
insert into Participacao_Torneio values ('caruana', '0cfa37aa-9711-4e1c-885e-b7a481e68938');
insert into Participacao_Torneio values ('bobbyfischer', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');

-- CORRECAO E2
-- Partida Torneio
insert into Partida_Torneio values ('d7a23240-d749-4aca-94ff-6d44e9fd0a48', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');
insert into Partida_Torneio values ('d7a23240-d749-4aca-94ff-6d44e9fd0149', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');
insert into Partida_Torneio values ('473448d3-efd3-43c9-8708-e0a38c3f6601', '0cfa37aa-9711-4e1c-885e-b7a481e68938');
insert into Partida_Torneio values ('fc32a022-69c4-41a6-94a7-3cf2f6ec7f68', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');
insert into Partida_Torneio values ('abc448d3-efd3-43c9-8708-e0a38c3f6601', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');
insert into Partida_Torneio values ('abc448d3-efd3-43c9-8708-e0a38c3f6699', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');
insert into Partida_Torneio values ('d8b23240-d749-4aca-94ff-6d44e9fd0a48', '0cfa37aa-9711-4e1c-885e-b7a481e68938');
insert into Partida_Torneio values ('abc448d3-efd3-43c9-8708-e0a38c3f6688', 'b3f8a9c1-e6cc-44af-a5d1-98cdd0a056a2');

-- Amizades
insert into Amizades values ('magnus', 'bobbyfischer');
insert into Amizades values ('magnus', 'caruana');
insert into Amizades values ('hikaru', 'caruana');
