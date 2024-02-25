import { Router } from "express";
import { transacao } from "./services/transacao.js";
const routes = Router();

routes.post("/clientes/:id/transacoes", async (req, res) => {
  const { id } = req.params;
  const { status, body } = await transacao({ id, body: req.body });
  res.status(status).json(body);
});

routes.get("/clientes/:id/extrato", (req, res) => {
  res.json({
    saldo: {
      total: -9098,
      data_extrato: "2024-01-17T02:34:41.217753Z",
      limite: 100000,
    },
    ultimas_transacoes: [
      {
        valor: 10,
        tipo: "c",
        descricao: "descricao",
        realizada_em: "2024-01-17T02:34:38.543030Z",
      },
      {
        valor: 90000,
        tipo: "d",
        descricao: "descricao",
        realizada_em: "2024-01-17T02:34:38.543030Z",
      },
    ],
  });
});

export default routes;
