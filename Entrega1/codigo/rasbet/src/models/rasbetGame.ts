import {rasbetOutcome} from "./rasbetOutcome";

export interface rasbetGame {
    id: string;
    sport: string;
    competition: string;
    commenceTime: string;
    completed: boolean;
    blocked: boolean;
    outcomes: rasbetOutcome[]
    playerList?: string[];
    winner?: string;
    homeTeam?: string;
    awayTeam?: string;
    scores?: null;
}