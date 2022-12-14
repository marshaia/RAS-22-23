import { Aposta } from "./aposta";
import { Transacao } from "./transacao";

export interface User {
  name: string;
  email: string;
  password: string;
  token: string;
  birthDate: string;
  nif: string;
  carteira: number;
  morada: string;
  nrtelemovel: string;
  cc: string;
  historicoApostas: Aposta[] | null;
  historicoTransacos: Transacao[] | null;
  encargo: Encargo;
}

export enum Encargo {
  apostador,
  especialista,
  admin,
}
