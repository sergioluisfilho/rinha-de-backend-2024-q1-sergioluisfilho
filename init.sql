CREATE UNLOGGED
TABLE clientes (
    id SERIAL PRIMARY KEY, nome VARCHAR(50) NOT NULL, limite INTEGER NOT NULL
);

CREATE UNLOGGED
TABLE transacoes (
    id SERIAL PRIMARY KEY, cliente_id INTEGER NOT NULL, valor INTEGER NOT NULL, tipo CHAR(1) NOT NULL, descricao VARCHAR(10) NOT NULL, realizada_em TIMESTAMP NOT NULL DEFAULT NOW(), CONSTRAINT fk_clientes_transacoes_id FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

CREATE UNLOGGED
TABLE saldos (
    id SERIAL PRIMARY KEY, cliente_id INTEGER NOT NULL, valor INTEGER NOT NULL, CONSTRAINT fk_clientes_saldos_id FOREIGN KEY (cliente_id) REFERENCES clientes (id)
);

DO $$ 
BEGIN 
	INSERT INTO
	    clientes (nome, limite)
	VALUES (
	        'o barato sai caro', 1000 * 100
	    ),
	    ('zan corp ltda', 800 * 100),
	    ('les cruders', 10000 * 100),
	    (
	        'padaria joia de cocaia', 100000 * 100
	    ),
	    ('kid mais', 5000 * 100);
	INSERT INTO
	    saldos (cliente_id, valor)
	SELECT id, 0
	FROM clientes;
END;
$$; 

-- Cria a função que será chamada pelo trigger
CREATE OR REPLACE FUNCTION fn_atualiza_saldo() RETURNS 
TRIGGER AS 
$$
BEGIN
	-- Verifica se é um débito e subtrai o valor do saldo
	IF NEW.tipo = 'D' THEN
	UPDATE saldos
	SET
	    valor = valor - NEW.valor
	WHERE
	    cliente_id = NEW.cliente_id;
	-- Caso contrário, se for um crédito, adiciona o valor ao saldo
	ELSIF NEW.tipo = 'C' THEN
	UPDATE saldos
	SET
	    valor = valor + NEW.valor
	WHERE
	    cliente_id = NEW.cliente_id;
END
	IF;
	RETURN NEW;
END;
$$
LANGUAGE
plpgsql; 

-- Cria o trigger que chama a função fn_atualiza_saldo após cada inserção em transacoes
CREATE TRIGGER trg_atualiza_saldo AFTER
INSERT
    ON transacoes FOR EACH ROW
EXECUTE FUNCTION fn_atualiza_saldo ();