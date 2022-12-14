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
}

export enum Encargo {
  "apostador",
  "especialista",
  "administrador",
}
