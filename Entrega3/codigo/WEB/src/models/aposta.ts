import { rasbetResultado } from "./rasbetJogo";

export interface Aposta {
    items: Map<number,ApostaItem>,
    simples: boolean,
    valorTotal: number,
}

export interface ApostaItem {
    resultado: rasbetResultado,
    idjogo: number,
    valor: number,
}


export interface ApostaSistema {
    estado: string,
    data: string,
    idaposta: number,
    resultados: ResultadoSimples[],
    valor: number,
    nomeuser: string,
    idUser: number,
    simples: boolean,
}

export interface ResultadoSimples {
    nome: string,
    idjogo: number,
    awayteam: string,
    hometeam: string,
}