import pool from "../pool.js";

export const transacao = async ({ id, body }) => {
  try {
    const { valor, tipo, descricao } = body;

    const transacao = await pool.query(
      "INSERT INTO public.transacoes (cliente_id, valor, tipo, descricao) VALUES ($1, $2, $3, $4)",
      [id, valor, tipo, descricao]
    );
    return {
      status: 200,
      body: {},
    };
  } catch (error) {
    console.log(error);
    let status, body;
    if (
      error.message.includes(
        `violates foreign key constraint "fk_clientes_transacoes_id"`
      )
    ) {
      status = 404;
    } else {
      status = 400;
    }

    return {
      status,
      body,
    };
  }
};
