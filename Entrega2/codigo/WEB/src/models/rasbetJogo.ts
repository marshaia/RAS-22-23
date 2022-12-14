export interface rasbetJogo {
    idjogo: number;
    iddesporto: number;
    idcompeticao?: number;
    starttime: string;
    completed: boolean;
    resultados: rasbetResultado[];
    playerlist?: string[];
    winner?: string;
    hometeam?: string;
    awayteam?: string;
    score?: string;
}


export interface rasbetDesporto {
    iddesporto:number,
    nome:string,
    individual: boolean,
    empate: boolean,
}

export interface rasbetCompeticao {
    idcompeticao:number,
    nome:string,
    iddesporto: string,
}

export interface rasbetResultado {
    idresultado :number,
    cota: number,
    nome: string,
}