export interface User {
  token: string;
  email: string;
  nome: string;
  datanascimento: string;
  nif: string;
  cc: string;
  valorcarteira: number;
  endereco: string;
  telefone: string;
  encargo: Encargo;
  jogos: number[];
}

export enum Encargo {
  "apostador",
  "especialista",
  "administrador",
}


export interface adminUser {
  idapostador: number,
  nome: string,
}