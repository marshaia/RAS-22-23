import { oddAuthor } from "./oddAuthor";

export interface rasbetOutcome {
    id:string
    descricao:string
    oddValue: number,
    oddAuthors: oddAuthor[],
}