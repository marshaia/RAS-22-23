import {rasbetGame} from "./rasbetGame";
import {rasbetOutcome} from "./rasbetOutcome";
import {oddAuthor} from "./oddAuthor";
import {idState} from "../stores/idStore"

interface outcome {
  name: string;
  price: number;
}

interface market {
  key: string;
  outcomes: outcome[];
}

interface bookmaker {
  key: string;
  lastUpdate: string;
  markets: market[];
}

export interface apiGame {
  id: string;
  awayTeam: string;
  bookmakers: bookmaker[];
  commenceTime: string;
  completed: boolean;
  homeTeam: string;
  scores: null;
}

export function convertApiGameToRasbet(game : apiGame,sport : string) : rasbetGame{

  const idStore = idState();
  let list : Map<string,rasbetOutcome> = new Map<string,rasbetOutcome>();
  let outcomeList : rasbetOutcome[] = [];

  game.bookmakers.forEach((book) => {
    let siteName = book.key
    book.markets.forEach(( market) => {
      market.outcomes.forEach((outcome) => {
        if(list.has(outcome.name)){
          list.get(outcome.name)?.oddAuthors.push({id:idStore.getNewOutcomeAuthorId(),idEspecialista:siteName,odd:outcome.price});
        }
        else{
          list.set(outcome.name,{
            id:idStore.getNewOutcomeId(),
            descricao:outcome.name,
            oddValue:outcome.price,
            oddAuthors:[{id:idStore.getNewOutcomeAuthorId(),idEspecialista:siteName,odd:outcome.price}],
          })
        }
      })
    })
  })

  //Média de todos as odds previstas
  list.forEach((outcome) => {
    let sum = 0; let count = 0;
    outcome.oddAuthors.forEach((auth) => {
      sum += auth.odd;
      count++;
    })
    outcome.oddValue = Math.ceil(sum/count*100)/100;
    outcomeList.push(outcome)
  })

  return {
    id: game.id,
    sport: sport,
    competition: "none",
    blocked: false,
    commenceTime: game.commenceTime,
    completed: game.completed,
    playerList: [],
    winner: "",
    homeTeam: game.homeTeam,
    awayTeam: game.awayTeam,
    scores: game.scores,
    outcomes: outcomeList,
  };
}
