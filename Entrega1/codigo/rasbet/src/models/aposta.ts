import {rasbetOutcome} from "./rasbetOutcome";

export interface Aposta {
    id: string;
    gameID: string,
    winner: string,
    outcome: rasbetOutcome
    betPrice: number,
}