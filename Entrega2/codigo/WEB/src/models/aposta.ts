import {rasbetResultado} from "./rasbetJogo";

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