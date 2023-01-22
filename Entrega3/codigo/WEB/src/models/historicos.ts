export interface HistoricoTrasacao {
    data: string,
    valor: number,
    descricao: string,
}

export interface HistoricoAposta {
    estado: string,
    data: string,
    valor: number,
    simples: boolean,
    resultados: ResultadoSimples[],
}

export interface ResultadoSimples {
    nome: string,
    hometeam: string,
    awayteam: string,
}